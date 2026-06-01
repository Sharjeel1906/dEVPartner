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
                title: "USER RESPONSIBILITY",
                icon: Icons.person_outline_rounded,
                content:
                    "You are solely responsible for the accuracy of information in your profile, the teams you join or create, and all decisions made based on interactions within dEVPartner. Verify credentials, skills, and availability of potential partners before committing to a project.",
              ),
              _buildSectionCard(
                title: "COLLABORATION RISKS",
                icon: Icons.warning_amber_rounded,
                content:
                    "Team formation through dEVPartner involves interpersonal and academic risks including misaligned expectations, uneven contribution, and scheduling conflicts. The platform facilitates introductions but does not supervise day-to-day collaboration or enforce team agreements.",
              ),
              _buildSectionCard(
                title: "PROJECT OUTCOMES",
                icon: Icons.assignment_outlined,
                content:
                    "dEVPartner does not guarantee project completion, grades, publication acceptance, startup success, or any specific academic or professional outcome. Success depends on team effort, institutional requirements, and external factors beyond our control.",
              ),
              _buildSectionCard(
                title: "THIRD-PARTY CONTENT",
                icon: Icons.link_outlined,
                content:
                    "Profiles may contain links to external websites, repositories, or portfolios. dEVPartner is not responsible for the content, security, or practices of third-party sites. Access external links at your own discretion.",
              ),
              _buildSectionCard(
                title: "COMMUNICATION CONDUCT",
                icon: Icons.forum_outlined,
                content:
                    "Users must communicate respectfully and professionally. dEVPartner is not liable for offensive, misleading, or harmful statements made in private messages or public profile content. Report violations to support for review.",
              ),
              _buildSectionCard(
                title: "PLATFORM LIMITATIONS",
                icon: Icons.settings_outlined,
                content:
                    "The service is provided on an \"as is\" and \"as available\" basis. Features may change, be suspended, or experience downtime for maintenance. We do not warrant uninterrupted access, error-free operation, or compatibility with all devices.",
              ),
              _buildSectionCard(
                title: "LIABILITY LIMITATION",
                icon: Icons.balance_outlined,
                content:
                    "To the fullest extent permitted by law, dEVPartner, its developers, affiliates, and contributors shall not be liable for indirect, incidental, special, or consequential damages arising from use of the app, including data loss, academic penalties, IP disputes, or financial loss from collaborations initiated through the platform.",
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
