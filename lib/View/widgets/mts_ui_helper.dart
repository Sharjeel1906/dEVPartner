import 'package:dev_partner/View/screens/browse_teams.dart';
import 'package:dev_partner/View/screens/create_team.dart';
import 'package:dev_partner/View/widgets/cp_ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/theme.dart';

Widget buildEmptyState(double w, double h, BuildContext context) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: w * 0.08),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Large faded icon for depth
        Icon(Icons.groups_outlined, size: w * 0.25, color: C.surfaceHover),
        SizedBox(height: h * 0.03),

        // Punchline
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Colors.white, C.textMuted],
          ).createShader(bounds),
          child: Text(
            "Every great architect needs a crew.",
            textAlign: TextAlign.center,
            style: GoogleFonts.dmSans(
              fontSize: w * 0.07,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),

        SizedBox(height: h * 0.02),

        Text(
          "You aren't part of any project yet. Start a new legacy or join an existing mission.",
          textAlign: TextAlign.center,
          style: GoogleFonts.dmSans(color: C.textMuted, fontSize: w * 0.035),
        ),

        SizedBox(height: h * 0.06),

        // Action Buttons
        actionButton(w, "Discover Teams", C.cyan, Icons.search, () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>BrowseTeamsScreen()));
        }),
        SizedBox(height: h * 0.02),
        actionButton(
          w,
          "Create My Own",
          C.green,
          Icons.add,
          () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>CreateTeamScreen()));
          },
          isOutlined: true,
        ),
      ],
    ),
  );
}

/// THE VIEW IF USER HAS A TEAM
Widget buildTeamView(double w, double h, BuildContext context) {
  return SingleChildScrollView(
    physics: const BouncingScrollPhysics(),
    padding: EdgeInsets.symmetric(horizontal: w * 0.05, vertical: h * 0.02),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// 1. TEAM HERO SECTION
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF0D1117),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: C.border),
          ),
          child: Column(
            children: [
              // Top Accent Line
              Container(
                height: 3,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  gradient: LinearGradient(colors: [C.green, C.cyan]),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(w * 0.06),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        customizedCapsule(text: "ACTIVE MISSION", no: "1"),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: C.surface, shape: BoxShape.circle),
                          child: const Icon(Icons.settings_outlined, color: C.textMuted, size: 20),
                        )
                      ],
                    ),
                    SizedBox(height: h * 0.025),
                    Text(
                      "Neural Ninjas".toUpperCase(),
                      style: GoogleFonts.spaceMono(
                        color: Colors.white,
                        fontSize: w * 0.07,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    SizedBox(height: h * 0.005),
                    Text(
                      "Architecting the future of decentralized AI through low-latency neural nodes.",
                      style: GoogleFonts.dmSans(color: C.textMuted, fontSize: w * 0.035, height: 1.4),
                    ),

                    spacer(), // Your gradient helper

                    /// QUICK STATS ROW
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildQuickStat("84%", "PROGRESS", C.green),
                        _buildQuickStat("12", "TASKS", C.cyan),
                        _buildQuickStat("18d", "REMAINING", C.pink),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: h * 0.04),

        /// 2. CORE CREW SECTION
        Text("CORE CREW", style: GoogleFonts.spaceMono(color: C.green, fontWeight: FontWeight.bold, letterSpacing: 1)),

        SizedBox(height: h * 0.02),

        // Detailed Member Cards
        _buildProfessionalMemberTile(w, "Sharjeel Ahmed", "Team Lead / Architect", true),
        _buildProfessionalMemberTile(w, "Alex Rivera", "Senior Flutter Developer", false),
        _buildProfessionalMemberTile(w, "Sarah Chen", "ML Engineer", false),

        SizedBox(height: h * 0.04),

        /// 3. TECH STACK & ECOSYSTEM
        Text("PROJECT ECOSYSTEM", style: GoogleFonts.spaceMono(color: C.cyan, fontWeight: FontWeight.bold, letterSpacing: 1)),
        SizedBox(height: h * 0.02),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(w * 0.04),
          decoration: BoxDecoration(
            color: C.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: C.border),
          ),
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _techBadge("Python 3.10", C.green),
              _techBadge("PyTorch", C.pink),
              _techBadge("Flutter", C.cyan),
              _techBadge("Firebase", C.amber),
              _techBadge("FastAPI", C.blue),
            ],
          ),
        ),

        SizedBox(height: h * 0.05),
      ],
    ),
  );
}

Widget _buildQuickStat(String value, String label, Color color) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(value, style: GoogleFonts.spaceMono(color: color, fontSize: 20, fontWeight: FontWeight.bold)),
      Text(label, style: GoogleFonts.spaceMono(color: C.textMuted, fontSize: 10, fontWeight: FontWeight.bold)),
    ],
  );
}

Widget _buildProfessionalMemberTile(double w, String name, String role, bool isAdmin) {
  return Container(
    margin: const EdgeInsets.only(bottom: 16),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: C.surface,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: isAdmin ? C.green.withOpacity(0.3) : C.blue.withOpacity(0.3)),
    ),
    child: Row(
      children: [
        Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: isAdmin ? C.green : C.cyan)),
              child: CircleAvatar(radius: 22, backgroundColor: C.bg, child: Icon(Icons.person, color: isAdmin ? C.green : C.cyan)),
            ),
            if (isAdmin)
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(color: C.green, shape: BoxShape.circle),
                  child: const Icon(Icons.bolt, size: 10, color: Colors.black),
                ),
              )
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: GoogleFonts.dmSans(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              Text(role, style: GoogleFonts.dmSans(color: C.textMuted, fontSize: 12)),
            ],
          ),
        ),
        if (isAdmin)
          Text("ADMIN", style: GoogleFonts.spaceMono(color: C.green, fontSize: 9, fontWeight: FontWeight.bold)),
        
      ],
    ),
  );
}

Widget _techBadge(String text, Color color) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
    decoration: BoxDecoration(
      color: color.withOpacity(0.05),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: color.withOpacity(0.2)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text(text, style: GoogleFonts.spaceMono(color: Colors.white, fontSize: 11)),
      ],
    ),
  );
}
// Common UI Components for the Screen
Widget memberTile(double w) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: C.surface,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: C.border),
    ),
    child: Row(
      children: [
        const CircleAvatar(
          backgroundColor: C.border,
          child: Icon(Icons.person, color: C.textMuted),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Alex Rivera",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Lead Developer",
                style: TextStyle(color: C.green.withOpacity(0.7), fontSize: 11),
              ),
            ],
          ),
        ),
        const Icon(Icons.chat_bubble_outline, color: C.cyan, size: 20),
      ],
    ),
  );
}

Widget actionButton(
  double w,
  String label,
  Color color,
  IconData icon,
  VoidCallback onTap, {
  bool isOutlined = false,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        color: isOutlined ? Colors.transparent : color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isOutlined ? color : Colors.black, size: 20),
          const SizedBox(width: 10),
          Text(
            label,
            style: GoogleFonts.dmSans(
              color: isOutlined ? color : Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    ),
  );
}
