import 'dart:convert';

import 'package:dev_partner/View/screens/home_screen.dart';
import 'package:dev_partner/View/screens/register.dart';
import 'package:dev_partner/model_view/auth_provider.dart';
import 'package:dev_partner/model_view/chat_provider.dart';
import 'package:dev_partner/model_view/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../widgets/theme.dart';
import '../widgets/cp_ui_helper.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final ap = context.read<AuthProvider>();
    return Scaffold(
      backgroundColor: C.bg,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: C.green, // <-- This sets the drawer/hamburger icon color
        ),
        backgroundColor: C.bg,
        elevation: 0,
        title: ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [C.green, C.cyan],
          ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
          child: Text(
            "dEVPartner",
            style: GoogleFonts.dmSans(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: width * 0.06,
            ),
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: height * 0.06),
              Center(
                child: Text(
                  "Login",
                  style: GoogleFonts.spaceMono(
                    color: C.green,
                    fontWeight: FontWeight.bold,
                    fontSize: width * 0.09,
                  ),
                ),
              ),
              Center(
                child: Text(
                  "Your teammates are waiting…",
                  style: GoogleFonts.spaceMono(
                    color: C.cyan,
                    fontWeight: FontWeight.bold,
                    fontSize: width * 0.03,
                  ),
                ),
              ),

              SizedBox(height: height * 0.05),

              // Card Container
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: C.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: C.border),
                ),
                child: Column(
                  children: [
                    customTextField(
                      Focusnode: ap.emailFocus,
                      controller: ap.emailController,
                      hintText: "you@uni.edu.pk",
                      labelText: "EMAIL",
                    ),
                    SizedBox(height: height * 0.02),

                    customTextField(
                      Focusnode: ap.passwordFocus,
                      controller: ap.passwordController,
                      hintText: "Password",
                      labelText: "PASSWORD",
                      isPassword: true,
                    ),
                    SizedBox(height: height * 0.03),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: TextStyle(color: C.textLabel),
                        ),
                        SizedBox(width: width * 0.01),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegisterScreen(),
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: C.cyan, // Text color
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          child: const Text("Sign Up"),
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.04),
                    Consumer<AuthProvider>(
                      builder: (context, ap, _) {
                        return SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: C.green,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: ap.isLoading
                                ? null
                                : () async {

                              ap.emailFocus.unfocus();
                              ap.passwordFocus.unfocus();

                              final msg = await ap.login(
                                ap.emailController.text.trim(),
                                ap.passwordController.text.trim(),
                              );

                              if (!context.mounted) return;

                              if (msg == "Logged in successfully") {
                                ap.clear();
                                final up = context.read<UserProvider>();
                                final prefs =
                                    await SharedPreferences.getInstance();
                                final userJson = prefs.getString("user");
                                if (userJson != null) {
                                  up.applyUserFromMap(
                                    jsonDecode(userJson) as Map<String, dynamic>,
                                  );
                                }
                                await up.loadCurrentUser(silent: true);
                                context.read<ChatProvider>().resetSession();
                                await context.read<ChatProvider>().initUser(
                                );
                                if (!context.mounted) return;
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HomeScreen(),
                                  ),
                                );
                              } else {
                                customColoredBox(
                                  context,
                                  "Incorrect Password or Email",
                                );
                              }
                            },
                            child: ap.isLoading
                                ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: C.green,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    "LOGIN",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: height * 0.017,
                                    ),
                                  ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
