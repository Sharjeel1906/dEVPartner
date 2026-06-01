import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/theme.dart';

class AiMatchScreen extends StatelessWidget {
  const AiMatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: C.bg,
      appBar: AppBar(
        backgroundColor: C.bg,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [C.green, C.cyan],
          ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
          child: Text(
            "AI Match",
            style: GoogleFonts.dmSans(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: width * 0.06,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated / Glowing Icon Container
                  Container(
                    width: width * 0.35,
                    height: width * 0.35,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: C.surface,
                      border: Border.all(
                        color: C.green.withOpacity(0.3),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: C.green.withOpacity(0.08),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                        BoxShadow(
                          color: C.cyan.withOpacity(0.08),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.auto_awesome,
                        size: width * 0.16,
                        color: C.green,
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.05),

                  // Title text
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [C.green, C.cyan],
                    ).createShader(bounds),
                    child: Text(
                      "AI Match",
                      style: GoogleFonts.spaceMono(
                        fontSize: width * 0.08,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.02),

                  // Subtitle / Development description
                  Text(
                    "This feature is currently under development and will be available soon.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.dmSans(
                      fontSize: width * 0.045,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withOpacity(0.9),
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: height * 0.03),

                  // Details paragraph
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: C.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: C.border),
                    ),
                    child: Text(
                      "We are building an intelligent matching system that will help connect developers, designers, and collaborators based on skills, interests, project goals, and experience levels.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.dmSans(
                        fontSize: width * 0.036,
                        color: C.textLabel,
                        height: 1.6,
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.04),

                  // Friendly Footer Note
                  Text(
                    "Thank you for your patience.",
                    style: GoogleFonts.spaceMono(
                      color: C.cyan,
                      fontSize: width * 0.032,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
