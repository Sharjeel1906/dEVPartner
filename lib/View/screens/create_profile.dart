import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/theme.dart';
import '../widgets/cp_ui_helper.dart';

class CreateProfileScreen extends StatelessWidget {
  CreateProfileScreen({super.key});

  // Controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController githubController = TextEditingController();
  final TextEditingController portfolioController = TextEditingController();
  final TextEditingController linkedinController = TextEditingController();
  TextEditingController skillController = TextEditingController();
  TextEditingController domainController = TextEditingController();

  // FocusNodes
  final FocusNode aboutFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();

  // Dropdown options
  final List<String> genderOptions = ["Select", "Male", "Female", "Other"];
  final List<String> roleOptions = ["Select", "Leader", "Member"];
  final List<String> semesterOptions = [
    "Select",
    "Semester 1",
    "Semester 2",
    "Semester 3",
    "Semester 4",
    "Semester 5",
    "Semester 6",
    "Semester 7",
    "Semester 8",
  ];
  final List<String> sectionOptions = ["Select", "A", "B", "C", "D"];
  final List<String> classOptions = ["Select", "BSCS", "BSSE", "BSAI"];
  final List<String> programOptions = ["Select", "Evening", "Morning"];
  final List<String> experienceOptions = ["Select", "Beginner", "Intermediate","Advanced","Expert"];


  // ValueNotifiers for dropdowns
  final ValueNotifier<String> selectedGender = ValueNotifier("Select");
  final ValueNotifier<String> selectedRole = ValueNotifier("Select");
  final ValueNotifier<String> selectedSemester = ValueNotifier("Select");
  final ValueNotifier<String> selectedSection = ValueNotifier("Select");
  final ValueNotifier<String> selectedClass = ValueNotifier("Select");
  final ValueNotifier<String> selectedProgram = ValueNotifier("Select");
  final ValueNotifier<String> selectedExp = ValueNotifier("Select");


  // ValueNotifiers for pickers
  final ValueNotifier<File?> selectedImage = ValueNotifier(null);
  final ValueNotifier<File?> selectedCV = ValueNotifier(null);
  ValueNotifier<List<String>> selectedSkills = ValueNotifier([]);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: C.bg,
      appBar: AppBar(
        backgroundColor: C.bg,
        elevation: 0,
        iconTheme: IconThemeData(
          color: C.green, // sets color for built-in back button or drawer icon
        ),
        title: ShaderMask(
          shaderCallback: (bounds) =>
              LinearGradient(colors: [C.green, C.cyan]).createShader(
                Rect.fromLTWH(0, 0, bounds.width, bounds.height),
              ),
          child: Text(
            "dEVPartner",
            style: GoogleFonts.dmSans(
              color: Colors.white, // gradient overrides this
              fontWeight: FontWeight.bold,
              fontSize: width * 0.06,
            ),
          ),
        ),
        automaticallyImplyLeading: true,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: height * 0.02),

              // Step Capsules
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

              // Form Container
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
                    // Personal Section
                    sectionHeading(context: context, text: "Personal"),
                    SizedBox(height: height * 0.001),

                    sectionSubHeading(context: context, text: "Your vibe, your intro⚡"),
                    SizedBox(height: height * 0.02),

                    Center(
                      child: ValueListenableBuilder<File?>(
                        valueListenable: selectedImage,
                        builder: (context, file, _) {
                          return GestureDetector(
                            onTap: () {}, // implement picker later
                            child: CircleAvatar(
                              radius: 45,
                              backgroundColor: C.surface,
                              backgroundImage: file != null
                                  ? FileImage(file)
                                  : null,
                              child: file == null
                                  ? Icon(
                                      Icons.add_a_photo,
                                      color: C.green,
                                      size: 40,
                                    )
                                  : null,
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    customTextField(
                      Focusnode: FocusNode(),
                      controller: nameController,
                      hintText: "e.g Ali",
                      labelText: "  Name",
                    ),
                    SizedBox(height: height * 0.02),
                    customTextField(
                      Focusnode: FocusNode(),
                      controller: emailController,
                      hintText: "abc@gmail.com",
                      labelText: "Email",
                    ),
                    SizedBox(height: height * 0.02),
                    customTextField(
                      Focusnode: aboutFocus,
                      controller: aboutController,
                      hintText: "Tell us about yourself",
                      labelText: "ABOUT",
                    ),
                    SizedBox(height: height * 0.02),

                    buildLabeledDropdownRow(
                      label1: "Gender",
                      notifier1: selectedGender,
                      options1: genderOptions,
                      label2: "Role",
                      notifier2: selectedRole,
                      options2: roleOptions,
                      spacing: width * 0.03,
                    ),
                    SizedBox(height: height * 0.02),
                    spacer(),

                    // Academic Section
                    sectionHeading(context: context, text: "Academic"),
                    SizedBox(height: height * 0.001),
                    sectionSubHeading(context: context, text: "Your academic saga, in brief✨"),
                    SizedBox(height: height * 0.02),

                    // Dropdowns: Semester & Class
                    buildLabeledDropdownRow(
                      label1: "SEMESTER",
                      notifier1: selectedSemester,
                      options1: semesterOptions,
                      label2: "CLASS",
                      notifier2: selectedClass,
                      options2: classOptions,
                      spacing: width * 0.03,
                    ),
                    SizedBox(height: height * 0.02),

                    // Dropdowns: Program & Section
                    buildLabeledDropdownRow(
                      label1: "PROGRAM",
                      notifier1: selectedProgram,
                      options1: programOptions,
                      label2: "SECTION",
                      notifier2: selectedSection,
                      options2: sectionOptions,
                      spacing: width * 0.03,
                    ),
                    SizedBox(height: height * 0.03),
                    spacer(),

                    //Skills Section
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        sectionHeading(context: context, text: "Skills"),
                        SizedBox(height: height * 0.001),
                        sectionSubHeading(context: context, text: "Flex your talents😎"),
                        SizedBox(height: height * 0.02),

                        // Chips Display
                        ValueListenableBuilder<List<String>>(
                          valueListenable: selectedSkills,
                          builder: (context, skills, _) {
                            return Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: skills.map((skill) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: C.surface,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: C.green.withOpacity(0.4),
                                        blurRadius: 8,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                    border: Border.all(
                                      color: C.green.withOpacity(0.6),
                                      width: 1,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          skill,
                                          style: TextStyle(
                                            color: C.green,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(width: 4),
                                        GestureDetector(
                                          onTap: () {
                                            selectedSkills.value =
                                            List.from(selectedSkills.value)
                                              ..remove(skill);
                                          },
                                          child: Icon(
                                            Icons.close,
                                            size: 18,
                                            color: C.green,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                          },
                        ),

                        SizedBox(height: height * 0.02),

                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: C.surface,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: TextField(
                                  controller: skillController,
                                  style: TextStyle(color: C.textPrimary),
                                  cursorColor: C.green,
                                  decoration: InputDecoration(
                                    hintText: "Add a skill...",
                                    hintStyle: TextStyle(color: C.textLabel),
                                    filled: true,
                                    fillColor: C.surface,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 14,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(color: C.border),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(color: C.border),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                        color: C.green,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  onSubmitted: (value) {
                                    final trimmed = value.trim();
                                    if (trimmed.isNotEmpty &&
                                        !selectedSkills.value.contains(trimmed)) {
                                      selectedSkills.value =
                                      List.from(selectedSkills.value)..add(trimmed);
                                    }
                                    skillController.clear();
                                  },
                                ),
                              ),
                            ),

                            SizedBox(width: 10),

                            Container(
                              decoration: BoxDecoration(
                                color: C.green,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: C.green.withOpacity(0.3),
                                    blurRadius: 6,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: IconButton(
                                onPressed: () {
                                  final value = skillController.text.trim();
                                  if (value.isNotEmpty &&
                                      !selectedSkills.value.contains(value)) {
                                    selectedSkills.value =
                                    List.from(selectedSkills.value)..add(value);
                                  }
                                  skillController.clear();
                                },
                                icon: Icon(Icons.add, color: Colors.black),
                                splashRadius: 24,
                                tooltip: "Add Skill",
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.03),
                    spacer(),

                    // Domain & Exp Section
                    sectionHeading(context: context, text: "Domain & Experience"),
                    SizedBox(height: height * 0.001),
                    sectionSubHeading(context: context, text: "Your hustle in a nutshell🚀"),
                    SizedBox(height: height * 0.02),
                    customTextField(
                      Focusnode: FocusNode(),
                      controller: domainController,
                      hintText: "e.g FrontEnd Dev",
                      labelText: "DOMAIN",
                    ),
                    SizedBox(height: height * 0.01),
                    Text(
                      "EXPERIENCE",
                      style: TextStyle(
                        fontSize: width * 0.033,
                        color: C.textLabel,
                      ),
                    ),
                    SizedBox(height: height * 0.001),
                    buildDropdown(selectedExp, experienceOptions),
                    SizedBox(height: height * 0.02),
                    spacer(),

                    // Links Section
                    sectionHeading(context: context, text: "Links"),
                    SizedBox(height: height * 0.001),
                    sectionSubHeading(context: context, text: "Drop links that scream ‘look at me!🌟"),
                    SizedBox(height: height * 0.02),
                    customTextField(
                      Focusnode: FocusNode(),
                      controller: linkedinController,
                      hintText: "LinkedIn URL",
                      labelText: "LINKEDIN URL",
                    ),
                    SizedBox(height: height * 0.03),
                    customTextField(
                      Focusnode: FocusNode(),
                      controller: githubController,
                      hintText: "GitHub URL",
                      labelText: "GITHUB URL",
                    ),
                    SizedBox(height: height * 0.02),
                    customTextField(
                      Focusnode: FocusNode(),
                      controller: portfolioController,
                      hintText: "Portfolio URL",
                      labelText: "PORTFOLIO URL",
                    ),
                    SizedBox(height: height * 0.03),

                    Text(
                      "CV/RESUME",
                      style: GoogleFonts.spaceMono(
                        fontSize: width * 0.035,
                        color: C.textLabel,
                      ),
                    ),
                    SizedBox(height: height * 0.01),
                    ValueListenableBuilder<File?>(
                      valueListenable: selectedCV,
                      builder: (context, file, _) {
                        return GestureDetector(
                          onTap: () {}, // implement picker later
                          child: Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: C.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: C.border),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  file != null
                                      ? file.path.split('/').last
                                      : "Pick your CV (PDF)",
                                  style: TextStyle(color: C.textLabel),
                                ),
                                Icon(Icons.attach_file, color: C.green),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    SizedBox(height: height * 0.03),

                    // Save Button
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
                          "Save Profile",
                          style: GoogleFonts.spaceMono(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: height * 0.017,
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
      ),
    );
  }
}
