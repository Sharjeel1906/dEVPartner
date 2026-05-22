import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/theme.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

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
            "Help & Support",
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
                title: "ABOUT THE PLATFORM",
                icon: Icons.info_outline_rounded,
                content:
                    "dEV Partner is a professional collaboration network designed to connect developers, designers, and students to coordinate, form balanced project teams, and manage Final Year Projects (FYP). We streamline the discovery process to help you find the right technical fit for your projects.",
              ),
              _buildSectionCard(
                title: "CORE FUNCTIONALITY",
                icon: Icons.grid_view_rounded,
                content:
                    "• Discover Partner: Search and filter profiles by skills, academic program, semester, and domain.\n"
                    "• Discover Teams: Find recruiting project teams and check open roles, available spots, and descriptions.\n"
                    "• Real-Time Chat: Initiate conversations directly with potential teammates or leaders to align goals.\n"
                    "• Team Management: Create teams, add or remove members, assign roles, and handle incoming requests easily.",
              ),
              _buildSectionCard(
                title: "USER RESPONSIBILITIES",
                icon: Icons.gavel_rounded,
                content:
                    "All users must maintain high standards of academic integrity and professional courtesy. Communication must be respectful and strictly related to project coordination. Spam, harassment, or submitting falsified profile details will lead to immediate account suspension.",
              ),
              _buildSectionCard(
                title: "GETTING HELP",
                icon: Icons.contact_support_outlined,
                content:
                    "Need assistance, want to report an issue, or suggest features? Reach out to our dedicated support team. We generally respond to student queries and bug reports within 24–48 hours.",
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [C.green, C.cyan],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      "Contact Support",
                      style: GoogleFonts.spaceMono(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "support@devpartner.org",
                      style: GoogleFonts.spaceMono(
                        color: Colors.black.withOpacity(0.8),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
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
