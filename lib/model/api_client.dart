import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  //static const String baseUrl = "http://10.0.2.2:8000/FYP_Partner_Finder";
  //static const String baseUrl = "http://192.168.100.11:8000/FYP_Partner_Finder";
  static const String baseUrl = "https://fyp-partner-finder-app-backend-production.up.railway.app/FYP_Partner_Finder";

  // ================= GET TOKEN =================
  Future<String?> _getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("access_token");
  }

  // ================= REFRESH TOKEN =================
  Future<bool> refreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    final refresh = prefs.getString("refresh_token");

    if (refresh == null) return false;

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/refresh/"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"refresh": refresh}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await prefs.setString("access_token", data["access"]);
        return true;
      }

      await prefs.clear();
      return false;
    } catch (e) {
      await prefs.clear();
      return false;
    }
  }

  http.Request _cloneRequest(http.Request request) {
    final clone = http.Request(request.method, request.url);
    clone.headers.addAll(request.headers);
    clone.bodyBytes = request.bodyBytes;
    return clone;
  }

  Future<http.StreamedResponse> _sendWithRetry(
    http.Request request,
  ) async {
    http.Request active = _cloneRequest(request);
    final token = await _getAccessToken();
    if (token != null) {
      active.headers["Authorization"] = "Bearer $token";
    }

    var response = await active.send();

    if (response.statusCode == 401) {
      final refreshed = await refreshToken();
      if (refreshed) {
        active = _cloneRequest(request);
        final newToken = await _getAccessToken();
        if (newToken != null) {
          active.headers["Authorization"] = "Bearer $newToken";
        }
        response = await active.send();
      }
    }

    return response;
  }

  // ================= MULTIPART REQUEST (AUTH) =================
  Future<http.StreamedResponse> sendMultipart(
    http.MultipartRequest request,
  ) async {
    final token = await _getAccessToken();

    if (token != null) {
      request.headers["Authorization"] = "Bearer $token";
    }

    var response = await request.send();

    if (response.statusCode == 401) {
      final refreshed = await refreshToken();

      if (refreshed) {
        final newToken = await _getAccessToken();
        if (newToken != null) {
          request.headers["Authorization"] = "Bearer $newToken";
        }
        response = await request.send();
      }
    }

    return response;
  }

  // ================= NORMAL REQUEST (AUTH) =================
  Future<http.StreamedResponse> sendRequest(
    http.Request request,
  ) async {
    return _sendWithRetry(request);
  }

  // ================= PUBLIC REQUEST (NO AUTH) =================
  Future<http.StreamedResponse> sendPublicRequest(
    http.Request request,
  ) async {
    return await request.send();
  }
}
