import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/theme.dart';
import '../widgets/cp_ui_helper.dart';
import 'login.dart'; // contains your customTextField helper

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final nameController = TextEditingController();

    FocusNode email_focus = FocusNode();
    FocusNode pass_focus = FocusNode();
    FocusNode name_focus = FocusNode();

    return Scaffold(
      backgroundColor: C.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                     child:Icon(
                          Icons.arrow_back,
                          color: C.green,
                          size: width * 0.06,
                        ),
                  ),
                SizedBox(width: width*0.02,),
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [C.green, C.cyan],
                  ).createShader(
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
      ],
              ),
              SizedBox(height: height * 0.08),

              Center(
                child: Text(
                  "Register",
                  style: GoogleFonts.spaceMono(
                    color: C.green,
                    fontWeight: FontWeight.bold,
                    fontSize: width * 0.09,
                  ),
                ),
              ),
              Center(
                child: Text(
                  "Join the squad, your FYP awaits!",
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
                      Focusnode: name_focus,
                      controller: nameController,
                      hintText: "Ahmed",
                      labelText: "Name",
                    ),
                    SizedBox(height: height * 0.02),

                    customTextField(
                      Focusnode: email_focus,
                      controller: emailController,
                      hintText: "you@uni.edu.pk",
                      labelText: "EMAIL",
                    ),
                    SizedBox(height: height * 0.02),

                    customTextField(
                      Focusnode: pass_focus,
                      controller: passwordController,
                      hintText: "Password",
                      labelText: "PASSWORD",
                      isPassword: true,
                    ),
                    SizedBox(height: height * 0.02),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account?",
                          style: TextStyle(color: C.textLabel),
                        ),
                        SizedBox(width: width * 0.01),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                    const LoginScreen()));
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: C.cyan,
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          child: const Text("Sign In"),
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.01),

                    // Register Button
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
                          "Register",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: height * 0.017,
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