import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/theme.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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
            "Privacy Policy",
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
                title: "PRIVACY COMMITMENT",
                icon: Icons.shield_outlined,
                content:
                    "At dEV Partner, user privacy is paramount. We gather only the minimal personal data required to enable team match-making and direct messaging between developers and student peers. We do not engage in background behavioral profiling or third-party marketing tracking.",
              ),
              _buildSectionCard(
                title: "MINIMAL DATA COLLECTION",
                icon: Icons.data_usage_rounded,
                content:
                    "• Profile Information: We collect and store academic-oriented details (your name, academic program, current semester, technical domain, skills, and optional profile picture) to build your profile card.\n"
                    "• Messaging Data: Chat messages and timestamps are processed to enable real-time messaging using websockets.\n"
                    "• Auth Credentials: Standard cached access tokens are securely held locally to keep you logged in between sessions.",
              ),
              _buildSectionCard(
                title: "SHARING & PEER VISIBILITY",
                icon: Icons.share_outlined,
                content:
                    "By default, your display name, domain, skills, and semester are visible to other logged-in users of dEV Partner so they can find you for team building. We do not sell, distribute, or expose your private contact data, invitation emails, or chat history to third-party ad networks or external marketing services.",
              ),
              _buildSectionCard(
                title: "DATA RETENTION & CONTROL",
                icon: Icons.settings_backup_restore_rounded,
                content:
                    "You retain full control over your data. You can modify your profile fields, change technical skills, or update your team requirements directly in the app. If you wish to delete your account or wipe your conversation history, please contact support for immediate processing.",
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
