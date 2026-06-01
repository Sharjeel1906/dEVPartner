import 'package:dev_partner/View/screens/create_profile.dart';
import 'package:dev_partner/View/screens/create_team.dart';
import 'package:dev_partner/View/screens/disclaimer_screen.dart';
import 'package:dev_partner/View/screens/help_support_screen.dart';
import 'package:dev_partner/View/screens/login.dart';
import 'package:dev_partner/View/screens/my_team_screen.dart';
import 'package:dev_partner/View/screens/privacy_policy_screen.dart';
import 'package:dev_partner/View/widgets/bp_ui_helper.dart';
import 'package:dev_partner/View/widgets/cp_ui_helper.dart';
import 'package:dev_partner/View/widgets/profile_avatar.dart';
import 'package:dev_partner/View/widgets/theme.dart';
import 'package:dev_partner/model_view/auth_provider.dart';
import 'package:dev_partner/model_view/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

Widget buildAppDrawer(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  final up = context.watch<UserProvider>();
  final ap = context.read<AuthProvider>();

  return Drawer(
    width: (width * 0.65).clamp(260.0, 320.0),
    child: Container(
      color: C.bg,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: C.surface.withOpacity(0.15),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                up.selectedImage != null
                    ? CircleAvatar(
                        radius: 25,
                        backgroundColor: C.surface,
                        backgroundImage: FileImage(up.selectedImage!),
                      )
                    : ProfileAvatar(
                        imageUrl: up.currentImageUrl ?? '',
                        radius: 25,
                        showGradientRing: true,
                      ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        up.drawerUserName.isNotEmpty
                            ? up.drawerUserName
                            : "User",
                        style: GoogleFonts.spaceMono(
                          color: C.green,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        up.drawerUserDomain.isNotEmpty
                            ? up.drawerUserDomain
                            : "—",
                        style: GoogleFonts.spaceMono(
                          color: C.cyan.withOpacity(0.7),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          drawerItem(Icons.app_registration, "Create Team", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreateTeamScreen()),
            );
          }),
          drawerItem(Icons.person, "My Profile", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CreateProfileScreen()),
            ).then((_) async {
              if (!context.mounted) return;
              await context.read<UserProvider>().refreshBrowseData();
            });
          }),
          drawerItem(Icons.people, "My Team", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyTeamScreen()),
            );
          }),
          drawerItem(Icons.logout_outlined, "Logout", () {
            ap.logout(context);
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
              (route) => false,
            );
          }),
          spacer(),
          drawerItem(Icons.help_outline, "Help & Support", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HelpSupportScreen()),
            );
          }),
          drawerItem(Icons.warning_amber_rounded, "Disclaimer", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DisclaimerScreen()),
            );
          }),
          drawerItem(Icons.privacy_tip_outlined, "Privacy Policy", () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PrivacyPolicyScreen(),
              ),
            );
          }),
        ],
      ),
    ),
  );
}
