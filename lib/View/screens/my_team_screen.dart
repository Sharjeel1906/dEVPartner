import 'package:dev_partner/View/widgets/mts_ui_helper.dart';
import 'package:dev_partner/model_view/team_provider.dart';
import 'package:dev_partner/model_view/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../widgets/theme.dart';

class MyTeamScreen extends StatefulWidget {
  const MyTeamScreen({super.key});

  @override
  State<MyTeamScreen> createState() => _MyTeamScreenState();
}

class _MyTeamScreenState extends State<MyTeamScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<TeamProvider>().getMyTeam();
    });
  }

  @override
  Widget build(BuildContext context) {
    final tp = context.watch<TeamProvider>();
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final up = context.watch<UserProvider>();
    return Scaffold(
      backgroundColor: C.bg,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: C.green,
        ),
        backgroundColor: C.bg,
        elevation: 0,
        title: ShaderMask(
          shaderCallback: (bounds) =>
              LinearGradient(colors: [C.green, C.cyan]).createShader(
                Rect.fromLTWH(0, 0, bounds.width, bounds.height),
              ),
          child: Text(
            "My Team",
            style: GoogleFonts.dmSans(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: w * 0.06,
            ),
          ),
        ),
      ),

      body: tp.isMyTeamLoading
          ? const Center(child: CircularProgressIndicator())
          : tp.myTeam != null
          ? buildTeamView(w, h, context, tp.myTeam!)
          : buildEmptyState(w, h, context),
    );
  }
}