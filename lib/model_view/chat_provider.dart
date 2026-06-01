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
  bool isMessagesLoading = false;
  List<dynamic> conversations = [];
  final TextEditingController msgController = TextEditingController();
  final FocusNode msgFocus = FocusNode();
  List<dynamic> messages = [];
  int? currentUserId;
  int? activeChatUserId;
  bool isPartnerTyping = false;

  WebSocketChannel? channel;
  StreamSubscription? _socketSub;
  WebSocketChannel? _globalChannel;
  StreamSubscription? _globalSocketSub;
  Timer? _typingStopTimer;
  bool _typingActive = false;

  final Map<int, bool> _onlineByUserId = {};

  static const String _wsHost =
      'wss://fyp-partner-finder-app-backend-production.up.railway.app';

  static int _parseUnread(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? "") ?? 0;
  }

  static int? _parseId(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? "");
  }

  static int? parseUserId(dynamic value) => _parseId(value);

  static bool _sameId(dynamic a, dynamic b) {
    final idA = _parseId(a);
    final idB = _parseId(b);
    return idA != null && idB != null && idA == idB;
  }

  static bool _isTruthy(dynamic value) {
    if (value == true) return true;
    if (value is num) return value != 0;
    final s = value?.toString().toLowerCase().trim();
    return s == "true" || s == "1" || s == "yes";
  }

  static int _extractUnreadFromConv(
    Map<String, dynamic> c,
    Map<String, dynamic> otherUser,
  ) {
    for (final key in ["unread_count", "unread", "unread_messages"]) {
      if (c[key] != null) return _parseUnread(c[key]);
    }
    for (final key in ["unread_count", "unread"]) {
      if (otherUser[key] != null) return _parseUnread(otherUser[key]);
    }
    return 0;
  }

  static int? _eventUserId(Map<String, dynamic> msg) {
    return _parseId(
      msg["sender_id"] ??
          msg["user_id"] ??
          msg["from_user_id"] ??
          msg["user"],
    );
  }

  Map<String, dynamic>? _normalizeSocketPayload(dynamic data) {
    try {
      final decoded = jsonDecode(data);
      if (decoded is! Map) return null;
      var msg = Map<String, dynamic>.from(decoded);
      if (msg["message"] is Map) {
        final inner = Map<String, dynamic>.from(msg["message"] as Map);
        msg = {...inner, ...msg}..remove("message");
      }
      return msg;
    } catch (_) {
      return null;
    }
  }

  bool isUserOnline(int userId) => _onlineByUserId[userId] == true;

  Future<void> _persistUnreadCount(int otherUserId, int count) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("unread_$otherUserId", count);
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
    if (currentUserId == null) {
      currentUserId = await _getCurrentUserId();
      notifyListeners();
    }
  }

  void setActiveChatPartner(int? userId) {
    activeChatUserId = userId;
    isPartnerTyping = false;
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

  Map<String, dynamic> _mapConversationFromApi(
    Map<String, dynamic> c,
    int? myId,
  ) {
    final otherUser = _resolveOtherUser(c, myId);
    final otherId = _parseId(otherUser["id"]);
    if (otherId != null && _isTruthy(otherUser["is_online"])) {
      _onlineByUserId[otherId] = true;
    }
    final isOnline = otherId != null && _onlineByUserId[otherId] == true;

    final resolvedName = (otherUser["name"]?.toString().isNotEmpty == true)
        ? otherUser["name"].toString()
        : (otherUser["username"] ?? "").toString();

    final lastMsg = c["last_message"];
    String lastText = "";
    String? lastTime;

    if (lastMsg is Map) {
      lastText = (lastMsg["content"] ?? lastMsg["text"] ?? "").toString();
      lastTime = lastMsg["timestamp"]?.toString();
    } else if (lastMsg is String) {
      lastText = lastMsg;
    }

    lastText = lastText.isNotEmpty
        ? lastText
        : (c["last_message_text"] ?? c["message_preview"] ?? "").toString();

    final timeSource = lastTime ??
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
        "is_online": isOnline,
      },
      "last_message": lastText,
      "time": _formatTime(timeSource),
      "unread_count": _extractUnreadFromConv(c, otherUser),
    };
  }

  Future<void> markConversationAsRead(int otherUserId) async {
    await _chatService.markMessagesRead(otherUserId);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("unread_$otherUserId", 0);
    if (messages.isNotEmpty) {
      final lastId = _parseId(messages.last["id"]);
      if (lastId != null) {
        await prefs.setInt("last_read_$otherUserId", lastId);
      }
    }

    final idx = conversations.indexWhere(
      (c) => _sameId(c["user"]?["id"], otherUserId),
    );
    if (idx != -1) {
      conversations[idx] = Map<String, dynamic>.from(conversations[idx])
        ..["unread_count"] = 0;
      notifyListeners();
    }
  }

  Future<void> getAllConversations({
    bool force = false,
    bool recomputeUnread = false,
    bool showLoading = true,
  }) async {
    if (!force && conversations.isNotEmpty) return;
    final showSpinner = showLoading && conversations.isEmpty;
    try {
      if (showSpinner) {
        isLoading = true;
        notifyListeners();
      }

      currentUserId = await _getCurrentUserId();
      final raw = await _chatService.getAllConversations();
      if (raw == null) return;

      final prefs = await SharedPreferences.getInstance();
      final previousByUserId = <int, Map<String, dynamic>>{};
      for (final conv in conversations) {
        if (conv is! Map) continue;
        final uid = _parseId(conv["user"]?["id"]);
        if (uid != null) {
          previousByUserId[uid] = Map<String, dynamic>.from(conv);
        }
      }

      final next = raw
          .whereType<Map>()
          .map((conv) {
            final c = Map<String, dynamic>.from(conv);
            final otherUser = _resolveOtherUser(c, currentUserId);
            if (_sameId(otherUser["id"], currentUserId)) {
              return null;
            }
            return _mapConversationFromApi(c, currentUserId);
          })
          .whereType<Map<String, dynamic>>()
          .toList();

      for (var i = 0; i < next.length; i++) {
        final uid = _parseId(next[i]["user"]?["id"]);
        if (uid == null) continue;

        final prev = previousByUserId[uid];
        final storedUnread = prefs.getInt("unread_$uid") ?? 0;
        final apiUnread = _parseUnread(next[i]["unread_count"]);
        final prevUnread =
            prev != null ? _parseUnread(prev["unread_count"]) : 0;
        final mergedUnread = [
          storedUnread,
          apiUnread,
          prevUnread,
        ].reduce((a, b) => a > b ? a : b);

        final user = Map<String, dynamic>.from(next[i]["user"] as Map);
        user["is_online"] = _onlineByUserId[uid] == true;
        next[i] = Map<String, dynamic>.from(next[i])
          ..["unread_count"] = mergedUnread
          ..["user"] = user;
      }

      conversations = next;

      isLoading = false;
      notifyListeners();

      if (recomputeUnread) {
        await _recomputeUnreadCounts();
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshInbox({bool recomputeUnread = false}) async {
    await getAllConversations(
      force: true,
      recomputeUnread: recomputeUnread,
      showLoading: false,
    );
  }

  Future<void> _recomputeUnreadCounts() async {
    final myId = currentUserId;
    final localConvs = List<Map<String, dynamic>>.from(
      conversations.whereType<Map<String, dynamic>>(),
    );

    for (final conv in localConvs) {
      final otherUserId = _parseId(conv["user"]?["id"]);
      if (otherUserId == null) continue;

      final result = await _chatService.getConversationMessages(otherUserId);
      if (result == null || result.containsKey("error")) continue;

      final raw = result["messages"] as List<dynamic>? ?? [];
      final msgs = raw
          .map((m) => _mapMessage(Map<String, dynamic>.from(m as Map), myId))
          .toList();

      final prefs = await SharedPreferences.getInstance();
      final lastReadId = prefs.getInt("last_read_$otherUserId");
      int unread = 0;
      for (final msg in msgs) {
        if (msg["is_me"] == false) {
          final msgId = _parseId(msg["id"]);
          if (lastReadId == null || (msgId != null && msgId > lastReadId)) {
            unread++;
          }
        }
      }

      final liveIdx = conversations.indexWhere((c) => _sameId(c["id"], conv["id"]));
      if (liveIdx != -1) {
        conversations[liveIdx] = Map<String, dynamic>.from(conversations[liveIdx])
          ..["unread_count"] = unread;
        await _persistUnreadCount(otherUserId, unread);
      }
    }
    notifyListeners();
  }

  void _upsertInboxFromMessage(
    Map<String, dynamic> msg,
    int? myId, {
    Map<String, dynamic>? partnerUser,
  }) {
    final senderId = _parseId(msg["sender_id"]);
    final receiverId = _parseId(msg["receiver_id"]);
    final otherId = _sameId(senderId, myId) ? receiverId : senderId;
    if (otherId == null) return;

    final text = (msg["content"] ?? msg["text"] ?? "").toString();
    final timestamp =
        msg["timestamp"]?.toString() ?? DateTime.now().toIso8601String();
    final isIncoming = !_sameId(senderId, myId);
    final inActiveChat =
        activeChatUserId != null && _sameId(activeChatUserId, otherId);

    var idx = conversations.indexWhere(
      (c) => _sameId(c["user"]?["id"], otherId),
    );

    Map<String, dynamic> entry;
    if (idx == -1) {
      final pu = partnerUser ?? {};
      entry = {
        "id": msg["conversation_id"] ?? msg["conv_id"],
        "user": {
          "id": otherId,
          "name": pu["name"] ?? pu["username"] ?? "User",
          "username": pu["username"] ?? pu["name"] ?? "User",
          "profile_image": _resolveImageUrl(
            pu["profile_image"] ?? pu["pfp_path"],
          ),
          "is_online": _onlineByUserId[otherId] ?? false,
        },
        "last_message": text,
        "time": _formatTime(timestamp),
        "unread_count": 0,
      };
    } else {
      entry = Map<String, dynamic>.from(conversations[idx]);
      conversations.removeAt(idx);
    }

    entry["last_message"] = text;
    entry["time"] = _formatTime(timestamp);
    if (isIncoming && !inActiveChat) {
      final nextUnread = _parseUnread(entry["unread_count"]) + 1;
      entry["unread_count"] = nextUnread;
      _persistUnreadCount(otherId, nextUnread);
    } else if (inActiveChat) {
      entry["unread_count"] = 0;
      _persistUnreadCount(otherId, 0);
    }

    if (isIncoming && _parseId(senderId) != null) {
      _setUserOnline(_parseId(senderId), true);
    }

    conversations.insert(0, entry);
    notifyListeners();
  }

  void _setUserOnline(int? userId, bool online) {
    if (userId == null) return;
    _onlineByUserId[userId] = online;

    for (var i = 0; i < conversations.length; i++) {
      if (_sameId(conversations[i]["user"]?["id"], userId)) {
        final user = Map<String, dynamic>.from(conversations[i]["user"] as Map);
        user["is_online"] = online;
        conversations[i] = Map<String, dynamic>.from(conversations[i])
          ..["user"] = user;
      }
    }
    notifyListeners();
  }

  void _sendSocketJson(WebSocketChannel? socket, Map<String, dynamic> payload) {
    if (socket == null) return;
    try {
      socket.sink.add(jsonEncode(payload));
    } catch (e) {
      debugPrint("Socket send failed: $e");
    }
  }

  void _handleTypingEvent(
    Map<String, dynamic> msg, {
    int? chatPartnerId,
  }) {
    final partnerId = chatPartnerId ?? activeChatUserId;
    if (partnerId == null) return;

    final typerId = _eventUserId(msg);
    if (typerId != null && !_sameId(typerId, partnerId)) return;

    final type = (msg["type"] ?? msg["event"] ?? "").toString().toLowerCase();
    bool? typing;
    if (msg.containsKey("typing")) {
      typing = _isTruthy(msg["typing"]);
    }
    if (msg.containsKey("is_typing")) {
      typing = _isTruthy(msg["is_typing"]);
    }
    if (type.contains("stop")) {
      typing = false;
    } else if (type.contains("start") || type.contains("typing")) {
      typing ??= true;
    }

    if (typing != null) {
      isPartnerTyping = typing;
      notifyListeners();
    }
  }

  void _handleRawSocketEvent(
    dynamic data,
    int? myId, {
    int? chatPartnerId,
  }) {
    final msg = _normalizeSocketPayload(data);
    if (msg == null) return;

    final type = (msg["type"] ?? msg["event"] ?? "message").toString().toLowerCase();

    if (type.contains("typing") ||
        msg.containsKey("typing") ||
        msg.containsKey("is_typing")) {
      _handleTypingEvent(msg, chatPartnerId: chatPartnerId);
      return;
    }

    switch (type) {
      case "typing_start":
      case "typing_indicator":
        _handleTypingEvent({...msg, "typing": true}, chatPartnerId: chatPartnerId);
        return;
      case "typing_stop":
        _handleTypingEvent({...msg, "typing": false}, chatPartnerId: chatPartnerId);
        return;
      case "user_online":
      case "online":
      case "presence_online":
      case "user_joined":
        _setUserOnline(_eventUserId(msg), true);
        return;
      case "user_offline":
      case "offline":
      case "presence_offline":
      case "user_left":
        _setUserOnline(_eventUserId(msg), false);
        return;
      case "is_online":
      case "presence_event":
        _setUserOnline(
          _eventUserId(msg),
          _isTruthy(msg["is_online"]),
        );
        return;
      default:
        break;
    }

    if (msg["online_users"] is List) {
      for (final id in msg["online_users"] as List) {
        _setUserOnline(_parseId(id), true);
      }
      return;
    }

    if (!msg.containsKey("content") &&
        !msg.containsKey("text") &&
        type != "message" &&
        type != "chat_message") {
      return;
    }

    _upsertInboxFromMessage(msg, myId);

    final partnerId = chatPartnerId ?? activeChatUserId;
    final senderId = _parseId(msg["sender_id"]);
    final isForActiveChat = partnerId != null &&
        (_sameId(senderId, partnerId) ||
            _sameId(msg["receiver_id"], partnerId) ||
            _sameId(senderId, myId) && _sameId(msg["receiver_id"], partnerId));

    if (isForActiveChat) {
      final mapped = _mapMessage(msg, myId);
      final msgId = mapped["id"];
      if (msgId != null && messages.any((m) => m["id"] == msgId)) {
        return;
      }
      messages.add(mapped);
      if (!_sameId(senderId, myId)) {
        _setUserOnline(senderId, true);
        markConversationAsRead(partnerId);
      }
      notifyListeners();
    }
  }

  Future<void> getConversationMessages(int userId) async {
    try {
      isMessagesLoading = true;
      notifyListeners();

      final myId = await _getCurrentUserId();
      final result = await _chatService.getConversationMessages(userId);

      if (result == null || result.containsKey("error")) {
        if (messages.isEmpty) messages = [];
        return;
      }

      final raw = result["messages"] as List<dynamic>? ?? [];

      messages = raw
          .map((m) => _mapMessage(Map<String, dynamic>.from(m as Map), myId))
          .toList();
    } finally {
      isMessagesLoading = false;
      notifyListeners();
    }
  }

  /// Backend only exposes ws/chat/<sender>/<receiver>/ — no global user socket.
  Future<void> connectGlobalSocket() async {}

  void disconnectGlobalSocket() {
    _globalSocketSub?.cancel();
    _globalSocketSub = null;
    _globalChannel?.sink.close();
    _globalChannel = null;
  }

  Future<void> connectSocket(int receiverId, int senderId) async {
    disconnectSocket();

    final myId = await _getCurrentUserId();
    activeChatUserId = receiverId;
    isPartnerTyping = false;

    final uri = Uri.parse("$_wsHost/ws/chat/$senderId/$receiverId/");
    channel = WebSocketChannel.connect(uri);

    _socketSub?.cancel();
    _socketSub = channel!.stream.listen(
      (data) => _handleRawSocketEvent(
        data,
        myId,
        chatPartnerId: receiverId,
      ),
      onError: (e) => debugPrint("Socket error: $e"),
    );

  }

  void sendTypingStart(int receiverId) {
    if (_typingActive || channel == null) return;
    _typingActive = true;
    _sendSocketJson(channel, {"typing": true});
  }

  void sendTypingStop(int receiverId) {
    if (receiverId <= 0 || channel == null) return;
    if (!_typingActive) return;
    _typingActive = false;
    _sendSocketJson(channel, {"typing": false});
  }

  void onChatTextChanged(int receiverId) {
    sendTypingStart(receiverId);
    _typingStopTimer?.cancel();
    _typingStopTimer = Timer(const Duration(milliseconds: 1500), () {
      sendTypingStop(receiverId);
    });
  }

  void sendMessage(String text, {int? receiverId}) {
    if (channel == null || text.trim().isEmpty) return;

    final trimmed = text.trim();
    final myId = currentUserId;
    final partnerId = receiverId ?? activeChatUserId;

    try {
      channel!.sink.add(jsonEncode({"content": trimmed}));
    } catch (e) {
      debugPrint("Failed to send message: $e");
      return;
    }

    sendTypingStop(partnerId ?? 0);

    final optimistic = _mapMessage({
      "id": DateTime.now().millisecondsSinceEpoch,
      "sender_id": myId,
      "content": trimmed,
      "timestamp": DateTime.now().toIso8601String(),
      "is_read": true,
    }, myId);
    messages.add(optimistic);

    if (partnerId != null) {
      _upsertInboxFromMessage({
        "sender_id": myId,
        "receiver_id": partnerId,
        "content": trimmed,
        "timestamp": DateTime.now().toIso8601String(),
      }, myId);
    }

    notifyListeners();
  }

  Future<void> deleteMessages(List<int> messageIds) async {
    final deletedIds = <int>[];
    for (final id in messageIds) {
      final success = await _chatService.deleteMessage(id);
      if (success) {
        deletedIds.add(id);
      }
    }
    messages.removeWhere((m) => deletedIds.contains(_parseId(m["id"])));
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
    conversations.removeWhere((c) => deletedIds.contains(_parseId(c["id"])));
    notifyListeners();
  }

  void resetSession() {
    disconnectSocket();
    disconnectGlobalSocket();
    conversations.clear();
    messages.clear();
    msgController.clear();
    isLoading = false;
    currentUserId = null;
    activeChatUserId = null;
    isPartnerTyping = false;
    _onlineByUserId.clear();
    notifyListeners();
  }

  void disconnectSocket() {
    _typingStopTimer?.cancel();
    _typingActive = false;
    isPartnerTyping = false;
    _socketSub?.cancel();
    _socketSub = null;
    channel?.sink.close();
    channel = null;
    activeChatUserId = null;
  }

  void clear() {
    msgController.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    disconnectSocket();
    disconnectGlobalSocket();
    msgController.dispose();
    msgFocus.dispose();
    super.dispose();
  }
}
