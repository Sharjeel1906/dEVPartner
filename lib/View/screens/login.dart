import 'package:dev_partner/View/screens/register.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/theme.dart';
import '../widgets/cp_ui_helper.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    FocusNode email_focus = FocusNode();
    FocusNode pass_focus = FocusNode();

    return Scaffold(
      backgroundColor: C.bg,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: C.green, // <-- This sets the drawer/hamburger icon color
        ),
        backgroundColor: C.bg,
        elevation: 0,
        title:ShaderMask(
          shaderCallback: (bounds) =>
              LinearGradient(colors: [C.green, C.cyan]).createShader(
                Rect.fromLTWH(0, 0, bounds.width, bounds.height),
              ),
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

              SizedBox(height:height*0.05 ),

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
                      Focusnode: email_focus,
                      controller: emailController,
                      hintText: "you@uni.edu.pk",
                      labelText: "EMAIL",
                    ),
                    SizedBox(height:height*0.02 ),

                    customTextField(
                      Focusnode: pass_focus,
                      controller: passwordController,
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
                        SizedBox(width: width*0.01),
                        TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterScreen()));
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

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: C.green,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {},
                        child: Text(
                          "LOGIN",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: height*0.017,
                          ),
                        ),
                      ),
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