import 'dart:io';
import 'package:dev_partner/model_view/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../widgets/theme.dart';
import '../widgets/cp_ui_helper.dart';

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({super.key});

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().loadCurrentUser();
    });
  }

  bool _isFormEmpty(UserProvider up) {
    return up.profile_controllers["name"]!.text.isEmpty &&
        up.profile_controllers["email"]!.text.isEmpty &&
        up.selectedGender == "Select" &&
        up.selectedSkills.isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final up = context.watch<UserProvider>();

    return Scaffold(
      backgroundColor: C.bg,
      appBar: AppBar(
        backgroundColor: C.bg,
        elevation: 0,
        iconTheme: IconThemeData(color: C.green),
        automaticallyImplyLeading: true,
        title: ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [C.green, C.cyan],
          ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
          child: Text(
            "dEVPartner",
            style: GoogleFonts.dmSans(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: width * 0.06,
            ),
          ),
        ),
      ),
      body: up.isLoading && _isFormEmpty(up)
          ? Center(
        child: CircularProgressIndicator(color: C.green),
      )
          : SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: height * 0.02),
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
                    sectionSubHeading(
                      context: context,
                      text: "Your vibe, your intro⚡",
                    ),
                    SizedBox(height: height * 0.02),
                    Center(
                      child: GestureDetector(
                        onTap: () async {
                          await up.pickImage();
                        },
                        child: CircleAvatar(
                          radius: 65,
                          backgroundColor: C.surface,
                          backgroundImage: up.selectedImage != null
                              ? FileImage(up.selectedImage!) as ImageProvider
                              : up.currentImageUrl != null
                              ? NetworkImage(up.currentImageUrl!)
                              : null,
                          child: up.selectedImage == null && up.currentImageUrl == null
                              ? Icon(Icons.add_a_photo, color: C.green, size: 40)
                              : null,
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    customTextField(
                      Focusnode: up.profile_focus["name"]!,
                      controller: up.profile_controllers["name"]!,
                      hintText: "e.g Ali",
                      labelText: "  Name",
                    ),
                    SizedBox(height: height * 0.02),
                    customTextField(
                      Focusnode: up.profile_focus["email"]!,
                      controller: up.profile_controllers["email"]!,
                      hintText: "abc@gmail.com",
                      labelText: "Email",
                    ),
                    SizedBox(height: height * 0.02),
                    customTextField(
                      Focusnode: up.profile_focus["about"]!,
                      controller: up.profile_controllers["about"]!,
                      hintText: "Tell us about yourself",
                      labelText: "ABOUT",
                    ),
                    SizedBox(height: height * 0.02),
                    buildLabeledDropdownRow(
                      label1: "Gender",
                      value1: up.selectedGender,
                      options1: up.genderOptions,
                      onChanged1: up.setGender,
                      label2: "Role",
                      value2: up.selectedRole,
                      options2: up.roleOptions,
                      onChanged2: up.setRole,
                      spacing: width * 0.03,
                    ),
                    SizedBox(height: height * 0.02),
                    spacer(),
                    sectionHeading(context: context, text: "Academic"),
                    SizedBox(height: height * 0.001),
                    sectionSubHeading(
                      context: context,
                      text: "Your academic saga, in brief✨",
                    ),
                    SizedBox(height: height * 0.02),
                    buildLabeledDropdownRow(
                      label1: "SEMESTER",
                      value1: up.selectedSemester,
                      options1: up.semesterOptions,
                      onChanged1: up.setSemester,
                      label2: "CLASS",
                      value2: up.selectedClass,
                      options2: up.classOptions,
                      onChanged2: up.setClass,
                      spacing: width * 0.03,
                    ),
                    SizedBox(height: height * 0.02),
                    buildLabeledDropdownRow(
                      label1: "PROGRAM",
                      value1: up.selectedProgram,
                      options1: up.programOptions,
                      onChanged1: up.setProgram,
                      label2: "SECTION",
                      value2: up.selectedSection,
                      options2: up.sectionOptions,
                      onChanged2: up.setSection,
                      spacing: width * 0.03,
                    ),
                    SizedBox(height: height * 0.03),
                    spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        sectionHeading(context: context, text: "Skills"),
                        SizedBox(height: height * 0.001),
                        sectionSubHeading(
                          context: context,
                          text: "Flex your talents😎",
                        ),
                        SizedBox(height: height * 0.02),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: up.selectedSkills.map((skill) {
                            return Container(
                              decoration: BoxDecoration(
                                color: C.surface,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: C.green.withOpacity(0.4),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
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
                                    const SizedBox(width: 4),
                                    GestureDetector(
                                      onTap: () => up.removeSkill(skill),
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
                                  controller: up.profile_controllers["skill"],
                                  focusNode: up.profile_focus["skill"]!,
                                  style: TextStyle(color: C.textPrimary),
                                  cursorColor: C.green,
                                  decoration: InputDecoration(
                                    hintText: "Add a skill...",
                                    hintStyle: TextStyle(color: C.textLabel),
                                    filled: true,
                                    fillColor: C.surface,
                                    contentPadding: const EdgeInsets.symmetric(
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
                                  onSubmitted: (val) {
                                    final trimmed = val.trim();
                                    if (trimmed.isNotEmpty) {
                                      up.addSkill(trimmed);
                                    }
                                    up.profile_controllers["skill"]!.clear();
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              decoration: BoxDecoration(
                                color: C.green,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: C.green.withOpacity(0.3),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: IconButton(
                                onPressed: () {
                                  final val =
                                  up.profile_controllers["skill"]!.text.trim();
                                  if (val.isNotEmpty) {
                                    up.addSkill(val);
                                  }
                                  up.profile_controllers["skill"]!.clear();
                                },
                                icon: const Icon(Icons.add, color: Colors.black),
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
                    sectionHeading(context: context, text: "Domain & Experience"),
                    SizedBox(height: height * 0.001),
                    sectionSubHeading(
                      context: context,
                      text: "Your hustle in a nutshell🚀",
                    ),
                    SizedBox(height: height * 0.02),
                    customTextField(
                      Focusnode: up.profile_focus["domain"]!,
                      controller: up.profile_controllers["domain"]!,
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
                    buildDropdown(
                      value: up.selectedExp,
                      options: up.experienceOptions,
                      onChanged: up.setExp,
                    ),
                    SizedBox(height: height * 0.02),
                    spacer(),
                    sectionHeading(context: context, text: "Links"),
                    SizedBox(height: height * 0.001),
                    sectionSubHeading(
                      context: context,
                      text: "Drop links that scream 'look at me!🌟",
                    ),
                    SizedBox(height: height * 0.02),
                    customTextField(
                      Focusnode: up.profile_focus["linkedin"]!,
                      controller: up.profile_controllers["linkedin"]!,
                      hintText: "LinkedIn URL",
                      labelText: "LINKEDIN URL",
                    ),
                    SizedBox(height: height * 0.03),
                    customTextField(
                      Focusnode: up.profile_focus["github"]!,
                      controller: up.profile_controllers["github"]!,
                      hintText: "GitHub URL",
                      labelText: "GITHUB URL",
                    ),
                    SizedBox(height: height * 0.02),
                    customTextField(
                      Focusnode: up.profile_focus["portfolio"]!,
                      controller: up.profile_controllers["portfolio"]!,
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
                    GestureDetector(
                      onTap: () async {
                        await up.pickPdf();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: C.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: C.border),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                up.selectedCV != null
                                    ? up.selectedCV!.path.split('/').last
                                    : up.currentCvName ?? "Pick your CV (PDF)",
                                style: TextStyle(color: C.textLabel),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Icon(Icons.attach_file, color: C.green),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.03),
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
                        onPressed: up.isLoading
                            ? null
                            : () async {
                          final msg = await up.updateUser(
                            gender: up.selectedGender,
                            role: up.selectedRole,
                            about: up.profile_controllers["about"]!.text.trim(),
                            section: up.selectedSection,
                            className: up.selectedClass,
                            program: up.selectedProgram,
                            semester: up.selectedSemester,
                            domain: up.profile_controllers["domain"]!.text.trim(),
                            linkedIn: up.profile_controllers["linkedin"]!.text.trim(),
                            github: up.profile_controllers["github"]!.text.trim(),
                            portfolio: up.profile_controllers["portfolio"]!.text.trim(),
                            skills: up.selectedSkills,
                            pfp: up.selectedImage,
                            cv: up.selectedCV,
                          );
                          if (!context.mounted) return;
                          if (msg.success) {
                            customColoredBox(
                              context,
                              msg.message ?? "Profile updated successfully",
                            );
                          } else {
                            customColoredBox(
                              context,
                              msg.message ?? "Something went wrong",
                            );
                          }
                        },
                        child: up.isLoading
                            ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.black,
                            strokeWidth: 2,
                          ),
                        )
                            : Text(
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