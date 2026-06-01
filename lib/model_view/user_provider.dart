import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import '../model/user_services.dart';

class UserProvider extends ChangeNotifier {
  final UserServices _userService = UserServices();
  String? currentImageUrl;
  String? currentCvName;
  String drawerUserName = "";
  String drawerUserDomain = "";
  bool isLoading = false;
  List<dynamic> allUsers = [];
  List<dynamic> filteredUsers = [];
  String searchQuery = "";
  int? currentUserId;
  Map<String, dynamic>? viewedUser;

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

  String selectedGender = "Select";
  String selectedRole = "Select";
  String selectedSemester = "Select";
  String selectedSection = "Select";
  String selectedClass = "Select";
  String selectedProgram = "Select";
  String selectedExp = "Select";

  String filterClass = "Select";
  String filterProgram = "Select";
  String filterSemester = "Select";

  File? selectedImage;
  File? selectedCV;

  List<String> selectedSkills = [];

  void setGender(String value) {
    selectedGender = value;
    notifyListeners();
  }

  void setRole(String value) {
    selectedRole = value;
    notifyListeners();
  }


  void setSection(String value) {
    selectedSection = value;
    notifyListeners();
  }

  void setSemester(String value) {
    selectedSemester = value;
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

  void setFilterSemester(String value) {
    filterSemester = value;
    applyFilters();
    notifyListeners();
  }

  void setFilterClass(String value) {
    filterClass = value;
    applyFilters();
    notifyListeners();
  }

  void setFilterProgram(String value) {
    filterProgram = value;
    applyFilters();
    notifyListeners();
  }

  void setExp(String value) {
    selectedExp = value;
    notifyListeners();
  }

  void setImage(File? file) {
    selectedImage = null;
    notifyListeners();

    selectedImage = file;
    notifyListeners();
  }

  void setCV(File? file) {
    selectedCV = file;
    notifyListeners();
  }

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

      if (result.success) {
        selectedImage = null;
        selectedCV = null;
        await loadCurrentUser();
        await loadAllUsers();
      }

      return result;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadAllUsers() async {
    try {
      isLoading = true;
      notifyListeners();

      final result = await _userService.getAllUsers();

      allUsers = result;
      filteredUsers = result;

      applyFilters();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void applyUserFromMap(Map<String, dynamic> user) {
    final Map<String, dynamic> profile = user["profile"] ?? {};

    currentUserId = user["id"] is int
        ? user["id"] as int
        : int.tryParse(user["id"]?.toString() ?? "");

    if (currentUserId != null) {
      SharedPreferences.getInstance().then((prefs) {
        prefs.setInt("user_id", currentUserId!);
      });
    }

    drawerUserName = user["username"]?.toString() ?? "";
    drawerUserDomain =
        profile["domain"]?.toString() ?? user["domain"]?.toString() ?? "";

    profile_controllers["name"]?.text = drawerUserName;
    profile_controllers["email"]?.text = user["email"]?.toString() ?? "";
    profile_controllers["about"]?.text = profile["about"]?.toString() ?? "";
    profile_controllers["domain"]?.text = drawerUserDomain;
    profile_controllers["linkedin"]?.text = profile["linked_in_link"]?.toString() ?? "";
    profile_controllers["github"]?.text = profile["github_link"]?.toString() ?? "";
    profile_controllers["portfolio"]?.text = profile["portfolio_link"]?.toString() ?? "";

    final g = profile["gender"]?.toString() ?? "";
    final r = profile["role"]?.toString() ?? "";
    final se = profile["semester"]?.toString() ?? "";
    final cl = profile["class_name"]?.toString() ?? "";
    final pr = profile["program"]?.toString() ?? "";
    final sc = profile["section"]?.toString() ?? "";
    final ex = profile["experience"]?.toString() ?? "";

    if (genderOptions.contains(g)) selectedGender = g;
    if (roleOptions.contains(r)) selectedRole = r;
    if (semesterOptions.contains(se)) selectedSemester = se;
    if (classOptions.contains(cl)) selectedClass = cl;
    if (programOptions.contains(pr)) selectedProgram = pr;
    if (sectionOptions.contains(sc)) selectedSection = sc;
    if (experienceOptions.contains(ex)) selectedExp = ex;

    final skills = user["skills"];
    if (skills is List) {
      selectedSkills = skills.map((s) => s["name"].toString()).toList();
    }

    const baseUrl = "https://fyp-partner-finder-app-backend-production.up.railway.app";
    final pfp = profile["pfp_path"]?.toString() ??
        user["pfp_path"]?.toString() ??
        "";
    final cv = profile["cv_path"]?.toString() ?? "";

    currentImageUrl = pfp.isNotEmpty ? "$baseUrl$pfp" : null;
    currentCvName = cv.isNotEmpty ? cv.split("/").last : null;
  }

  Future<void> loadCachedUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString("user");
    if (userJson == null) return;
    applyUserFromMap(jsonDecode(userJson) as Map<String, dynamic>);
    notifyListeners();
  }

  Future<void> loadCurrentUser({bool silent = false}) async {
    try {
      if (!silent) {
        isLoading = true;
        notifyListeners();
      }

      final result = await _userService.getCurrentUserDetail();
      if (result != null) {
        applyUserFromMap(result as Map<String, dynamic>);
      }
    } finally {
      if (!silent) {
        isLoading = false;
      }
      notifyListeners();
    }
  }

  void setViewedUser(Map<String, dynamic> user) {
    viewedUser = user;
    notifyListeners();
  }

  Future<void> refreshBrowseData() async {
    await loadCurrentUser();
    await loadAllUsers();
  }

  void resetForm() {
    for (var controller in profile_controllers.values) {
      controller.clear();
    }
    selectedGender   = "Select";
    selectedRole     = "Select";
    selectedSemester = "Select";
    selectedSection  = "Select";
    selectedClass    = "Select";
    selectedProgram  = "Select";
    selectedExp      = "Select";
    filterClass      = "Select";
    filterProgram    = "Select";
    filterSemester   = "Select";
    allUsers         = [];
    filteredUsers    = [];
    searchQuery      = "";
    currentImageUrl  = null;
    currentCvName    = null;
    drawerUserName   = "";
    drawerUserDomain = "";
    currentUserId    = null;
    viewedUser       = null;
    selectedSkills   = [];
    selectedImage    = null;
    selectedCV       = null;
    notifyListeners();
  }

  void setSearchQuery(String value) {
    searchQuery = value;
    applyFilters();
    notifyListeners();
  }

  void applyFilters() {
    filteredUsers = allUsers.where((user) {
      final profile = user["profile"] ?? {};

      final username =
      (user["username"] ?? "")
          .toString()
          .toLowerCase();

      final domain =
      (profile["domain"] ?? "")
          .toString()
          .toLowerCase();

      final semester =
      (profile["semester"] ?? "")
          .toString();

      final className =
      (profile["class_name"] ?? "")
          .toString();

      final program =
      (profile["program"] ?? "")
          .toString();

      final matchesSearch =
          username.contains(searchQuery.toLowerCase()) ||
              domain.contains(searchQuery.toLowerCase());

      final matchesSemester =
          filterSemester == "Select" ||
              semester == filterSemester;

      final matchesClass =
          filterClass == "Select" ||
              className == filterClass;

      final matchesProgram =
          filterProgram == "Select" ||
              program == filterProgram;

      return matchesSearch &&
          matchesSemester &&
          matchesClass &&
          matchesProgram;
    }).toList();
  }

  @override
  void dispose() {
    for (var c in profile_controllers.values) {
      c.dispose();
    }
    for (var f in profile_focus.values) {
      f.dispose();
    }
    super.dispose();
  }
}