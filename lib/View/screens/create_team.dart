import 'package:dev_partner/View/widgets/cp_ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/theme.dart';

class CreateTeamScreen extends StatelessWidget {
  const CreateTeamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    // Controllers & Nodes
    final teamNameController = TextEditingController();
    final skillsController = TextEditingController();
    final teamFocus = FocusNode();
    final skillFocus = FocusNode();

    // Notifiers for dynamic selection
    final domainNotifier = ValueNotifier<String>("Select project domain...");
    final teamSizeNotifier = ValueNotifier<int>(4);

    // Multiple Selection Notifiers
    final selectedSkills = ValueNotifier<List<String>>([]);
    final selectedRoles = ValueNotifier<List<String>>([]);

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
            /// 1. HEADER SECTION
            Center(
              child: Column(
                children: [
                  Icon(Icons.extension, color: C.green, size: w * 0.1),
                  SizedBox(height: h * 0.02),

                  // Title with "Dream" on first line and "Team" on second line
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: GoogleFonts.dmSans(
                        fontSize: w * 0.08,
                        fontWeight: FontWeight.bold,
                        height: 1.1,
                      ),
                      children: [
                        TextSpan(text: "Create Your ", style:GoogleFonts.spaceMono(color: Colors.white)),
                        WidgetSpan(
                          child: ShaderMask(
                            blendMode: BlendMode.srcIn,
                            shaderCallback: (bounds) => LinearGradient(
                              colors: [C.green, C.cyan],
                            ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                            child: Text("Dream", style: GoogleFonts.spaceMono(fontWeight: FontWeight.bold, fontSize: w * 0.08)),
                          ),
                        ),
                        const TextSpan(text: "\n"), // Line break
                        WidgetSpan(
                          child: ShaderMask(
                            blendMode: BlendMode.srcIn,
                            shaderCallback: (bounds) => LinearGradient(
                              colors: [C.green, C.cyan],
                            ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                            child: Text("Team", style: GoogleFonts.spaceMono(fontWeight: FontWeight.bold, fontSize: w * 0.08)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: h * 0.04),

            /// 2. MAIN FORM CARD
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF0D1117),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: C.border),
              ),
              child: Column(
                children: [
                  // Top Gradient Bar
                  Container(
                    height: 2,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                      gradient: LinearGradient(colors: [C.green, C.cyan, C.pink]),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.all(w * 0.05),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customTextField(
                          controller: teamNameController,
                          hintText: "e.g. \"Neural Ninjas\"",
                          labelText: "TEAM NAME",
                          Focusnode: teamFocus,
                        ),

                        spacer(),

                        /// PROJECT DOMAIN
                        Text("PROJECT DOMAIN", style: TextStyle(color: C.textLabel, fontSize: w * 0.032)),
                        SizedBox(height: h * 0.01),
                        buildDropdown(domainNotifier, [
                          "Select project domain...",
                          "AI/ML",
                          "Web Development",
                          "Mobile App",
                          "Blockchain"
                        ]),

                        spacer(),

                        /// MULTIPLE SKILLS INPUT
                        Text("REQUIRED SKILLS", style: TextStyle(color: C.textLabel, fontSize: w * 0.032)),
                        SizedBox(height: h * 0.005),
                        ValueListenableBuilder<List<String>>(
                          valueListenable: selectedSkills,
                          builder: (context, list, _) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (list.isNotEmpty)
                                  Padding(
                                    padding: EdgeInsets.only(bottom: h * 0.01),
                                    child: Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: list.map((skill) => _buildChip(skill, () {
                                        selectedSkills.value = List.from(list)..remove(skill);
                                      })).toList(),
                                    ),
                                  ),
                                TextField(
                                  controller: skillsController,
                                  onSubmitted: (val) {
                                    if (val.isNotEmpty) {
                                      selectedSkills.value = List.from(list)..add(val);
                                      skillsController.clear();
                                    }
                                  },
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: "Type skill and press Enter...",
                                    hintStyle: TextStyle(color: C.textMuted, fontSize: w * 0.035),
                                    filled: true,
                                    fillColor: C.surface,
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: C.border)),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),

                        spacer(),

                        /// MULTIPLE ROLES SELECTION
                        Text("REQUIRED ROLES", style: TextStyle(color: C.textLabel, fontSize: w * 0.032)),
                        SizedBox(height: h * 0.01),
                        ValueListenableBuilder<List<String>>(
                          valueListenable: selectedRoles,
                          builder: (context, list, _) {
                            final roleNotifier = ValueNotifier<String>("Select a role...");
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildDropdown(roleNotifier, [
                                  "Select a role...",
                                  "Frontend Dev",
                                  "Backend Dev",
                                  "UI/UX Designer",
                                  "Project Manager"
                                ]),
                                // Listen to dropdown change to add to list
                                ValueListenableBuilder<String>(
                                  valueListenable: roleNotifier,
                                  builder: (context, val, _) {
                                    if (val != "Select a role..." && !list.contains(val)) {
                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                        selectedRoles.value = List.from(list)..add(val);
                                        roleNotifier.value = "Select a role...";
                                      });
                                    }
                                    return const SizedBox.shrink();
                                  },
                                ),
                                if (list.isNotEmpty)
                                  Padding(
                                    padding: EdgeInsets.only(top: h * 0.015),
                                    child: Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: list.map((role) => _buildChip(role, () {
                                        selectedRoles.value = List.from(list)..remove(role);
                                      }, color: C.cyan)).toList(),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),

                        spacer(),

                        /// TEAM SIZE
                        Text("MAX TEAM SIZE", style: TextStyle(color: C.textLabel, fontSize: w * 0.032)),
                        SizedBox(height: h * 0.015),
                        ValueListenableBuilder<int>(
                          valueListenable: teamSizeNotifier,
                          builder: (context, size, _) {
                            return Column(
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
                                        onPressed: () => size > 1 ? teamSizeNotifier.value-- : null,
                                        icon: const Icon(Icons.remove, color: C.textMuted),
                                      ),
                                      Column(
                                        children: [
                                          Text("$size", style: GoogleFonts.spaceMono(fontSize: w * 0.07, color: C.cyan, fontWeight: FontWeight.bold)),
                                          Text("members max", style: TextStyle(color: C.textMuted, fontSize: w * 0.025)),
                                        ],
                                      ),
                                      IconButton(
                                        onPressed: () => size < 4 ? teamSizeNotifier.value++ : null,
                                        icon: const Icon(Icons.add, color: C.green),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: h * 0.02),
                                Row(
                                  children: List.generate(4, (index) => Expanded(
                                    child: Container(
                                      height: 4,
                                      margin: const EdgeInsets.symmetric(horizontal: 2),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(2),
                                        color: index < size ? C.cyan : C.border,
                                      ),
                                    ),
                                  )),
                                )
                              ],
                            );
                          },
                        ),

                        SizedBox(height: h * 0.04),

                        /// ADMIN INFO BOX
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
                              const Icon(Icons.workspace_premium, color: Colors.orangeAccent, size: 20),
                              SizedBox(width: w * 0.03),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("You'll be Team Admin", style: GoogleFonts.dmSans(color: C.green, fontWeight: FontWeight.bold, fontSize: w * 0.035)),
                                    SizedBox(height: h * 0.005),
                                    Text(
                                      "As creator, you approve join requests and manage roles.",
                                      style: TextStyle(color: C.textMuted, fontSize: w * 0.028, height: 1.4),
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
                            onPressed: () {},
                            child: Text(
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

  // Tag/Chip Builder
  Widget _buildChip(String label, VoidCallback onDelete, {Color color = C.green}) {
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
          Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w500)),
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