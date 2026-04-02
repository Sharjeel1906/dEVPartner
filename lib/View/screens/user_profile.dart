import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/theme.dart';
import '../widgets/cp_ui_helper.dart';
import '../widgets/up_ui_helper.dart';

class UserProfileScreen extends StatelessWidget {
  UserProfileScreen({super.key});

  // Dummy skills
  final List<String> skills = ["Flutter", "Python", "React"];

  // Dummy selectedImage (null means fallback icon)
  final ValueNotifier<File?> selectedImage = ValueNotifier<File?>(null);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: C.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
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
                      "Ahmed",
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
                    sectionSubHeading(context: context, text: "Vibe, Intro⚡"),
                    SizedBox(height: height * 0.02),
                    Center(
                      child: Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: C.surface,
                          borderRadius: BorderRadius.circular(45), // circular
                          border: Border.all(color: C.border),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(45),
                          child: ValueListenableBuilder<File?>(
                            valueListenable: selectedImage,
                            builder: (context, file, _) {
                              return file != null
                                  ? Image.file(file, width: 90, height: 90, fit: BoxFit.cover)
                                  : Center(
                                child: Icon(
                                  Icons.person, // fallback icon
                                  color: C.green,
                                  size: 40,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    customDataContainer(data: "Ahmed", labelText: "Name"),
                    SizedBox(height: height * 0.02),
                    customDataContainer(data: "ahmed@gmail.com", labelText: "Email"),
                    SizedBox(height: height * 0.02),
                    customDataContainer(data: "I am a student", labelText: "About"),
                    SizedBox(height: height * 0.02),
                    customDataContainer(data: "Male", labelText: "Gender"),
                    SizedBox(height: height * 0.02),
                    customDataContainer(data: "Leader", labelText: "Role"),
                    SizedBox(height: height * 0.02),
                    spacer(),

                    // Academic Section
                    sectionHeading(context: context, text: "Academic"),
                    SizedBox(height: height * 0.001),
                    sectionSubHeading(context: context, text: "Academic saga, in brief✨"),
                    SizedBox(height: height * 0.02),
                    customDataContainer(data: "Semester 1", labelText: "Semester"),
                    SizedBox(height: height * 0.02),
                    customDataContainer(data: "BSSE", labelText: "Class"),
                    SizedBox(height: height * 0.02),
                    customDataContainer(data: "Morning", labelText: "Program"),
                    SizedBox(height: height * 0.02),
                    customDataContainer(data: "A", labelText: "Section"),
                    SizedBox(height: height * 0.03),
                    spacer(),

                    sectionHeading(context: context, text: "Skills"),
                    SizedBox(height: height * 0.001),
                    sectionSubHeading(context: context, text: "Flexing talents😎"),
                    SizedBox(height: height * 0.01),
                    Wrap(
                      spacing: width * 0.02,
                      children: skills.map((skill) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: width * 0.03, vertical: height * 0.008),
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

                    // Domain & Experience Section
                    sectionHeading(context: context, text: "Domain & Experience"),
                    SizedBox(height: height * 0.001),
                    sectionSubHeading(context: context, text: "Hustle in a nutshell🚀"),
                    SizedBox(height: height * 0.02),
                    customDataContainer(data: "FrontEnd Dev", labelText: "Domain"),
                    SizedBox(height: height * 0.01),
                    customDataContainer(data: "Intermediate", labelText: "Experience"),
                    SizedBox(height: height * 0.02),
                    spacer(),

                    // Links Section
                    sectionHeading(context: context, text: "Links"),
                    SizedBox(height: height * 0.001),
                    sectionSubHeading(context: context, text: "Links that scream ‘look at me!🌟"),
                    SizedBox(height: height * 0.02),
                    customDataContainer(data: "https://linkedin.com", labelText: "LinkedIn"),
                    SizedBox(height: height * 0.03),
                    customDataContainer(data: "https://github.com", labelText: "Github"),
                    SizedBox(height: height * 0.02),
                    customDataContainer(data: "https://portfolio.com", labelText: "Portfolio"),
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
                          "Invite To Team",
                          style: TextStyle(
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