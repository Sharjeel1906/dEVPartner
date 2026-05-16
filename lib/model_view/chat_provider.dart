import 'package:flutter/cupertino.dart';
import '../model/chat_services.dart';

class ChatProvider extends ChangeNotifier {
  final ChatService _chatService = ChatService();
  bool isLoading = false;
  final TextEditingController msgController = TextEditingController();
  final FocusNode msgFocus = FocusNode();

  Future<List<dynamic>> getAllConversations() async {
    try {
      isLoading = true;
      notifyListeners();
      final result = await _chatService.getAllConversations();
      return result;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  Future<Map<String, dynamic>?> getConversationMessages(int userId) async {
    try {
      isLoading = true;
      notifyListeners();
      final result = await _chatService.getConversationMessages(userId);
      return result;
    } finally {
      isLoading = false;
      notifyListeners();
    }
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
