import 'package:flutter/cupertino.dart';
import '../model/chat_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
class ChatProvider extends ChangeNotifier {
  final ChatService _chatService = ChatService();
  bool isLoading = false;
  List<dynamic> conversations = [];
  final TextEditingController msgController = TextEditingController();
  final FocusNode msgFocus = FocusNode();
  List<dynamic> messages = [];
  int? currentUserId;
  WebSocketChannel? channel;

  Future<int?> _getCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id'); // adjust key to match your login save
  }
  Future<void> initUser() async {
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

  void clearMessages() {
    messages = [];
    notifyListeners();
  }

  Future<void> getAllConversations() async {
    try {
      isLoading = true;
      notifyListeners();
      currentUserId = await _getCurrentUserId();
      final raw = await _chatService.getAllConversations();
      notifyListeners();
      conversations = raw.map((conv) {
        final user1 = conv["user1"] ?? {};
        final user2 = conv["user2"] ?? {};
        final otherUser = (user1["id"].toString() == currentUserId.toString()) ? user2 : user1;
        final resolvedName =
        (otherUser["name"] != null && otherUser["name"].toString().isNotEmpty)
            ? otherUser["name"].toString()
            : (otherUser["username"] ?? "");

        // ✅ Resolve image safely
        final resolvedImage = otherUser["profile_image"]?.toString() ?? "";

        return {
          "id": conv["id"],
          "user": {
            "id": otherUser["id"],
            "name": resolvedName,
            "profile_image": resolvedImage,
            "is_online": otherUser["is_online"] ?? false,
          },
          "last_message": "",
          "time": _formatTime(conv["created_at"]),
          "unread_count": 0,
        };
      }).toList();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getConversationMessages(int userId) async {
    try {
      isLoading = true;
      notifyListeners();

      final currentUserId = await _getCurrentUserId();
      final result = await _chatService.getConversationMessages(userId);

      if (result == null || result.containsKey("error")) {
        messages = [];
        return;
      }

      final raw = result["messages"] as List<dynamic>? ?? [];

      messages = raw.map((msg) {
        return {
          "id": msg["id"],
          "is_me": msg["sender_id"] == currentUserId,
          "text": msg["content"] ?? "",
          "time": _formatTime(msg["timestamp"]),
          "is_read": msg["is_read"] ?? false,
        };
      }).toList();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }


  Future<void> connectSocket(int receiverId,int senderId) async {
    channel = WebSocketChannel.connect(
      Uri.parse(
        "ws://192.168.100.11:8000/ws/chat/$senderId/$receiverId/",
      ),
    );
    channel!.stream.listen((data) {
      final msg = jsonDecode(data);
      messages.add({
        "id": msg["id"],
        "sender_id": msg["sender_id"],
        "receiver_id": msg["receiver_id"],
        "content": msg["content"] ?? "",
        "timestamp": _formatTime(msg["timestamp"]),
        "is_read": msg["is_read"] ?? false,
      });
      notifyListeners();
    });
  }

  void sendMessage(String text) {
    if (channel == null || text.trim().isEmpty) return;

    channel!.sink.add(
      jsonEncode({
        "content": text.trim(),
      }),
    );
  }

  void disconnectSocket() {
    channel?.sink.close();
  }
  void clear() {
    msgController.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    msgController.dispose();
    msgFocus.dispose();
    super.dispose();
  }
}