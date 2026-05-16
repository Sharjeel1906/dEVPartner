import 'package:flutter/cupertino.dart';
import '../model/auth_services.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  final FocusNode emailFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  final FocusNode nameFocus = FocusNode();

  bool isLoading = false;

  Future<String> login(String email, String password) async {
    try {
      isLoading = true;
      notifyListeners();
      final result = await _authService.login(email, password);
      return result;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<String> register(String email, String password, String name) async {
    try {
      isLoading = true;
      notifyListeners();
      final result = await _authService.register(email, password, name);
      return result;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    try {
      isLoading = true;
      notifyListeners();
      await _authService.logout();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();

    emailFocus.dispose();
    passwordFocus.dispose();
    nameFocus.dispose();

    super.dispose();
  }
}