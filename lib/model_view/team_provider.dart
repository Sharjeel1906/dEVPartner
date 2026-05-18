import 'package:flutter/material.dart';
import '../model/team_services.dart';

class TeamProvider extends ChangeNotifier {
  final TeamService _teamService = TeamService();
  Map<String, dynamic>? myTeam;
  bool isMyTeamLoading = false;
  bool isLoading = false;

  final Map<String, TextEditingController> team_controllers = {
    "teamName": TextEditingController(),
    "projectDomain": TextEditingController(),
    "skill": TextEditingController(),
    "role": TextEditingController(),
  };

  final Map<String, FocusNode> team_focus = {
    "teamName": FocusNode(),
    "projectDomain": FocusNode(),
    "skill": FocusNode(),
    "role": FocusNode(),
  };

  final List<String> domainOptions = [
    "Select project domain...",
    "AI/ML",
    "Web Development",
    "Mobile App",
    "Blockchain",
  ];

  String selectedDomain = "Select project domain...";
  List<String> selectedSkills = [];
  List<String> selectedRoles = [];

  int teamSize = 6;

  void setDomain(String value) {
    selectedDomain = value;
    notifyListeners();
  }

  void addSkill(String skill) {
    if (skill.trim().isEmpty) return;
    if (!selectedSkills.contains(skill.trim())) {
      selectedSkills.add(skill.trim());
      notifyListeners();
    }
  }

  void removeSkill(String skill) {
    selectedSkills.remove(skill);
    notifyListeners();
  }

  void addRole(String role) {
    if (role.trim().isEmpty) return;
    if (!selectedRoles.contains(role.trim())) {
      selectedRoles.add(role.trim());
      notifyListeners();
    }
  }

  void removeRole(String role) {
    selectedRoles.remove(role);
    notifyListeners();
  }

  void increaseTeamSize() {
    if (teamSize < 6) {
      teamSize++;
      notifyListeners();
    }
  }

  void decreaseTeamSize() {
    if (teamSize > 1) {
      teamSize--;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> createTeam() async {
    try {
      isLoading = true;
      notifyListeners();

      final result = await _teamService.createTeam(
        teamName: team_controllers["teamName"]!.text.trim(),
        projectDomain: selectedDomain,
        reqRole: selectedRoles.join(","),
        teamSize: teamSize,
      );

      return result;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  // ================= GET MY TEAM =================
  bool isCurrentUserTeamLeader(int? currentUserId) {
    if (myTeam == null || currentUserId == null) return false;
    final members = myTeam!["members"] ?? [];
    for (final m in members) {
      final memId = m["user_id"] ?? m["id"] ?? m["mem_id"];
      final id = memId is int ? memId : int.tryParse(memId?.toString() ?? "");
      if (id == currentUserId) {
        return (m["mem_role"] ?? "").toString().toLowerCase() == "leader";
      }
    }
    return false;
  }

  bool hasTeamSpace() {
    if (myTeam == null) return false;
    final members = myTeam!["members"] ?? [];
    final teamSize = myTeam!["team_size"] is int
        ? myTeam!["team_size"] as int
        : int.tryParse(myTeam!["team_size"]?.toString() ?? "") ?? 6;
    return members.length < teamSize;
  }

  Future<Map<String, dynamic>> addTeamMember({
    required int teamId,
    required int memId,
    String memRole = "member",
  }) async {
    try {
      isLoading = true;
      notifyListeners();
      final result = await _teamService.addTeamMember(
        teamId: teamId,
        memId: memId,
        memRole: memRole,
      );
      if (result["success"] == true) {
        await getMyTeam();
      }
      return result;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getMyTeam() async {
    try {
      isMyTeamLoading = true;
      notifyListeners();

      final result = await _teamService.getMyTeam();

      if (result != null && result["success"] == true) {
        myTeam = result["data"];
      } else {
        myTeam = null;
      }
    } catch (e) {
      myTeam = null;
    } finally {
      isMyTeamLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    for (var c in team_controllers.values) {
      c.clear();
    }
    selectedDomain = "Select project domain...";
    selectedSkills.clear();
    selectedRoles.clear();
    teamSize = 6;
    notifyListeners();
  }

  @override
  void dispose() {
    for (var c in team_controllers.values) {
      c.dispose();
    }
    for (var f in team_focus.values) {
      f.dispose();
    }
    super.dispose();
  }
}