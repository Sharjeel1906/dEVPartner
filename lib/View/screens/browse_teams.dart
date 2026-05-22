import 'package:dev_partner/View/models/project.dart';
import 'package:dev_partner/View/screens/team_detail_screen.dart';
import 'package:dev_partner/View/widgets/bt_ui_helper.dart';
import 'package:dev_partner/View/widgets/mts_ui_helper.dart';
import 'package:dev_partner/model_view/team_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../widgets/theme.dart';

class  BrowseTeamsScreen extends StatefulWidget {
  const BrowseTeamsScreen({super.key});

  @override
  State<BrowseTeamsScreen> createState() => _BrowseTeamsScreenState();
}

class _BrowseTeamsScreenState extends State<BrowseTeamsScreen> {
  final TextEditingController searchController = TextEditingController();
  late FocusNode searchFocusNode;

  @override
  void initState() {
    super.initState();
    searchFocusNode = FocusNode();

    Future.microtask(() {
      if (!mounted) return;
      context.read<TeamProvider>().getAllTeams();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final tp = context.watch<TeamProvider>();
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
            "Discover Teams",
            style: GoogleFonts.dmSans(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: width * 0.06,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: height*0.01,),
              Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: C.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: C.border),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: customizedColumn(
                            context: context,
                            icon: Icons.event_available,
                            title: "Teams 👥",
                            value: tp.teamSummary?["total_teams"]?.toString() ?? "0"

                        ),
                      ),

                      statDivider(context),

                      Expanded(
                        child: customizedColumn(
                            context: context,
                            icon: Icons.search,
                            title: "Recruiting 📝",
                            value: tp.teamSummary?["teams_with_open_spots"]?.toString() ?? "0"

                        ),
                      ),

                      statDivider(context),

                      Expanded(
                        child: customizedColumn(
                            context: context,
                            icon: Icons.people,
                            title: "Spots 🏆",
                            value: tp.teamSummary?["total_open_spots"]?.toString() ?? "0"
                        ),
                      ),
                    ],
                  )
              ),
              SizedBox(height: height*0.02,),
              TextField(
                controller: searchController,
                focusNode: searchFocusNode,
                onChanged: tp.setTeamsSearchQuery,
                style: TextStyle(color: C.textPrimary),
                cursorColor: C.green,
                decoration: InputDecoration(
                  hintText: "Search by name, domain, skills etc",
                  prefixIcon: Icon(Icons.search,color: C.textPrimary,),
                  hintStyle: TextStyle(color: C.textLabel),
                  filled: true,
                  fillColor: C.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: C.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: C.borderFocus, width: 1.5),
                  ),
                ),
              ),
              SizedBox(height: height*0.02,),
              tp.isLoading
                  ? const Center(
                child: CircularProgressIndicator(
                  color: C.green,
                ),
              )
                  : tp.filteredTeams.isEmpty
                  ? SizedBox(
                height: height * 0.6,
                child: buildEmptyState(width, height, context),
              )
                  : Column(
                children: tp.filteredTeams.asMap().entries.map((entry) {
                  int index = entry.key;
                  final team = entry.value;

                  final List<Color> accentColors = [
                    C.purple,
                    C.pink,
                    C.amber,
                    C.blue,
                    C.orange,
                  ];

                  final Color color = accentColors[index % accentColors.length];

                  final int total = TeamProvider.teamTotalSize(team);
                  final int memberTotal = TeamProvider.memberCount(team);
                  final int openSpots = total - memberTotal;
                  final teamId = TeamProvider.teamIdFromMap(team);
                  final roles = TeamProvider.parseReqRoles(team["roles"]);

                  return GestureDetector(
                    onTap: () {
                      if (teamId == 0) return;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TeamDetailScreen(teamId: teamId),
                        ),
                      );
                    },
                    child: projectCard(
                      context: context,
                      project: Project(
                        category: team["project_domain"]?.toString() ?? "",
                        title: team["team_name"]?.toString() ?? "",
                        description: team["team_description"]?.toString() ??
                            "Looking for team members",
                        skills: const [],
                        role: roles.isNotEmpty ? roles : ["Not specified"],
                        spotsLeft: openSpots-memberTotal,
                        totalSpots: total,
                        timeAgo: TeamProvider.formatTeamDate(team["created_at"]),
                        leaderName: team["group_lead_name"]?.toString() ?? "",
                        leaderEmail: team["group_lead_email"]?.toString(),
                      ),
                      accentColor: color,
                    ),
                  );
                }).toList(),
              )
            ],
          ),
        ),
      ),
    );
  }
}