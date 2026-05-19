import 'package:flutter/cupertino.dart';
import '../model/email_services.dart';

class EmailProvider extends ChangeNotifier {
  final EmailService _emailService = EmailService();
  bool isLoading = false;
  String? errorMessage;
  bool? lastSuccess;

  Future<Map<String, dynamic>> sendInvitationEmail({
    required String recipientEmail,
    required String recipientName,
  }) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final result = await _emailService.sendInvitationEmail(
        recipientEmail: recipientEmail,
        recipientName: recipientName,
      );

      lastSuccess = result["success"] == true;
      errorMessage = lastSuccess! ? null : result["message"];
      return result;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}