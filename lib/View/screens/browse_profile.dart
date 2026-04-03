import 'package:dev_partner/View/models/profile.dart';
import 'package:dev_partner/View/screens/create_profile.dart';
import 'package:dev_partner/View/screens/create_team.dart';
import 'package:dev_partner/View/screens/login.dart';
import 'package:dev_partner/View/screens/register.dart';
import 'package:dev_partner/View/widgets/bp_ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/theme.dart';
import '../widgets/cp_ui_helper.dart';

class  BrowseProfileScreen extends StatefulWidget {
  const BrowseProfileScreen({super.key});

  @override
  State<BrowseProfileScreen> createState() => _BrowseProfileScreenState();
}

class _BrowseProfileScreenState extends State<BrowseProfileScreen> {
  final TextEditingController searchController = TextEditingController();

  final List<String> semesterOptions = [
    "Semester",
    "Semester 1",
    "Semester 2",
    "Semester 3",
    "Semester 4",
    "Semester 5",
    "Semester 6",
    "Semester 7",
    "Semester 8",
  ];
  final List<String> classOptions = ["Class", "BSCS", "BSSE", "BSAI"];
  final List<String> programOptions = ["Program", "Evening", "Morning"];
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

  final ValueNotifier<String> selectedSemester = ValueNotifier("Semester");
  final ValueNotifier<String> selectedClass = ValueNotifier("Class");
  final ValueNotifier<String> selectedProgram = ValueNotifier("Program");

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

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
            "Discover Partner",
            style: GoogleFonts.dmSans(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: width * 0.06,
            ),
          ),
        ),
      ),
      drawer: Drawer(
          width: (width * 0.65).clamp(260.0, 320.0), // professional width
          child: Container(
            color: C.bg, // fully matches your theme
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // Drawer Header
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: C.surface.withOpacity(0.15), // subtle header background
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(colors: [C.green, C.cyan]),
                        ),
                        child: CircleAvatar(
                          radius: 22,
                          backgroundColor: C.bg,
                          child: Icon(
                            Icons.account_circle_rounded,
                            color: C.green,
                            size: 32,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          "Ahmed", // dummy username
                          style: GoogleFonts.spaceMono(
                            color: C.green,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Drawer Items
                drawerItem(Icons.login, "Login", () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                }),
                drawerItem(Icons.app_registration, "Create Team", () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>CreateTeamScreen()));
                }),
                drawerItem(Icons.person, "Create Profile", () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>CreateProfileScreen()));
                }),
                drawerItem(Icons.chat, "Chats", () {}),
                drawerItem(Icons.people, "My Team", () {}),
                drawerItem(Icons.logout_outlined, "Logout", () {}),
                spacer(),

                // Help & Policy
                drawerItem(Icons.help_outline, "Help & Support", () {}),
                drawerItem(Icons.warning_amber_rounded, "Disclaimer", () {}),
                drawerItem(Icons.privacy_tip_outlined, "Privacy Policy", () {}),
              ],
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
              buildDropdownRow3(
                  notifier1:selectedClass,
                  options1: classOptions,
                  notifier2: selectedProgram,
                  options2: programOptions,
                  notifier3: selectedSemester,
                  options3: semesterOptions,
                  spacing: width*0.02
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