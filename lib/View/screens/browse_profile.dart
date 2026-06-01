import 'package:dev_partner/View/models/profile.dart';
import 'package:dev_partner/View/widgets/bp_ui_helper.dart';
import 'package:dev_partner/View/widgets/profile_avatar.dart';
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

class _BrowseProfileScreenState extends State<BrowseProfileScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

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
      if (up.allUsers.isEmpty) {
        await up.loadAllUsers();
      }
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
    super.build(context);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final up = context.watch<UserProvider>();
    return Scaffold(
      backgroundColor: C.bg,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu, color: C.green),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        iconTheme: IconThemeData(
          color: C.green,
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
      body: up.isLoading && up.filteredUsers.isEmpty
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
                  final imageUrl =
                      ProfileAvatar.urlFromPath(profile["pfp_path"]);
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
