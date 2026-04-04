import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int currentIndex = 0;
  Timer? timer;

  final data = [
    {
      "image": "assets/images/team.png",
      "title": "Find the Perfect\nFYP Partner",
      "desc": "Connect with students who share similar skills and collaborate with your team.",
    },
    {
      "image": "assets/images/collaboration.png",
      "title": "Create Balanced\nProject Teams",
      "desc": "Build high-performing teams with the right blend of diverse skills and technical strengths.",
    },
    {
      "image": "assets/images/rocket.png",
      "title": "Launch Your Final\nYear Project",
      "desc": "Successfully take your FYP to the finish line with seamless team collaboration tools.",
    },
  ];

  @override
  void dispose() {
    timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF121417), // Matches the dark background in pic
      body: PageView.builder(
        controller: _controller,
        itemCount: data.length,
        onPageChanged: (index) => setState(() => currentIndex = index),
        itemBuilder: (context, index) {
          final item = data[index];
          return Column(
            children: [
              // --- TOP SECTION: IMAGE + GRADIENT ---
              Expanded(
                flex: 5,
                child: Stack(
                  children: [
                    // Gradient background
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFF00A884), // Teal Green
                            Color(0xFF006B5E), // Darker Teal
                          ],
                        ),
                      ),
                    ),

                    // Image with full blend
                    Positioned.fill(
                      child: Image.asset(
                        item["image"]!,
                        fit: BoxFit.cover, // fills full container
                        color: Colors.white.withOpacity(0.2), // optional tint
                        colorBlendMode: BlendMode.softLight, // blends smoothly
                      ),
                    ),
                  ],
                ),
              ),

              // --- BOTTOM SECTION: TEXT + INTERACTION ---
              Expanded(
                flex: 5,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: w * 0.1),
                  decoration: const BoxDecoration(
                    color: Color(0xFF121417), // Deep Dark Grey/Black
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        item["title"]!,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.spaceMono(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        item["desc"]!,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.spaceMono(
                          color: Colors.white70,
                          fontSize: 15,
                          height: 1.5,
                        ),
                      ),
                      const Spacer(),

                      // PAGINATION DOTS
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          data.length,
                              (i) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            height: 6,
                            width: currentIndex == i ? 10 : 6,
                            decoration: BoxDecoration(
                              color: currentIndex == i ? Colors.white : Colors.white24,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // BUTTONS (Always visible on last screen, or keep logic as per your flow)
                      if (currentIndex == data.length - 1)
                        Column(
                          children: [
                            _buildGradientButton("Sign Up", () {}),
                            const SizedBox(height: 12),
                            _buildGradientButton("Login", () {}),
                          ],
                        )
                      else
                        const SizedBox(height: 122), // Placeholder to keep layout stable

                      SizedBox(height: h * 0.06),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildGradientButton(String text, VoidCallback onTap) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF0091A4), // Light Cyan/Teal
            Color(0xFF006B5E), // Dark Green
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        ),
        onPressed: onTap,
        child: Text(
          text,
          style: GoogleFonts.dmSans(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}