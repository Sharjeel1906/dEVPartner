import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../model/api_client.dart';
import '../model/chat_services.dart';

class ChatProvider extends ChangeNotifier {
  final ChatService _chatService = ChatService();
  bool isLoading = false;
  List<dynamic> conversations = [];
  final TextEditingController msgController = TextEditingController();
  final FocusNode msgFocus = FocusNode();
  List<dynamic> messages = [];
  int? currentUserId;
  WebSocketChannel? channel;
  StreamSubscription? _socketSub;

  static int _parseUnread(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? "") ?? 0;
  }

  static int? _parseId(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? "");
  }

  static bool _sameId(dynamic a, dynamic b) {
    final idA = _parseId(a);
    final idB = _parseId(b);
    return idA != null && idB != null && idA == idB;
  }

  Future<int?> _getCurrentUserId() async {
    if (currentUserId != null) return currentUserId;
    final prefs = await SharedPreferences.getInstance();
    final fromPrefs = prefs.getInt("user_id");
    if (fromPrefs != null) {
      currentUserId = fromPrefs;
      return fromPrefs;
    }
    final userJson = prefs.getString("user");
    if (userJson != null) {
      final user = jsonDecode(userJson) as Map<String, dynamic>;
      currentUserId = _parseId(user["id"]);
      if (currentUserId != null) {
        await prefs.setInt("user_id", currentUserId!);
      }
    }
    return currentUserId;
  }

  Future<void> initUser() async {
    currentUserId = null;
    currentUserId = await _getCurrentUserId();
    notifyListeners();
  }

  String _formatTime(String? isoTimestamp) {
    if (isoTimestamp == null) return "";
    try {
      final dt = DateTime.parse(isoTimestamp).toLocal();
      final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
      final minute = dt.minute.toString().padLeft(2, '0');
      final period = dt.hour >= 12 ? 'PM' : 'AM';
      return "$hour:$minute $period";
    } catch (_) {
      return "";
    }
  }

  String _resolveImageUrl(dynamic path) {
    final p = path?.toString() ?? "";
    if (p.isEmpty) return "";
    if (p.startsWith("http")) return p;
    return "${ApiClient.baseUrl.replaceAll('/FYP_Partner_Finder', '')}$p";
  }

  Map<String, dynamic> _mapMessage(Map<String, dynamic> msg, int? myId) {
    final senderId = _parseId(msg["sender_id"]);
    return {
      "id": msg["id"],
      "sender_id": senderId,
      "is_me": senderId != null && senderId == myId,
      "text": msg["content"] ?? msg["text"] ?? "",
      "time": _formatTime(msg["timestamp"]?.toString()),
      "is_read": msg["is_read"] ?? false,
    };
  }

  void clearMessages() {
    messages = [];
    notifyListeners();
  }

  Map<String, dynamic> _resolveOtherUser(Map<String, dynamic> conv, int? myId) {
    final user1 = conv["user1"] is Map
        ? Map<String, dynamic>.from(conv["user1"] as Map)
        : <String, dynamic>{};
    final user2 = conv["user2"] is Map
        ? Map<String, dynamic>.from(conv["user2"] as Map)
        : <String, dynamic>{};

    Map<String, dynamic> otherUser;
    if (_sameId(user1["id"], myId)) {
      otherUser = user2;
    } else if (_sameId(user2["id"], myId)) {
      otherUser = user1;
    } else {
      otherUser = user2.isNotEmpty ? user2 : user1;
    }

    if (_sameId(otherUser["id"], myId)) {
      otherUser = _sameId(user1["id"], myId) ? user2 : user1;
    }

    return otherUser;
  }

  // ─── NEW: mark conversation as read and persist last seen message id ───
  Future<void> markConversationAsRead(int otherUserId) async {
    if (messages.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    final lastId = _parseId(messages.last["id"]);
    if (lastId != null) {
      await prefs.setInt("last_read_$otherUserId", lastId);
    }
    // immediately zero-out the badge in the list
    final idx = conversations.indexWhere(
          (c) => _sameId(c["user"]?["id"], otherUserId),
    );
    if (idx != -1) {
      conversations[idx] = Map<String, dynamic>.from(conversations[idx])
        ..["unread_count"] = 0;
      notifyListeners();
    }
  }

  // ─── NEW: compute unread count locally from loaded messages ───
  Future<int> _computeUnread(int otherUserId, List<dynamic> msgs) async {
    final prefs = await SharedPreferences.getInstance();
    final lastReadId = prefs.getInt("last_read_$otherUserId");

    if (lastReadId == null) {
      // never opened — every received message is unread
      return msgs.where((m) => m["is_me"] == false).length;
    }

    int count = 0;
    for (final msg in msgs) {
      if (msg["is_me"] == false) {
        final msgId = _parseId(msg["id"]);
        if (msgId != null && msgId > lastReadId) {
          count++;
        }
      }
    }
    return count;
  }

  Future<void> getAllConversations() async {
    try {
      isLoading = true;
      notifyListeners();

      currentUserId = await _getCurrentUserId();
      final raw = await _chatService.getAllConversations();

      conversations = raw
          .whereType<Map>()
          .map((conv) {
        final c = Map<String, dynamic>.from(conv);
        final otherUser = _resolveOtherUser(c, currentUserId);

        if (_sameId(otherUser["id"], currentUserId)) {
          return null;
        }

        final resolvedName =
        (otherUser["name"]?.toString().isNotEmpty == true)
            ? otherUser["name"].toString()
            : (otherUser["username"] ?? "").toString();

        final lastMsg = c["last_message"];
        String lastText = "";
        String? lastTime;

        if (lastMsg is Map) {
          lastText = (lastMsg["content"] ?? lastMsg["text"] ?? "")
              .toString();
          lastTime = lastMsg["timestamp"]?.toString();
        } else if (lastMsg is String) {
          lastText = lastMsg;
        }

        lastText = lastText.isNotEmpty
            ? lastText
            : (c["last_message_text"] ?? c["message_preview"] ?? "")
            .toString();

        final timeSource =
            lastTime ??
                c["last_message_time"]?.toString() ??
                c["updated_at"]?.toString() ??
                c["created_at"]?.toString();

        return {
          "id": c["id"],
          "user": {
            "id": otherUser["id"],
            "name": resolvedName,
            "username": otherUser["username"] ?? resolvedName,
            "profile_image": _resolveImageUrl(
              otherUser["profile_image"] ?? otherUser["pfp_path"],
            ),
            "is_online": otherUser["is_online"] == true,
          },
          "last_message": lastText,
          "time": _formatTime(timeSource),
          "unread_count": _parseUnread(c["unread_count"]),
        };
      })
          .whereType<Map<String, dynamic>>()
          .toList();

      // Show the list immediately so the UI is responsive
      isLoading = false;
      notifyListeners();

      // Now compute unread counts in the background
      await _recomputeUnreadCounts();

    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ─── NEW: fetch each conversation's messages and compute unread locally ───
  Future<void> _recomputeUnreadCounts() async {
    final myId = currentUserId;
    final List<Map<String, dynamic>> localConvs = List<Map<String, dynamic>>.from(
      conversations.whereType<Map<String, dynamic>>(),
    );

    for (int i = 0; i < localConvs.length; i++) {
      final conv = localConvs[i];
      final otherUserId = _parseId(conv["user"]?["id"]);
      if (otherUserId == null) continue;

      final result = await _chatService.getConversationMessages(otherUserId);
      if (result == null || result.containsKey("error")) continue;

      final raw = result["messages"] as List<dynamic>? ?? [];
      final msgs = raw
          .map((m) => _mapMessage(Map<String, dynamic>.from(m as Map), myId))
          .toList();

      final unread = await _computeUnread(otherUserId, msgs);

      if (conversations.isEmpty) return;

      final liveIdx = conversations.indexWhere((c) => _sameId(c["id"], conv["id"]));
      if (liveIdx != -1) {
        conversations[liveIdx] = Map<String, dynamic>.from(conversations[liveIdx])
          ..["unread_count"] = unread;
        notifyListeners();
      }
    }
  }

  Future<void> getConversationMessages(int userId) async {
    try {
      isLoading = true;
      notifyListeners();

      final myId = await _getCurrentUserId();
      final result = await _chatService.getConversationMessages(userId);

      if (result == null || result.containsKey("error")) {
        messages = [];
        return;
      }

      final raw = result["messages"] as List<dynamic>? ?? [];

      messages = raw
          .map((m) => _mapMessage(Map<String, dynamic>.from(m as Map), myId))
          .toList();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void _onSocketMessage(dynamic data, int? myId) {
    final msg = jsonDecode(data) as Map<String, dynamic>;
    final mapped = _mapMessage(msg, myId);
    final msgId = mapped["id"];

    if (msgId != null && messages.any((m) => m["id"] == msgId)) {
      return;
    }

    messages.add(mapped);

    if (mapped["id"] != null) {
      final senderId = _parseId(msg["sender_id"]);
      if (senderId != null && senderId != myId) {
        SharedPreferences.getInstance().then((prefs) {
          prefs.setInt("last_read_$senderId", _parseId(mapped["id"])!);
        });
      }
    }

    notifyListeners();
  }

  Future<void> connectSocket(int receiverId, int senderId) async {
    disconnectSocket();

    final myId = await _getCurrentUserId();

    channel = WebSocketChannel.connect(
      Uri.parse("ws://192.168.100.11:8000/ws/chat/$senderId/$receiverId/"),
    );

    _socketSub = channel!.stream.listen((data) {
      _onSocketMessage(data, myId);
    });
  }

  void sendMessage(String text) {
    if (channel == null || text.trim().isEmpty) return;
    channel!.sink.add(jsonEncode({"content": text.trim()}));
  }

  Future<void> deleteMessages(List<int> messageIds) async {
    final deletedIds = <int>[];
    for (final id in messageIds) {
      final success = await _chatService.deleteMessage(id);
      if (success) {
        deletedIds.add(id);
      }
    }
    messages.removeWhere(
          (m) => deletedIds.contains(_parseId(m["id"])),
    );
    notifyListeners();
  }

  Future<void> deleteConversations(List<int> conversationIds) async {
    final deletedIds = <int>[];
    for (final id in conversationIds) {
      final success = await _chatService.deleteConversation(id);
      if (success) {
        deletedIds.add(id);
      }
    }
    conversations.removeWhere(
          (c) => deletedIds.contains(_parseId(c["id"])),
    );
    notifyListeners();
  }

  void resetSession() {
    conversations.clear();
    msgController.clear();
    isLoading = false;
    currentUserId = null;
    notifyListeners();
  }

  void disconnectSocket() {
    _socketSub?.cancel();
    _socketSub = null;
    channel?.sink.close();
    channel = null;
  }

  void clear() {
    msgController.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    disconnectSocket();
    msgController.dispose();
    msgFocus.dispose();
    super.dispose();
  }
}