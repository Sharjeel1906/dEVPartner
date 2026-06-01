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
              Text(
                "Last updated: May 2026",
                style: GoogleFonts.dmSans(color: C.textMuted, fontSize: 12),
              ),
              const SizedBox(height: 16),
              _buildSectionCard(
                title: "DATA COLLECTION",
                icon: Icons.data_usage_rounded,
                content:
                    "dEVPartner collects information you voluntarily provide during registration and profile setup, including your name, email, academic program, skills, domain, and optional portfolio links. We also process authentication tokens, team membership records, and chat metadata necessary to operate the platform.",
              ),
              _buildSectionCard(
                title: "PROFILE INFORMATION",
                icon: Icons.badge_outlined,
                content:
                    "Profile fields such as semester, class, section, role, experience level, and profile picture are stored to help other users discover compatible teammates. By default, this information is visible to authenticated users within the app. You may update or correct your profile at any time from My Profile.",
              ),
              _buildSectionCard(
                title: "USER CONTENT",
                icon: Icons.article_outlined,
                content:
                    "Content you submit—including team descriptions, skills lists, about sections, and uploaded CV or image files—is stored on our servers to deliver app functionality. You retain ownership of your content but grant dEVPartner a limited license to display it within the service for collaboration purposes.",
              ),
              _buildSectionCard(
                title: "MESSAGING DATA",
                icon: Icons.message_outlined,
                content:
                    "Chat messages, timestamps, and delivery status are processed to enable real-time communication between users. Messages are transmitted over encrypted connections where supported. We do not sell message content to advertisers or unrelated third parties.",
              ),
              _buildSectionCard(
                title: "SECURITY PRACTICES",
                icon: Icons.shield_outlined,
                content:
                    "We use industry-standard measures including access tokens, refresh token rotation, secure API communication, and restricted server access. While no system is perfectly secure, we continuously work to protect user data against unauthorized access, alteration, or disclosure.",
              ),
              _buildSectionCard(
                title: "THIRD-PARTY SERVICES",
                icon: Icons.hub_outlined,
                content:
                    "dEVPartner may rely on hosting providers, email delivery services, and analytics tools that process data on our behalf under contractual obligations. These providers may only use data as instructed by dEVPartner and must maintain appropriate safeguards.",
              ),
              _buildSectionCard(
                title: "USER RIGHTS",
                icon: Icons.gavel_outlined,
                content:
                    "You may request access to your personal data, correction of inaccurate information, export of your profile details, or restriction of certain processing activities. Contact support@devpartner.org to exercise these rights. We will respond within a reasonable timeframe.",
              ),
              _buildSectionCard(
                title: "ACCOUNT DELETION",
                icon: Icons.delete_forever_outlined,
                content:
                    "You may request permanent deletion of your account and associated personal data by contacting support. Upon verified deletion, we remove profile information, team associations where applicable, and message history subject to legal retention requirements.",
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
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.spaceMono(
                    color: C.cyan,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
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
