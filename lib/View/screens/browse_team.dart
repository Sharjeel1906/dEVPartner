import 'dart:io';
import 'package:dev_partner/View/models/profile.dart';
import 'package:dev_partner/View/screens/create_profile.dart';
import 'package:dev_partner/View/screens/login.dart';
import 'package:dev_partner/View/screens/register.dart';
import 'package:dev_partner/View/widgets/bottom_nav_bar.dart';
import 'package:dev_partner/View/widgets/bt_ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/theme.dart';
import '../widgets/cp_ui_helper.dart';

class BrowseTeamScreen extends StatefulWidget {
  const BrowseTeamScreen({super.key});

  @override
  State<BrowseTeamScreen> createState() => _BrowseTeamScreenState();
}

class _BrowseTeamScreenState extends State<BrowseTeamScreen> {
  final TextEditingController searchController = TextEditingController();

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
  final List<String> classOptions = ["Select", "BSCS", "BSSE", "BSAI"];
  final List<String> programOptions = ["Select", "Evening", "Morning"];
  List<Profile> profiles = [
    Profile(
      name: "Alisha M.",
      role: "Computer Science",
      semester: "7th Semester",
      domain: "Data Science",
      imageUrl: "https://randomuser.me/api/portraits/women/44.jpg",
      skills: ["Python", "AWS", "React"],
    ),
    Profile(
      name: "Ali Raza",
      role: "Software Engineering",
      semester: "5th Semester",
      domain: "Flutter",
      imageUrl: "https://randomuser.me/api/portraits/men/32.jpg",
      skills: ["Flutter", "Firebase", "Dart"],
    ),
    Profile(
      name: "Sara Khan",
      role: "Information Technology",
      semester: "6th Semester",
      domain: "Web Dev",
      imageUrl: "https://randomuser.me/api/portraits/women/68.jpg",
      skills: ["HTML", "CSS", "JavaScript"],
    ),
    Profile(
      name: "Usman Tariq",
      role: "Computer Science",
      semester: "8th Semester",
      domain: "AI/ML",
      imageUrl: "https://randomuser.me/api/portraits/men/75.jpg",
      skills: ["TensorFlow", "PyTorch", "Python"],
    ),
    Profile(
      name: "Hina Sheikh",
      role: "Software Engineering",
      semester: "4th Semester",
      domain: "UI/UX",
      imageUrl: "https://randomuser.me/api/portraits/women/21.jpg",
      skills: ["Figma", "Adobe XD", "Prototyping"],
    ),
    Profile(
      name: "Bilal Ahmed",
      role: "Computer Science",
      semester: "3rd Semester",
      domain: "Cyber Security",
      imageUrl: "https://randomuser.me/api/portraits/men/11.jpg",
      skills: ["Networking", "Ethical Hacking", "Linux"],
    ),
  ];
  final List<Widget> screens = [
    BrowseTeamScreen(),
    CreateProfileScreen(),
    LoginScreen(),
    RegisterScreen(),
  ];

  final ValueNotifier<String> selectedSemester = ValueNotifier("Select");
  final ValueNotifier<String> selectedClass = ValueNotifier("Select");
  final ValueNotifier<String> selectedProgram = ValueNotifier("Select");

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
                    onTap: () => {},
                    child: Icon(
                      Icons.menu,
                      color: C.green,
                      size: width * 0.08,
                    ),
                  ),
                  SizedBox(width: width * 0.02),
                  ShaderMask(
                    shaderCallback: (bounds) =>
                        LinearGradient(colors: [C.green, C.cyan]).createShader(
                          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                        ),
                    child: Text(
                      "Discover Partner",
                      style: GoogleFonts.dmSans(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: width * 0.06,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: height*0.04,),
              TextField(
                controller: searchController,
                focusNode: FocusNode(),
                style: TextStyle(color: C.textPrimary),
                cursorColor: C.green,
                decoration: InputDecoration(
                  hintText: "Search by name or domain",
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
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: C.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: C.border),
                ),
                child: buildLabeledDropdownRow3(
                    label1: "Class",
                    notifier1:selectedClass,
                    options1: classOptions,
                    label2: "Program",
                    notifier2: selectedProgram,
                    options2: programOptions,
                    label3: "Semester",
                    notifier3: selectedSemester,
                    options3: semesterOptions,
                    spacing: width*0.02
                ),
              ),
              SizedBox(height: height*0.02,),
              ListView.builder(
                itemCount: profiles.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return profileCard(context,profiles[index]);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}