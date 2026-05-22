import 'package:dev_partner/View/screens/create_team.dart';
import 'package:dev_partner/model_view/team_provider.dart';
import 'package:dev_partner/model_view/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../widgets/theme.dart';
import '../widgets/cp_ui_helper.dart';
import '../widgets/up_ui_helper.dart';

class UserProfileScreen extends StatefulWidget {
  UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<TeamProvider>().getMyTeam();
    });
  }

  int? _userId(Map<String, dynamic> user) {
    final id = user["id"];
    if (id is int) return id;
    return int.tryParse(id?.toString() ?? "");
  }

  int? _teamId(Map<String, dynamic> team) {
    final id = team["id"] ?? team["team_id"];
    if (id is int) return id;
    return int.tryParse(id?.toString() ?? "");
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final up = context.watch<UserProvider>();
    final tp = context.watch<TeamProvider>();
    final user = up.viewedUser;

    if (user == null) {
      return Scaffold(
        backgroundColor: C.bg,
        body: const Center(
          child: CircularProgressIndicator(color: C.green),
        ),
      );
    }

    final profile = user["profile"] ?? {};
    final skills = user["skills"] ?? [];
    final skillNames = skills is List
        ? skills.map((s) => s["name"]?.toString() ?? "").where((s) => s.isNotEmpty).toList()
        : <String>[];

    final pfp = profile["pfp_path"]?.toString() ?? "";
    final imageUrl = pfp.isNotEmpty ? "http://192.168.100.11:8000$pfp" : "";

    return Scaffold(
      backgroundColor: C.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back,
                      color: C.green,
                      size: width * 0.06,
                    ),
                  ),
                  SizedBox(width: width * 0.02),
                  ShaderMask(
                    shaderCallback: (bounds) =>
                        LinearGradient(colors: [C.green, C.cyan]).createShader(
                          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                        ),
                    child: Text(
                      user["username"]?.toString() ?? "",
                      style: GoogleFonts.dmSans(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: width * 0.06,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * 0.04),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    customizedCapsule(text: "Personal", no: "1"),
                    Container(height: 1, width: 20, color: C.green),
                    customizedCapsule(text: "Academic", no: "2"),
                    Container(height: 1, width: 20, color: C.green),
                    customizedCapsule(text: "Skills", no: "3"),
                    Container(height: 1, width: 20, color: C.green),
                    customizedCapsule(text: "Domain & Experience", no: "4"),
                    Container(height: 1, width: 20, color: C.green),
                    customizedCapsule(text: "Portfolio & Links", no: "5"),
                  ],
                ),
              ),
              SizedBox(height: height * 0.03),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: C.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: C.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    sectionHeading(context: context, text: "Personal"),
                    SizedBox(height: height * 0.001),
                    sectionSubHeading(context: context, text: "Vibe, Intro⚡"),
                    SizedBox(height: height * 0.02),
                    Center(
                      child: Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: C.surface,
                          borderRadius: BorderRadius.circular(45),
                          border: Border.all(color: C.border),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(45),
                          child: imageUrl.isNotEmpty
                              ? Image.network(
                                  imageUrl,
                                  width: 90,
                                  height: 90,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Center(
                                    child: Icon(
                                      Icons.person,
                                      color: C.green,
                                      size: 40,
                                    ),
                                  ),
                                )
                              : Center(
                                  child: Icon(
                                    Icons.person,
                                    color: C.green,
                                    size: 40,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    customDataContainer(
                      data: user["username"]?.toString() ?? "",
                      labelText: "Name",
                    ),
                    SizedBox(height: height * 0.02),
                    customDataContainer(
                      data: user["email"]?.toString() ?? "",
                      labelText: "Email",
                    ),
                    SizedBox(height: height * 0.02),
                    customDataContainer(
                      data: profile["about"]?.toString() ?? "",
                      labelText: "About",
                    ),
                    SizedBox(height: height * 0.02),
                    customDataContainer(
                      data: profile["gender"]?.toString() ?? "",
                      labelText: "Gender",
                    ),
                    SizedBox(height: height * 0.02),
                    customDataContainer(
                      data: profile["role"]?.toString() ?? "",
                      labelText: "Role",
                    ),
                    SizedBox(height: height * 0.02),
                    spacer(),

                    sectionHeading(context: context, text: "Academic"),
                    SizedBox(height: height * 0.001),
                    sectionSubHeading(context: context, text: "Academic saga, in brief✨"),
                    SizedBox(height: height * 0.02),
                    customDataContainer(
                      data: profile["semester"]?.toString() ?? "",
                      labelText: "Semester",
                    ),
                    SizedBox(height: height * 0.02),
                    customDataContainer(
                      data: profile["class_name"]?.toString() ?? "",
                      labelText: "Class",
                    ),
                    SizedBox(height: height * 0.02),
                    customDataContainer(
                      data: profile["program"]?.toString() ?? "",
                      labelText: "Program",
                    ),
                    SizedBox(height: height * 0.02),
                    customDataContainer(
                      data: profile["section"]?.toString() ?? "",
                      labelText: "Section",
                    ),
                    SizedBox(height: height * 0.03),
                    spacer(),

                    sectionHeading(context: context, text: "Skills"),
                    SizedBox(height: height * 0.001),
                    sectionSubHeading(context: context, text: "Flexing talents😎"),
                    SizedBox(height: height * 0.01),
                    Wrap(
                      spacing: width * 0.02,
                      children: skillNames.map((skill) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.03,
                            vertical: height * 0.008,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(width * 0.025),
                            border: Border.all(color: Colors.white12),
                          ),
                          child: Text(
                            skill,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: width * 0.03,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: height * 0.03),
                    spacer(),

                    sectionHeading(context: context, text: "Domain & Experience"),
                    SizedBox(height: height * 0.001),
                    sectionSubHeading(context: context, text: "Hustle in a nutshell🚀"),
                    SizedBox(height: height * 0.02),
                    customDataContainer(
                      data: profile["domain"]?.toString() ?? "",
                      labelText: "Domain",
                    ),
                    SizedBox(height: height * 0.01),
                    customDataContainer(
                      data: profile["experience"]?.toString() ?? "",
                      labelText: "Experience",
                    ),
                    SizedBox(height: height * 0.02),
                    spacer(),

                    sectionHeading(context: context, text: "Links"),
                    SizedBox(height: height * 0.001),
                    sectionSubHeading(context: context, text: "Links that scream ‘look at me!🌟"),
                    SizedBox(height: height * 0.02),
                    customDataContainer(
                      data: profile["linked_in_link"]?.toString() ?? "",
                      labelText: "LinkedIn",
                    ),
                    SizedBox(height: height * 0.03),
                    customDataContainer(
                      data: profile["github_link"]?.toString() ?? "",
                      labelText: "Github",
                    ),
                    SizedBox(height: height * 0.02),
                    customDataContainer(
                      data: profile["portfolio_link"]?.toString() ?? "",
                      labelText: "Portfolio",
                    ),
                    SizedBox(height: height * 0.03),

                    _buildMemberButton(context, up, tp, user, height),
                    SizedBox(height: height * 0.02),
                    _buildRemoveMemberButton(context, up, tp, user, height),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMemberButton(
    BuildContext context,
    UserProvider up,
    TeamProvider tp,
    Map<String, dynamic> user,
    double height,
  ) {
    final viewedId = _userId(user);
    if (viewedId == null || viewedId == up.currentUserId) {
      return const SizedBox.shrink();
    }

    if (tp.isMyTeamLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: CircularProgressIndicator(color: C.green, strokeWidth: 2),
        ),
      );
    }

    if (!tp.canManageMembers(up.currentUserId, up.selectedRole)) {
      return Center(
        child: Text(
          "Only team leader can add members",
          textAlign: TextAlign.center,
          style: TextStyle(color: C.cyan, fontSize: height * 0.017),
        ),
      );
    }

    if (tp.myTeam == null) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: C.green,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreateTeamScreen()),
            );
          },
          child: Text(
            "Create Team to Add Members",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: height * 0.017,
            ),
          ),
        ),
      );
    }


    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: C.green,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: tp.isLoading
            ? null
            : () async {
                final teamId = _teamId(tp.myTeam!);
                if (teamId == null) return;

                final result = await tp.addTeamMember(
                  teamId: teamId,
                  memId: viewedId,
                );

                if (!context.mounted) return;

                customColoredBox(
                  context,
                  result["message"]?.toString() ??
                      (result["success"] == true
                          ? "Member added successfully"
                          : "Failed to add member"),
                );

              },
        child: tp.isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.black,
                  strokeWidth: 2,
                ),
              )
            : Text(
                "Add Member",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: height * 0.017,
                ),
              ),
      ),
    );
  }

  Widget _buildRemoveMemberButton(
    BuildContext context,
    UserProvider up,
    TeamProvider tp,
    Map<String, dynamic> user,
    double height,
  ) {
    final viewedId = _userId(user);
    if (viewedId == null ||
        viewedId == up.currentUserId ||
        !tp.isCurrentUserTeamLeader(up.currentUserId) ||
        !tp.isUserInMyTeam(viewedId)) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: C.surface,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: const BorderSide(color: C.pink),
          ),
        ),
        onPressed: tp.isLoading
            ? null
            : () async {
                final teamId = _teamId(tp.myTeam!);
                if (teamId == null) return;

                final confirmed = await showConfirmDeleteDialog(
                  context,
                  title: "Remove Member",
                  message: "Remove this member from your team?",
                );
                if (!context.mounted || !confirmed) return;

                final result = await tp.removeTeamMember(
                  teamId: teamId,
                  memId: viewedId,
                );

                if (!context.mounted) return;

                customColoredBox(
                  context,
                  result["message"]?.toString() ??
                      (result["success"] == true
                          ? "Member removed successfully"
                          : "Failed to remove member"),
                );
              },
        child: tp.isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: C.cyan,
                  strokeWidth: 2,
                ),
              )
            : Text(
                "Remove Member",
                style: TextStyle(
                  color: C.cyan,
                  fontWeight: FontWeight.bold,
                  fontSize: height * 0.017,
                ),
              ),
      ),
    );
  }
}
