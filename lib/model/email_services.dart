import 'dart:convert';
import 'package:http/http.dart' as http;

import 'api_client.dart';

class EmailService {
  final ApiClient _client = ApiClient();

  // ================= SEND INVITATION EMAIL =================
  Future<Map<String, dynamic>> sendInvitationEmail({
    required String recipientEmail,
    required String recipientName,
  }) async {
    try {
      final request = http.Request(
        "POST",
        Uri.parse("${ApiClient.baseUrl}/send_invitation_email/"),
      );

      request.headers["Content-Type"] = "application/json";

      request.body = jsonEncode({
        "recipient_email": recipientEmail,
        "recipient_name": recipientName,
      });

      final response = await _client.sendRequest(request);
      final body = await response.stream.bytesToString();
      final data = jsonDecode(body);

      // ================= SUCCESS =================
      if (response.statusCode == 200) {
        return {
          "success": true,
          "message": data["success"] ??
              "Invitation sent successfully",
        };
      }

      // ================= ERROR =================
      return {
        "success": false,
        "message": data["error"] ??
            "Failed to send invitation email",
      };
    } catch (e) {
      return {
        "success": false,
        "message": "Something went wrong",
      };
    }
  }
}