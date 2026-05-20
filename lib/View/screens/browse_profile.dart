import 'package:dev_partner/View/models/profile.dart';
import 'package:dev_partner/View/screens/create_profile.dart';
import 'package:dev_partner/View/screens/create_team.dart';
import 'package:dev_partner/View/screens/login.dart';
import 'package:dev_partner/View/screens/my_team_screen.dart';
import 'package:dev_partner/View/screens/register.dart';
import 'package:dev_partner/View/widgets/bp_ui_helper.dart';
import 'package:dev_partner/model_view/auth_provider.dart';
import 'package:dev_partner/model_view/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../widgets/theme.dart';
import '../widgets/cp_ui_helper.dart';

class  BrowseProfileScreen extends StatefulWidget {
  const BrowseProfileScreen({super.key});

  @override
  State<BrowseProfileScreen> createState() => _BrowseProfileScreenState();
}

class _BrowseProfileScreenState extends State<BrowseProfileScreen> {
  final TextEditingController searchController = TextEditingController();
  late FocusNode searchFocusNode;
  @override
  void initState() {
    super.initState();
    searchFocusNode = FocusNode();

    Future.microtask(() async {
      if (!mounted) return;
      final up = context.read<UserProvider>();
      await up.loadCachedUserFromPrefs();
      if (!mounted) return;
      await up.loadCurrentUser(silent: true);
      if (!mounted) return;
      await up.loadAllUsers();
    });
  }
  @override
  void dispose() {
    searchFocusNode.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final up = context.watch<UserProvider>();
    final ap = context.read<AuthProvider>();
    return Scaffold(
      backgroundColor: C.bg,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: C.green, // <-- This sets the drawer/hamburger icon color
        ),
        backgroundColor: C.bg,
        elevation: 0,
        title:ShaderMask(
          shaderCallback: (bounds) =>
              LinearGradient(colors: [C.green, C.cyan]).createShader(
                Rect.fromLTWH(0, 0, bounds.width, bounds.height),
              ),
          child: Text(
            "Discover Partner",
            style: GoogleFonts.dmSans(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: width * 0.06,
            ),
          ),
        ),
      ),
      drawer: Drawer(
          width: (width * 0.65).clamp(260.0, 320.0), // professional width
          child: Container(
            color: C.bg, // fully matches your theme
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // Drawer Header
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: C.surface.withOpacity(0.15), // subtle header background
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(colors: [C.green, C.cyan]),
                        ),
                        child: (up.selectedImage == null && up.currentImageUrl == null)
                            ? CircleAvatar(
                          radius: 22,
                          backgroundColor: C.bg,
                          child: Icon(
                            Icons.account_circle_rounded,
                            color: C.green,
                            size: 32,
                          ),
                        )
                            : CircleAvatar(
                          radius: 25,
                          backgroundColor: C.surface,
                          child: ClipOval(
                            child: up.selectedImage != null
                                ? Image.file(
                              up.selectedImage!,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            )
                                : Image.network(
                              up.currentImageUrl!,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
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
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                drawerItem(Icons.app_registration, "Create Team", () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>CreateTeamScreen()));
                }),
                drawerItem(Icons.person, "My Profile", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreateProfileScreen()),
                  ).then((_) async {
                    if (!mounted) return;
                    await context.read<UserProvider>().refreshBrowseData();
                  });
                }),
                drawerItem(Icons.people, "My Team", () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>MyTeamScreen()));
                }),
                drawerItem(Icons.logout_outlined, "Logout", () {
                  ap.logout(context);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                        (route) => false,
                  );
                }),
                spacer(),

                // Help & Policy
                drawerItem(Icons.help_outline, "Help & Support", () {}),
                drawerItem(Icons.warning_amber_rounded, "Disclaimer", () {}),
                drawerItem(Icons.privacy_tip_outlined, "Privacy Policy", () {}),
              ],
            ),
          ),
        ),
      body: up.isLoading
          ? Center(
        child: CircularProgressIndicator(
          color: C.green,
        ),
      )

          : SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              SizedBox(height: height * 0.01),
              TextField(
                controller: searchController,

                onChanged: (value) {
                  up.setSearchQuery(value);
                },
                focusNode: searchFocusNode,
                style: TextStyle(
                  color: C.textPrimary,
                ),
                cursorColor: C.green,
                decoration: InputDecoration(
                  hintText: "Search by name or domain",
                  prefixIcon: Icon(
                    Icons.search,
                    color: C.textPrimary,
                  ),
                  hintStyle: TextStyle(
                    color: C.textLabel,
                  ),
                  filled: true,
                  fillColor: C.surface,

                  border: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(12),

                    borderSide: BorderSide(
                      color: C.border,
                    ),
                  ),

                  focusedBorder:
                  OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(12),

                    borderSide: BorderSide(
                      color: C.borderFocus,
                      width: 1.5,
                    ),
                  ),
                ),
              ),

              SizedBox(height: height * 0.02),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Row(
                    children: [
                      SizedBox(width: width * 0.02),
                      Expanded(
                        child: Text(
                          "Class",
                          style: GoogleFonts.dmSans(
                            color: C.textLabel,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      SizedBox(width: width * 0.03),

                      Expanded(
                        child: Text(
                          "Program",
                          style: GoogleFonts.dmSans(
                            color: C.textLabel,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      SizedBox(width: width * 0.03),

                      Expanded(
                        child: Text(
                          "Semester",
                          style: GoogleFonts.dmSans(
                            color: C.textLabel,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: height * 0.008),

                  buildDropdownRow3(

                    value1: up.filterClass,
                    options1: up.classOptions,
                    onChanged1: up.setFilterClass,

                    value2: up.filterProgram,
                    options2: up.programOptions,
                    onChanged2: up.setFilterProgram,

                    value3: up.filterSemester,
                    options3: up.semesterOptions,
                    onChanged3: up.setFilterSemester,

                    spacing: width * 0.02,
                    forceOpenDownward: true,
                  ),
                ],
              ),
              ListView.builder(
                itemCount: up.filteredUsers.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final user = up.filteredUsers[index];
                  final profile = user["profile"] ?? {};
                  final skills = user["skills"] ?? [];
                  final imagePath = profile["pfp_path"];
                  final imageUrl =
                  imagePath != null
                      ? "http://192.168.100.11:8000$imagePath"
                      : "";
                  return profileCard(
                    context,
                    Profile(
                      name: user["username"] ?? "",
                      role: profile["class_name"] ?? "",
                      semester: profile["semester"] ?? "",
                      domain: profile["domain"] ?? "",
                      imageUrl: imageUrl,
                      skills: List<String>.from(
                        skills.map(
                                (s) => s["name"]),
                      ),
                    ),
                    user,
                      up.currentUserId??0,
                  );
                },
              )
            ],
          ),
        ),
      ),
    );

    }
  }
