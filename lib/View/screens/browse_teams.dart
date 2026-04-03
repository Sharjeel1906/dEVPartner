import 'package:dev_partner/View/models/profile.dart';
import 'package:dev_partner/View/models/project.dart';
import 'package:dev_partner/View/widgets/bt_ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/theme.dart';
import '../widgets/cp_ui_helper.dart';

class  BrowseTeamsScreen extends StatefulWidget {
  const BrowseTeamsScreen({super.key});

  @override
  State<BrowseTeamsScreen> createState() => _BrowseTeamsScreenState();
}

class _BrowseTeamsScreenState extends State<BrowseTeamsScreen> {
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

  List<Project> projects = [
    Project(
      category: "WEB DEVELOPMENT",
      title: "EduQuest",
      description:
      "An adaptive learning platform that turns course content into story-driven RPG quests.",
      skills: ["Next.js", "TypeScript", "PostgreSQL"],
      role: "Project Manager",
      spotsLeft: 2,
      totalSpots: 4,
      timeAgo: "2d ago",
    ),
    Project(
      category: "COMPUTER VISION",
      title: "VisionGuard",
      description:
      "CV system that monitors bus routes via CCTV to detect PPE non-compliance.",
      skills: ["Python", "OpenCV", "PyTorch"],
      role: "",
      spotsLeft: 1,
      totalSpots: 3,
      timeAgo: "3d ago",
    ),
    Project(
      category: "WEB DEVELOPMENT",
      title: "EduQuest",
      description:
      "An adaptive learning platform that turns course content into story-driven RPG quests.",
      skills: ["Next.js", "TypeScript", "PostgreSQL"],
      role: "Project Manager",
      spotsLeft: 2,
      totalSpots: 4,
      timeAgo: "2d ago",
    ),
    Project(
      category: "COMPUTER VISION",
      title: "VisionGuard",
      description:
      "CV system that monitors bus routes via CCTV to detect PPE non-compliance.",
      skills: ["Python", "OpenCV", "PyTorch"],
      role: "",
      spotsLeft: 1,
      totalSpots: 3,
      timeAgo: "3d ago",
    ),
    Project(
      category: "WEB DEVELOPMENT",
      title: "EduQuest",
      description:
      "An adaptive learning platform that turns course content into story-driven RPG quests.",
      skills: ["Next.js", "TypeScript", "PostgreSQL"],
      role: "Project Manager",
      spotsLeft: 2,
      totalSpots: 4,
      timeAgo: "2d ago",
    ),
    Project(
      category: "COMPUTER VISION",
      title: "VisionGuard",
      description:
      "CV system that monitors bus routes via CCTV to detect PPE non-compliance.",
      skills: ["Python", "OpenCV", "PyTorch"],
      role: "",
      spotsLeft: 1,
      totalSpots: 3,
      timeAgo: "3d ago",
    ),
  ];

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
            "Discover Teams",
            style: GoogleFonts.dmSans(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: width * 0.06,
            ),
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
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: C.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: C.border),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: customizedColumn(
                        context: context,
                        icon: Icons.event_available,
                        title: "Teams 👥",
                        value: "10",
                      ),
                    ),

                    statDivider(context),

                    Expanded(
                      child: customizedColumn(
                        context: context,
                        icon: Icons.search,
                        title: "Recruiting 📝",
                        value: "6",
                      ),
                    ),

                    statDivider(context),

                    Expanded(
                      child: customizedColumn(
                        context: context,
                        icon: Icons.people,
                        title: "Spots 🏆",
                        value: "24",
                      ),
                    ),
                  ],
                )
              ),
              SizedBox(height: height*0.02,),
              TextField(
                controller: searchController,
                focusNode: FocusNode(),
                style: TextStyle(color: C.textPrimary),
                cursorColor: C.green,
                decoration: InputDecoration(
                  hintText: "Search by name, domain, skills etc",
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
              Column(
                children: projects.asMap().entries.map((entry) {
                  int index = entry.key;
                  Project project = entry.value;
                  final List<Color> accentColors = [C.purple,C.pink, C.amber, C.blue , C.orange];
                  final Color color = accentColors[index % accentColors.length];
                  return projectCard(
                    context: context,
                    project: project,
                    accentColor: color,
                  );
                }).toList(),
              )
            ],
          ),
        ),
      ),
    );
  }
}