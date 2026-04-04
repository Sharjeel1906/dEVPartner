import 'dart:async';
import 'package:dev_partner/View/screens/home_screen.dart';
import 'package:dev_partner/View/screens/register.dart';
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
      "features": [
        {"icon": "⚡", "label": "Fast Match"},
        {"icon": "🎯", "label": "Skill Based"},
        {"icon": "🔒", "label": "Verified"},
      ],
    },
    {
      "image": "assets/images/collaboration.png",
      "title": "Create Balanced\nProject Teams",
      "desc": "Build high-performing teams with the right blend of diverse skills and technical strengths.",
      "features": [
        {"icon": "🤝", "label": "Team Fit"},
        {"icon": "📊", "label": "Balanced"},
        {"icon": "💡", "label": "Smart Pick"},
      ],
    },
    {
      "image": "assets/images/rocket.png",
      "title": "Launch Your Final\nYear Project",
      "desc": "Successfully take your FYP to the finish line with seamless team collaboration tools.",
      "features": [
        {"icon": "🚀", "label": "Launch Ready"},
        {"icon": "🛠️", "label": "Full Toolkit"},
        {"icon": "🏆", "label": "Success Rate"},
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 3), (Timer t) {
      if (!mounted) return;
      if (currentIndex < data.length - 1) {
        _controller.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      } else {
        t.cancel();
      }
    });
  }

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
    final textScale = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      backgroundColor: const Color(0xFF121417),
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
                flex: 4,
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFF00A884),
                            Color(0xFF006B5E),
                          ],
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: Image.asset(
                          item["image"]! as String,
                          width: w,
                          height: h * 0.4,
                          color: Colors.white.withOpacity(0.2),
                          colorBlendMode: BlendMode.softLight,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // --- BOTTOM SECTION ---
              Expanded(
                flex: 5,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: w * 0.07),
                  decoration: const BoxDecoration(
                    color: Color(0xFF121417),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: h * 0.03),

                      // TITLE
                      Text(
                        item["title"]! as String,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.spaceMono(
                          fontSize: 26 * textScale,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: h * 0.015),

                      // DESCRIPTION
                      Text(
                        item["desc"]! as String,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.spaceMono(
                          color: Colors.white70,
                          fontSize: 13 * textScale,
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: h * 0.02),

                      // FEATURE ROW
                      _buildFeatureRow(item, w, h),

                      SizedBox(height: h * 0.04),

                      // PAGINATION DOTS
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          data.length,
                              (i) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: EdgeInsets.symmetric(horizontal: w * 0.01),
                            height: 6,
                            width: currentIndex == i ? 20 : 6,
                            decoration: BoxDecoration(
                              color: currentIndex == i
                                  ? const Color(0xFF00A884)
                                  : Colors.white24,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),

                      const Spacer(),

                      // BUTTONS
                      if (currentIndex == data.length - 1)
                        Column(
                          children: [
                            _buildGradientButton("Sign Up", () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegisterScreen()),
                              );
                            }, w, h),
                            SizedBox(height: h * 0.015),
                            _buildGradientButton("Login", () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen()),
                              );
                            }, w, h),
                          ],
                        )
                      else
                        SizedBox(height: h * 0.18),

                      SizedBox(height: h * 0.03),
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

  Widget _buildFeatureRow(Map<String, dynamic> item, double w, double h) {
    final features = (item["features"] as List<dynamic>)
        .map((e) => Map<String, String>.from(e as Map))
        .toList();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: features.map((feature) {
        return Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: w * 0.01),
            padding: EdgeInsets.symmetric(vertical: h * 0.015, horizontal: w * 0.02),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF00A884).withOpacity(0.35),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  feature["icon"]!,
                  style: TextStyle(fontSize: 22 * MediaQuery.textScaleFactorOf(context)),
                ),
                SizedBox(height: h * 0.005),
                Text(
                  feature["label"]!,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.spaceMono(
                    color: Colors.white70,
                    fontSize: 11 * MediaQuery.textScaleFactorOf(context),
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildGradientButton(String text, VoidCallback onTap, double w, double h) {
    return Container(
      width: double.infinity,
      height: h * 0.07,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF0091A4),
            Color(0xFF006B5E),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
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
          style: GoogleFonts.spaceMono(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16 * MediaQuery.textScaleFactorOf(context),
          ),
        ),
      ),
    );
  }
}