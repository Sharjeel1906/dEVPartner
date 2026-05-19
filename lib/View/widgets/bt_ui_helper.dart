import 'package:dev_partner/View/models/project.dart';
import 'package:dev_partner/View/widgets/cp_ui_helper.dart';
import 'package:dev_partner/model_view/email_provider.dart';
import 'package:dev_partner/model_view/team_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../widgets/theme.dart';

Widget customizedColumn({
  required BuildContext context,
  required IconData icon,
  required String title,
  required String value,
}) {
  final w = MediaQuery.of(context).size.width;
  final h = MediaQuery.of(context).size.height;

  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.center, // 🔥 center looks better
    children: [
      SizedBox(height: h * 0.006),

      /// Value
      FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          value,
          maxLines: 1,
          style: GoogleFonts.dmSans(
            color: C.cyan,
            fontSize: w * 0.055,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      SizedBox(height: h * 0.004),

      /// Title
      FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          title,
          maxLines: 1,
          textAlign: TextAlign.center,
          style: GoogleFonts.dmSans(
            color: C.textLabel,
            fontSize: w * 0.032,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    ],
  );
}

Widget statDivider(BuildContext context) {
  final h = MediaQuery.of(context).size.height;

  return Container(
    height: h * 0.05,
    width: 1,
    margin: const EdgeInsets.symmetric(horizontal: 8),
    color: C.border.withOpacity(0.6),
  );
}

Widget projectCard({
  required BuildContext context,
  required Project project,
  required Color accentColor,
}) {
  final width = MediaQuery.of(context).size.width;
  final height = MediaQuery.of(context).size.height;

  return Container(
    margin: EdgeInsets.only(bottom: height * 0.02),
    padding: EdgeInsets.all(width * 0.04),
    decoration: BoxDecoration(
      color: C.surface,
      borderRadius: BorderRadius.circular(width * 0.04),
      border: Border.all(color: C.border),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.025,
                vertical: height * 0.005,
              ),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(width * 0.05),
              ),
              child: Text(
                project.category,
                style: GoogleFonts.spaceMono(
                  color: C.textLabel,
                  fontSize: width * 0.028,
                  letterSpacing: 1,
                ),
              ),
            ),
            SizedBox(width: width * 0.02),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.025,
                vertical: height * 0.005,
              ),
              decoration: BoxDecoration(
                color: C.green.withOpacity(0.2),
                borderRadius: BorderRadius.circular(width * 0.05),
              ),
              child: Text(
                "Recruiting",
                style: GoogleFonts.spaceMono(
                  color: C.green,
                  fontSize: width * 0.028,
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: height * 0.015),

        /// Title
        Text(
          project.title,
          style: GoogleFonts.spaceMono(
            color: C.textPrimary,
            fontSize: width * 0.045,
            fontWeight: FontWeight.bold,
          ),
        ),

        SizedBox(height: height * 0.01),

        /// Description
        Text(
          project.description,
          style: TextStyle(color: C.textMuted, fontSize: width * 0.032),
        ),

        SizedBox(height: height * 0.015),
        Text(
          "Open Roles",
          style: GoogleFonts.spaceMono(
            color: C.textMuted,
            fontSize: width * 0.033,
          ),
        ),
        SizedBox(height: height * 0.015),

        /// Open Positions (reused skills for now)
        Wrap(
          spacing: width * 0.02,
          runSpacing: height * 0.008,
          children: project.role.map((role) {
            return Container(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.025,
                vertical: height * 0.008,
              ),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(width * 0.025),
              ),
              child: Text(
                role,
                style: GoogleFonts.spaceMono(
                  color: C.textPrimary,
                  fontSize: width * 0.03,
                ),
              ),
            );
          }).toList(),
        ),

        SizedBox(height: height * 0.015),

        /// Bottom Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${project.spotsLeft - 1} spots left",
              style: GoogleFonts.spaceMono(
                color: C.textMuted,
                fontSize: width * 0.03,
              ),
            ),
            Text(
              project.timeAgo,
              style: GoogleFonts.spaceMono(
                color: C.textMuted,
                fontSize: width * 0.03,
              ),
            ),
          ],
        ),

        SizedBox(height: height * 0.010),
        Consumer<EmailProvider>(
          builder: (context, emailProvider, _) {
            return Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [accentColor, accentColor.withOpacity(0.7)],
                ),
                borderRadius: BorderRadius.circular(width * 0.03),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(width * 0.03),
                  onTap: emailProvider.isLoading
                      ? null
                      : () async {
                    final tp = context.read<TeamProvider>();

                    if (tp.isInTeam) {
                      customColoredBox(context, "You are already in the team");
                      return;
                    }

                    final leaderEmail = project.leaderEmail;
                    final leaderName = project.leaderName;
                    if (leaderEmail == null) return;

                    final result = await emailProvider.sendInvitationEmail(
                      recipientEmail: leaderEmail,
                      recipientName: leaderName,
                    );

                    if (context.mounted) {
                      customColoredBox(context, result["message"] ?? "Done");
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: height * 0.015),
                    child: Center(
                      child: emailProvider.isLoading
                          ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          color: Colors.black,
                          strokeWidth: 2,
                        ),
                      )
                          : Text(
                        "Request to Join FYP →",
                        style: GoogleFonts.spaceMono(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: width * 0.035,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    ),
  );
}
