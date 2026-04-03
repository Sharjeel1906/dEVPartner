import 'package:dev_partner/View/widgets/mts_ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/theme.dart';

class MyTeamScreen extends StatelessWidget {
  final bool hasTeam; // Pass this based on your logic

  const MyTeamScreen({super.key, this.hasTeam = false});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

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
            "Dashboard",
            style: GoogleFonts.dmSans(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: w * 0.06,
            ),
          ),
        ),
      ),

      body:
      buildTeamView(w, h, context)
      // hasTeam
      //     ? buildTeamView(w, h, context)
      //     : buildEmptyState(w, h, context),
    );
  }
}
