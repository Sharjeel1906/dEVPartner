import 'package:dev_partner/View/screens/browse_teams.dart';
import 'package:dev_partner/View/screens/create_team.dart';
import 'package:dev_partner/View/widgets/cp_ui_helper.dart';
import 'package:dev_partner/model_view/team_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/theme.dart';

/// ================= EMPTY STATE (UNCHANGED UI) =================
Widget buildEmptyState(double w, double h, BuildContext context) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: w * 0.08),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.groups_outlined, size: w * 0.25, color: C.surfaceHover),
        SizedBox(height: h * 0.03),

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
          style: GoogleFonts.dmSans(
            color: C.textMuted,
            fontSize: w * 0.035,
          ),
        ),

        SizedBox(height: h * 0.06),

        actionButton(
          w,
          "Discover Teams",
          C.cyan,
          Icons.search,
              () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BrowseTeamsScreen()),
            );
          },
        ),

        SizedBox(height: h * 0.02),

        actionButton(
          w,
          "Create My Own",
          C.green,
          Icons.add,
              () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreateTeamScreen()),
            );
          },
          isOutlined: true,
        ),
      ],
    ),
  );
}

/// ================= TEAM VIEW (NOW DYNAMIC FROM API) =================
Widget buildTeamView(
    double w,
    double h,
    BuildContext context,
    Map<String, dynamic> team,
    ) {
  final members = TeamProvider.parseMembers(team);
  final memberTotal = TeamProvider.memberCount(team);
  final roles = TeamProvider.parseReqRoles(team["roles"]);

  return SingleChildScrollView(
    physics: const BouncingScrollPhysics(),
    padding: EdgeInsets.symmetric(horizontal: w * 0.05, vertical: h * 0.02),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// HERO CARD
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF0D1117),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: C.border),
          ),
          child: Column(
            children: [
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
                      ],
                    ),

                    SizedBox(height: h * 0.025),

                    /// TEAM NAME (DYNAMIC)
                    Text(
                      (team["team_name"] ?? "TEAM")
                          .toString()
                          .toUpperCase(),
                      style: GoogleFonts.spaceMono(
                        color: Colors.white,
                        fontSize: w * 0.07,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),

                    SizedBox(height: h * 0.005),

                    /// DOMAIN SECTION (TEXT ONLY)
                    Text(
                      "PROJECT DOMAIN",
                      style: GoogleFonts.spaceMono(
                        color: C.green,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.7,
                      ),
                    ),

                    SizedBox(height: h * 0.01),

                    Text(
                      (team["project_domain"]?.toString().isNotEmpty == true)
                          ? team["project_domain"].toString().toUpperCase()
                          : "Not specified",
                      style: GoogleFonts.dmSans(
                        color: C.textPrimary,
                        fontSize: w * 0.035,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    SizedBox(height: h * 0.01),

                    /// ROLES SECTION (CHIPS ONLY)
                    Text(
                      "REQUIRED ROLES",
                      style: GoogleFonts.spaceMono(
                        color: C.cyan,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.7,
                      ),
                    ),
                    SizedBox(height: h * 0.01),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: (roles.isNotEmpty ? roles : ["Not specified"])
                          .map((role) => _techBadge(role.toUpperCase(), C.cyan))
                          .toList(),
                    ),
                    spacer(),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildQuickStat(
                          "$memberTotal/${team["available_team_size"]+memberTotal}",
                          "MEMBERS",
                          C.green,
                        ),
                        _buildQuickStat("ACTIVE", "STATUS", C.cyan),
                        _buildQuickStat("LIVE", "PROJECT", C.pink),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: h * 0.04),

        /// CORE CREW
        Text(
          "CORE CREW",
          style: GoogleFonts.spaceMono(
            color: C.green,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),

        SizedBox(height: h * 0.02),

        /// MEMBERS (DYNAMIC)
        ...members.map((m) {
          return _buildProfessionalMemberTile(
            w,
            m["username"] ?? "User",
            m["mem_role"] ?? "Member",
            (m["mem_role"] ?? "").toString().toLowerCase() == "leader",
          );
        }).toList(),

        SizedBox(height: h * 0.04),

        /// ECOSYSTEM (STATIC UI KEPT SAME)
        Text(
          "PROJECT ECOSYSTEM",
          style: GoogleFonts.spaceMono(
            color: C.cyan,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),

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
              _techBadge("Flutter", C.cyan),
              _techBadge("Django", C.green),
              _techBadge("API", C.pink),
            ],
          ),
        ),

        SizedBox(height: h * 0.05),
      ],
    ),
  );
}

/// ================= QUICK STAT =================
Widget _buildQuickStat(String value, String label, Color color) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        value,
        style: GoogleFonts.spaceMono(
          color: color,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        label,
        style: GoogleFonts.spaceMono(
          color: C.textMuted,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );
}

/// ================= MEMBER TILE =================
Widget _buildProfessionalMemberTile(
    double w,
    String name,
    String role,
    bool isAdmin,
    ) {
  return Container(
    margin: const EdgeInsets.only(bottom: 16),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: C.surface,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: isAdmin ? C.green.withOpacity(0.3) : C.blue.withOpacity(0.3),
      ),
    ),
    child: Row(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: C.bg,
          child: Icon(
            Icons.person,
            color: isAdmin ? C.green : C.cyan,
          ),
        ),
        const SizedBox(width: 16),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: GoogleFonts.dmSans(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                role,
                style: GoogleFonts.dmSans(
                  color: C.textMuted,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),

        if (isAdmin)
          Text(
            "ADMIN",
            style: GoogleFonts.spaceMono(
              color: C.green,
              fontSize: 9,
              fontWeight: FontWeight.bold,
            ),
          ),
      ],
    ),
  );
}

/// ================= TECH BADGE =================
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
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: GoogleFonts.spaceMono(
            color: Colors.white,
            fontSize: 11,
          ),
        ),
      ],
    ),
  );
}

/// ================= ACTION BUTTON (UNCHANGED) =================
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