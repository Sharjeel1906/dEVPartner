import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import '../model/user_services.dart';

class UserProvider extends ChangeNotifier {
  final UserServices _userService = UserServices();

  bool isLoading = false;

  // ================= CONTROLLERS =================
  final Map<String, TextEditingController> profile_controllers = {
    "name": TextEditingController(),
    "email": TextEditingController(),
    "about": TextEditingController(),
    "skill": TextEditingController(),
    "domain": TextEditingController(),
    "linkedin": TextEditingController(),
    "github": TextEditingController(),
    "portfolio": TextEditingController(),
  };
  final Map<String, FocusNode> profile_focus = {
    "name": FocusNode(),
    "email": FocusNode(),
    "about": FocusNode(),
    "skill": FocusNode(),
    "domain": FocusNode(),
    "linkedin": FocusNode(),
    "github": FocusNode(),
    "portfolio": FocusNode(),
  };

  // ================= DROPDOWN OPTIONS =================
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

  final List<String> experienceOptions = [
    "Select",
    "Beginner",
    "Intermediate",
    "Advanced",
    "Expert",
  ];

  // ================= SELECTED VALUES (FIXED - ONLY ONCE) =================
  String selectedGender = "Select";
  String selectedRole = "Select";
  String selectedSemester = "Select";
  String selectedSection = "Select";
  String selectedClass = "Select";
  String selectedProgram = "Select";
  String selectedExp = "Select";

  // ================= FILES =================
  File? selectedImage;
  File? selectedCV;

  // ================= SKILLS =================
  List<String> selectedSkills = [];

  // ================= SETTERS =================
  void setGender(String value) {
    selectedGender = value;
    notifyListeners();
  }

  void setRole(String value) {
    selectedRole = value;
    notifyListeners();
  }

  void setSemester(String value) {
    selectedSemester = value;
    notifyListeners();
  }

  void setSection(String value) {
    selectedSection = value;
    notifyListeners();
  }

  void setClass(String value) {
    selectedClass = value;
    notifyListeners();
  }

  void setProgram(String value) {
    selectedProgram = value;
    notifyListeners();
  }

  void setExp(String value) {
    selectedExp = value;
    notifyListeners();
  }

  // ================= FILE SETTERS =================
  void setImage(File? file) {
    selectedImage = file;
    notifyListeners();
  }

  void setCV(File? file) {
    selectedCV = file;
    notifyListeners();
  }

  // ================= SKILLS =================
  void addSkill(String skill) {
    if (!selectedSkills.contains(skill)) {
      selectedSkills.add(skill);
      notifyListeners();
    }
  }

  void removeSkill(String skill) {
    selectedSkills.remove(skill);
    notifyListeners();
  }

  void clearSkills() {
    selectedSkills.clear();
    notifyListeners();
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (picked != null) {
      selectedImage = File(picked.path);
      notifyListeners();
    }
  }
  Future<void> pickPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      selectedCV = File(result.files.single.path!);
      notifyListeners();
    }
  }

  // ================= UPDATE USER =================
  Future<ApiResponse<dynamic>> updateUser({
    required String gender,
    required String role,
    required String about,
    required String section,
    required String className,
    required String program,
    required String semester,
    required String domain,
    required String linkedIn,
    required String github,
    required String portfolio,
    required List<String> skills,
    File? pfp,
    File? cv,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final result = await _userService.updateUser(
        gender: gender,
        role: role,
        about: about,
        section: section,
        className: className,
        program: program,
        semester: semester,
        domain: domain,
        linkedIn: linkedIn,
        github: github,
        portfolio: portfolio,
        skills: skills,
        pfp: pfp,
        cv: cv,
      );

      return result;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

// ================= GET USER =================
  Future<dynamic> getUser(int userId) async {
    try {
      isLoading = true;
      notifyListeners();

      final result = await _userService.getUser(userId);
      return result;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

// ================= GET ALL USERS =================
  Future<List<dynamic>> getAllUsers() async {
    try {
      isLoading = true;
      notifyListeners();

      final result = await _userService.getAllUsers();
      return result;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ================= CLEANUP =================
  @override
  void dispose() {
    for (var c in profile_controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void clear() {
    for (var controller in profile_controllers.values) {
      controller.clear();
    }
    for (var f in profile_focus.values) {
      f.dispose();
    }
    super.dispose();
    notifyListeners();
  }
}