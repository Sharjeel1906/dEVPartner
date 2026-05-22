import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/theme.dart';

class DisclaimerScreen extends StatelessWidget {
  const DisclaimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: C.bg,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: C.green),
        backgroundColor: C.bg,
        elevation: 0,
        title: ShaderMask(
          shaderCallback: (bounds) =>
              const LinearGradient(colors: [C.green, C.cyan]).createShader(
                Rect.fromLTWH(0, 0, bounds.width, bounds.height),
              ),
          child: Text(
            "Disclaimer",
            style: GoogleFonts.dmSans(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: w * 0.06,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionCard(
                title: "PLATFORM PURPOSE",
                icon: Icons.business_center_outlined,
                content:
                    "dEV Partner serves strictly as a facilitator to connect project creators, developers, designers, and students for Final Year Projects (FYP) and collaborative ventures. The app provides tools to display profiles, share team opportunities, and chat, but does not actively intermediate relationships.",
              ),
              _buildSectionCard(
                title: "NO SUITABILITY GUARANTEE",
                icon: Icons.verified_user_outlined,
                content:
                    "While we encourage accurate profile details, dEV Partner does not guarantee the credentials, academic standings, work ethic, or performance of any matched users or teams. Users are solely responsible for vetting prospective partners, verifying details, and establishing collaboration rules.",
              ),
              _buildSectionCard(
                title: "LIMITATION OF LIABILITY",
                icon: Icons.warning_amber_rounded,
                content:
                    "Under no circumstances shall dEV Partner, its developers, or contributors be held liable for project failures, intellectual property disputes, academic penalties, loss of project data, or personal disagreements that arise from contacts made through the application.",
              ),
              _buildSectionCard(
                title: "USAGE CONDITIONS",
                icon: Icons.rule_rounded,
                content:
                    "By utilizing dEV Partner, you acknowledge that all communications, repository sharing, and team arrangements are performed at your own risk. It is expected that all work comply with your specific institution's academic honesty regulations.",
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required String content,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: C.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: C.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: C.green, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.spaceMono(
                  color: C.cyan,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: GoogleFonts.dmSans(
              color: C.textLabel,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
