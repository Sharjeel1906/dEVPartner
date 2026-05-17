import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'api_client.dart';

class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final Map<String, dynamic>? error;

  ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.error,
  });
}

class UserServices {
  final ApiClient _client = ApiClient();

  // ================= UPDATE USER =================
  Future<ApiResponse<dynamic>> updateUser({
    required String gender,
    required String role,
    required String about,
    required String section,
    required String className,
    required String program,
    required String semester,
    required String domain,
    required String linkedIn,
    required String github,
    required String portfolio,
    required List<String> skills,
    File? pfp,
    File? cv,
  }) async {
    try {
      final request = http.MultipartRequest(
        "POST",
        Uri.parse("${ApiClient.baseUrl}/update-user/"),
      );

      // fields
      request.fields.addAll({
        "gender": gender,
        "role": role,
        "about": about,
        "section": section,
        "class_name": className,
        "program": program,
        "semester": semester,
        "domain": domain,
        "linked_in_link": linkedIn,
        "github_link": github,
        "portfolio_link": portfolio,
      });

      for (final skill in skills) {
        request.fields["skills"] = skill;
      }

      // files
      if (pfp != null) {
        request.files.add(
          await http.MultipartFile.fromPath("pfp_path", pfp.path),
        );
      }
      if (cv != null) {
        request.files.add(
          await http.MultipartFile.fromPath("cv_path", cv.path),
        );
      }
      final response = await _client.sendMultipart(request);
      final body = await response.stream.bytesToString();
      final data = jsonDecode(body);

      if (response.statusCode == 200) {
        return ApiResponse(
          success: true,
          data: data,
          message: data["message"] ?? "Profile updated successfully",
        );
      }

      return ApiResponse(
        success: false,
        error: data is Map<String, dynamic> ? data : {"error": data},
        message: _extractError(data),
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: "Something went wrong",
        error: {"exception": e.toString()},
      );
    }
  }

  // ================= GET USER =================
  Future<dynamic> getUser(int userId) async {
    try {
      final request = http.Request(
        "GET",
        Uri.parse("${ApiClient.baseUrl}/user/$userId/"),
      );

      final response = await _client.sendPublicRequest(request);

      if (response.statusCode == 200) {
        return jsonDecode(await response.stream.bytesToString());
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  // ================= GET ALL USERS =================
  Future<List<dynamic>> getAllUsers() async {
    try {
      final request = http.Request(
        "GET",
        Uri.parse("${ApiClient.baseUrl}/users/"),
      );

      final response = await _client.sendPublicRequest(request);

      if (response.statusCode == 200) {
        return jsonDecode(await response.stream.bytesToString());
      }

      return [];
    } catch (e) {
      return [];
    }
  }
  // ================= ERROR FORMATTER =================
  String _extractError(dynamic data) {
    if (data is Map) {
      return data.values
          .expand((e) => e is List ? e : [e])
          .join("\n");
    }
    return "Request failed";
  }
}