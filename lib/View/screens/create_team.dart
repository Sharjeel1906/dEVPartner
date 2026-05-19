import 'package:dev_partner/View/widgets/cp_ui_helper.dart';
import 'package:dev_partner/model_view/team_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../widgets/theme.dart';

class CreateTeamScreen extends StatelessWidget {
  const CreateTeamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final tp = context.watch<TeamProvider>();

    return Scaffold(
      backgroundColor: C.bg,
      appBar: AppBar(
        iconTheme: IconThemeData(color: C.green),
        backgroundColor: C.bg,
        elevation: 0,
        title: ShaderMask(
          shaderCallback: (bounds) => LinearGradient(colors: [C.green, C.cyan])
              .createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
          child: Text(
            "dEVPartner",
            style: GoogleFonts.dmSans(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: w * 0.06,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: w * 0.05, vertical: h * 0.03),
        child: Column(
          children: [

            Center(
              child: Column(
                children: [
                  Icon(Icons.extension, color: C.green, size: w * 0.1),
                  SizedBox(height: h * 0.02),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: GoogleFonts.dmSans(
                        fontSize: w * 0.08,
                        fontWeight: FontWeight.bold,
                        height: 1.1,
                      ),
                      children: [
                        TextSpan(
                          text: "Create Your ",
                          style: GoogleFonts.spaceMono(color: Colors.white),
                        ),
                        WidgetSpan(
                          child: ShaderMask(
                            blendMode: BlendMode.srcIn,
                            shaderCallback: (bounds) => LinearGradient(
                              colors: [C.green, C.cyan],
                            ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                            child: Text(
                              "Dream",
                              style: GoogleFonts.spaceMono(
                                fontWeight: FontWeight.bold,
                                fontSize: w * 0.08,
                              ),
                            ),
                          ),
                        ),
                        const TextSpan(text: "\n"),
                        WidgetSpan(
                          child: ShaderMask(
                            blendMode: BlendMode.srcIn,
                            shaderCallback: (bounds) => LinearGradient(
                              colors: [C.green, C.cyan],
                            ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                            child: Text(
                              "Team",
                              style: GoogleFonts.spaceMono(
                                fontWeight: FontWeight.bold,
                                fontSize: w * 0.08,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: h * 0.04),

            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF0D1117),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: C.border),
              ),
              child: Column(
                children: [

                  Container(
                    height: 2,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                      gradient: LinearGradient(
                        colors: [C.green, C.cyan, C.pink],
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.all(w * 0.05),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        customTextField(
                          controller: tp.team_controllers["teamName"]!,
                          hintText: "e.g. \"Neural Ninjas\"",
                          labelText: "TEAM NAME",
                          Focusnode: tp.team_focus["teamName"]!,
                        ),

                        spacer(),

                        Text(
                          "PROJECT DOMAIN",
                          style: TextStyle(
                            color: C.textLabel,
                            fontSize: w * 0.032,
                          ),
                        ),
                        SizedBox(height: h * 0.01),

                        buildDropdown(
                          value: tp.selectedDomain,
                          options: tp.domainOptions,
                          onChanged: tp.setDomain,
                        ),

                        SizedBox(height: h * 0.005),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: tp.selectedSkills.map((skill) {
                            return _buildChip(skill, () {
                              tp.removeSkill(skill);
                            });
                          }).toList(),
                        ),

                        spacer(),

                        Text(
                          "REQUIRED ROLES",
                          style: TextStyle(
                            color: C.textLabel,
                            fontSize: w * 0.032,
                          ),
                        ),
                        SizedBox(height: h * 0.005),

                        TextField(
                          controller: tp.team_controllers["role"],
                          focusNode: tp.team_focus["role"],
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "Type role and press Enter...",
                            filled: true,
                            fillColor: C.surface,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: C.border),
                            ),
                          ),
                          onSubmitted: (val) {
                            tp.addRole(val);
                            tp.team_controllers["role"]!.clear();
                          },
                        ),
                        SizedBox(height: h * 0.005),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: tp.selectedRoles.map((role) {
                            return _buildChip(
                              role,
                                  () => tp.removeRole(role),
                              color: C.cyan,
                            );
                          }).toList(),
                        ),

                        spacer(),

                        Text(
                          "TEAM SIZE",
                          style: TextStyle(
                            color: C.textLabel,
                            fontSize: w * 0.032,
                          ),
                        ),
                        SizedBox(height: h * 0.015),

                        Column(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(vertical: h * 0.01),
                              decoration: BoxDecoration(
                                color: C.surface,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: C.border),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  IconButton(
                                    onPressed: tp.decreaseTeamSize,
                                    icon: const Icon(Icons.remove, color: C.textMuted),
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        "${tp.teamSize}",
                                        style: GoogleFonts.spaceMono(
                                          fontSize: w * 0.07,
                                          color: C.cyan,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "Members",
                                        style: TextStyle(
                                          color: C.textMuted,
                                          fontSize: w * 0.025,
                                        ),
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    onPressed: tp.increaseTeamSize,
                                    icon: const Icon(Icons.add, color: C.green),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: h * 0.02),

                            Row(
                              children: List.generate(6, (index) {
                                return Expanded(
                                  child: Container(
                                    height: 4,
                                    margin: const EdgeInsets.symmetric(horizontal: 2),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(2),
                                      color: index < tp.teamSize ? C.cyan : C.border,
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),

                        SizedBox(height: h * 0.04),

                        Container(
                          padding: EdgeInsets.all(w * 0.04),
                          decoration: BoxDecoration(
                            color: C.green.withOpacity(0.04),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: C.green.withOpacity(0.1)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.workspace_premium,
                                color: Colors.orangeAccent,
                                size: 20,
                              ),
                              SizedBox(width: w * 0.03),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "You'll be Team Admin",
                                      style: GoogleFonts.dmSans(
                                        color: C.green,
                                        fontWeight: FontWeight.bold,
                                        fontSize: w * 0.035,
                                      ),
                                    ),
                                    SizedBox(height: h * 0.005),
                                    Text(
                                      "As creator, you approve join requests and manage roles.",
                                      style: TextStyle(
                                        color: C.textMuted,
                                        fontSize: w * 0.028,
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: h * 0.02),

                        SizedBox(
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
                              final res = await tp.createTeam();
                              if (!context.mounted) return;
                              customColoredBox(
                                context,
                                res["message"] ?? "Team created",
                              );
                              tp.clear();
                            },
                            child: tp.isLoading
                                ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.black,
                                strokeWidth: 2,
                              ),
                            )
                                : Text(
                              "Create Team",
                              style: GoogleFonts.spaceMono(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: h * 0.017,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: h * 0.05),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label, VoidCallback onDelete,
      {Color color = C.green}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 5),
          GestureDetector(
            onTap: onDelete,
            child: Icon(Icons.close, size: 14, color: color),
          ),
        ],
      ),
    );
  }
}