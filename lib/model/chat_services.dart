import 'dart:convert';
import 'package:http/http.dart' as http;

import 'api_client.dart';

class ChatService {
  final ApiClient _client = ApiClient();

  // ================= GET ALL CONVERSATIONS =================
  Future<List<dynamic>> getAllConversations() async {
    try {
      final request = http.Request(
        "GET",
        Uri.parse("${ApiClient.baseUrl}/inbox/"),
      );

      final response = await _client.sendRequest(request);
      final body = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        return jsonDecode(body);
      }

      return [];
    } catch (e) {
      return [];
    }
  }

  // ================= GET CONVERSATION MESSAGES =================
  Future<Map<String, dynamic>?> getConversationMessages(int userId) async {
    try {
      final request = http.Request(
        "GET",
        Uri.parse("${ApiClient.baseUrl}/messages/$userId/"),
      );

      final response = await _client.sendRequest(request);
      final body = await response.stream.bytesToString();
      final data = jsonDecode(body);

      if (response.statusCode == 200) {
        return data;
      }

      return {
        "error": data["error"] ?? "Failed to load messages",
      };
    } catch (e) {
      return {
        "error": "Something went wrong",
      };
    }
  }
}