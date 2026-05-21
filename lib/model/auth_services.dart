import 'dart:convert';
import 'package:dev_partner/model/api_client.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  // ================= LOGIN =================
  Future<String> login(String email, String password) async {
    if (email.trim().isEmpty || password.trim().isEmpty) {
      return "All fields are required";
    }

    try {
      final response = await http.post(
        Uri.parse("${ApiClient.baseUrl}/login/"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email.trim(),
          "password": password.trim(),
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();

        _isLoggedIn = true;

        await prefs.setBool("is_logged_in", true);
        await prefs.setString("access_token", data["access"]);
        await prefs.setString("refresh_token", data["refresh"]);
        await prefs.setString("user", jsonEncode(data["user"]));

        final user = data["user"];
        if (user is Map) {
          final id = user["id"];
          if (id is int) {
            await prefs.setInt("user_id", id);
          } else if (id != null) {
            final parsed = int.tryParse(id.toString());
            if (parsed != null) await prefs.setInt("user_id", parsed);
          }
        }

        return "Logged in successfully";
      }

      _isLoggedIn = false;

      return data["detail"] ??
          data["error"] ??
          "Login failed";
    } catch (e) {
      _isLoggedIn = false;
      return "Login failed: $e";
    }
  }

  // ================= REGISTER =================
  Future<String> register(
      String email,
      String password,
      String name,
      ) async {
    if (email.trim().isEmpty ||
        password.trim().isEmpty ||
        name.trim().isEmpty) {
      return "All fields are required";
    }

    try {
      final response = await http.post(
        Uri.parse("${ApiClient.baseUrl}/create-user/"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": name.trim(),
          "email": email.trim(),
          "password": password.trim(),
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        return "Registered successfully";
      }

      return data.toString();
    } catch (e) {
      return "Registration failed: $e";
    }
  }

  // ================= LOGOUT =================
  Future<void> logout() async {
    _isLoggedIn = false;

    final prefs = await SharedPreferences.getInstance();

    await prefs.remove("access_token");
    await prefs.remove("refresh_token");
    await prefs.remove("user");
    await prefs.remove("user_id");
    await prefs.setBool("is_logged_in", false);
  }

  // ================= CHECK LOGIN =================
  Future<bool> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool("is_logged_in") ?? false;
    return _isLoggedIn;
  }

  // ================= REFRESH TOKEN =================
  Future<String> refreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    final refresh = prefs.getString("refresh_token");

    if (refresh == null) {
      await logout();
      return "Authentication required";
    }

    try {
      final response = await http.post(
        Uri.parse("${ApiClient.baseUrl}/refresh/"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"refresh": refresh}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        await prefs.setString("access_token", data["access"]);
        return "Session refreshed";
      }

      await logout();
      return "Session expired";
    } catch (e) {
      await logout();
      return "Session expired";
    }
  }
}