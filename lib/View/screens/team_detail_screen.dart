import 'package:dev_partner/View/widgets/mts_ui_helper.dart';
import 'package:dev_partner/model_view/team_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../widgets/theme.dart';

class TeamDetailScreen extends StatefulWidget {
  final int teamId;

  const TeamDetailScreen({super.key, required this.teamId});

  @override
  State<TeamDetailScreen> createState() => _TeamDetailScreenState();
}

class _TeamDetailScreenState extends State<TeamDetailScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<TeamProvider>().getTeamDetails(widget.teamId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final tp = context.watch<TeamProvider>();
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: C.bg,
      appBar: AppBar(
        iconTheme: IconThemeData(color: C.green),
        backgroundColor: C.bg,
        elevation: 0,
        title: ShaderMask(
          shaderCallback: (bounds) =>
              LinearGradient(colors: [C.green, C.cyan]).createShader(
                Rect.fromLTWH(0, 0, bounds.width, bounds.height),
              ),
          child: Text(
            "Team Details",
            style: GoogleFonts.dmSans(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: w * 0.06,
            ),
          ),
        ),
      ),
      body: tp.isDetailsLoading
          ? const Center(child: CircularProgressIndicator(color: C.green))
          : tp.teamDetails != null
              ? buildTeamView(w, h, context, tp.teamDetails!)
              : Center(
                  child: Text(
                    "Could not load team details",
                    style: TextStyle(color: C.textLabel),
                  ),
                ),
    );
  }
}
