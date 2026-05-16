import 'package:flutter/cupertino.dart';
import '../model/email_services.dart';

class EmailProvider extends ChangeNotifier {
  final EmailService _emailService = EmailService();
  bool isLoading = false;

  Future<Map<String, dynamic>> sendInvitationEmail({
    required String recipientEmail,
    required String recipientName,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final result = await _emailService.sendInvitationEmail(
        recipientEmail: recipientEmail,
        recipientName: recipientName,
      );
      return result;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
