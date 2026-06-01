import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'api_client.dart';

class CvDownloadService {
  static String resolveCvUrl(String cvPath) {
    final p = cvPath.trim();
    if (p.isEmpty) return "";
    if (p.startsWith("http")) return p;
    final base = ApiClient.baseUrl.replaceAll('/FYP_Partner_Finder', '');
    return "$base$p";
  }

  /// Opens the system save dialog so the user can pick Downloads (or any folder).
  /// Returns the saved path, or null if download failed or the user cancelled.
  static Future<String?> downloadCv({
    required String cvPath,
    required String fileName,
  }) async {
    final url = resolveCvUrl(cvPath);
    if (url.isEmpty) return null;

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("access_token");
    final headers = <String, String>{};
    if (token != null) {
      headers["Authorization"] = "Bearer $token";
    }

    final response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode != 200) return null;

    final safeName = fileName.isNotEmpty ? fileName : "resume.pdf";
    final ext = safeName.contains('.') ? safeName.split('.').last : 'pdf';

    return FilePicker.platform.saveFile(
      dialogTitle: 'Save CV',
      fileName: safeName,
      type: FileType.custom,
      allowedExtensions: [ext],
      bytes: response.bodyBytes,
    );
  }
}
