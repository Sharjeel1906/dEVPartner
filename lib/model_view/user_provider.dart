import 'package:flutter/cupertino.dart';
import '../model/chat_services.dart';

class UserProvider extends ChangeNotifier {
  final ChatService _chatService = ChatService();
  bool isLoading = false;

  final Map<String, TextEditingController> profile_controllers = {
    "name": TextEditingController(),
    "email": TextEditingController(),
    "about": TextEditingController(),
    "skill": TextEditingController(),
    "domain": TextEditingController(),
    "linkedin": TextEditingController(),
    "github": TextEditingController(),
    "portfolio": TextEditingController(),
  };

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

  @override
  void dispose() {
    for (var c in profile_controllers.values) {
      c.dispose();
    }
    super.dispose();
  }
  void clear() {
    for (var controller in profile_controllers.values) {
      controller.clear();
    }
    notifyListeners();
  }
}