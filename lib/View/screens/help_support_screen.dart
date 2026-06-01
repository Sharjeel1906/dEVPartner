import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/theme.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

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
                title: "ACCOUNT MANAGEMENT",
                icon: Icons.manage_accounts_outlined,
                content:
                    "Create your account with a valid university email. Use the drawer menu to access My Profile, update your credentials, and manage your session. If you experience login issues, log out and sign in again. Persistent login keeps you signed in securely between app launches using encrypted tokens stored on your device.",
              ),
              _buildSectionCard(
                title: "PROFILE SETUP",
                icon: Icons.person_outline_rounded,
                content:
                    "Complete every required field marked with a red asterisk (*) including gender, role, about, academic details, domain, and experience level. Add skills and a profile photo to improve discoverability. Your profile card appears in Discover Partner where teammates search by class, program, semester, and domain.",
              ),
              _buildSectionCard(
                title: "TEAM BUILDING",
                icon: Icons.groups_outlined,
                content:
                    "Browse open teams in Discover Teams, review roles and available spots, and send join requests to team leaders. Leaders can create teams, add members from profiles, and manage roster size. Use My Team to view your active mission, crew members, and submit exit requests when needed.",
              ),
              _buildSectionCard(
                title: "MESSAGING",
                icon: Icons.chat_bubble_outline_rounded,
                content:
                    "Start conversations from user profiles or your Messages inbox. Real-time chat uses secure WebSocket connections. Long-press messages or conversations to select and delete items when needed. Keep communication professional and focused on project coordination.",
              ),
              _buildSectionCard(
                title: "REPORTING USERS",
                icon: Icons.flag_outlined,
                content:
                    "If you encounter harassment, spam, falsified profiles, or inappropriate conduct, contact support immediately with the username, date, and a brief description of the incident. Our team reviews reports promptly and may suspend accounts that violate community standards.",
              ),
              _buildSectionCard(
                title: "COMMUNITY GUIDELINES",
                icon: Icons.verified_user_outlined,
                content:
                    "dEVPartner is built for respectful academic collaboration. Be honest in your profile, honor team commitments, protect intellectual property, and follow your institution's academic integrity policies. Discrimination, bullying, and off-platform scams are strictly prohibited.",
              ),
              _buildSectionCard(
                title: "FAQs",
                icon: Icons.quiz_outlined,
                content:
                    "Q: Why can't I see profiles?\nA: Ensure you are logged in and have network connectivity.\n\n"
                    "Q: How do I join a team?\nA: Open Discover Teams, select a team, and send a request to the leader.\n\n"
                    "Q: Can I be in multiple teams?\nA: Team rules vary; coordinate with leaders before accepting multiple invitations.\n\n"
                    "Q: How do unread messages work?\nA: Unread counts appear on your inbox; open a chat to view new messages.",
              ),
              _buildSectionCard(
                title: "CONTACT SUPPORT",
                icon: Icons.contact_support_outlined,
                content:
                    "Our support team assists with account access, technical bugs, team disputes, and policy questions. We typically respond within 24–48 hours on business days. Include your registered email and a clear summary when reaching out.",
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [C.green, C.cyan]),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      "Email Support",
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
