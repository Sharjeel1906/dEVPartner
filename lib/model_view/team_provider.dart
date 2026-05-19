import 'dart:convert';

import 'package:flutter/material.dart';
import '../model/team_services.dart';

class TeamProvider extends ChangeNotifier {
  final TeamService _teamService = TeamService();
  Map<String, dynamic>? myTeam;
  bool isMyTeamLoading = false;
  bool isLoading = false;
  bool isDetailsLoading = false;
  List<dynamic> allTeams = [];
  List<dynamic> filteredTeams = [];
  String teamsSearchQuery = "";
  Map<String, dynamic>? teamSummary;
  Map<String, dynamic>? teamDetails;

  static int _parseInt(dynamic value, [int fallback = 0]) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? "") ?? fallback;
  }

  static int teamIdFromMap(Map<String, dynamic> team) {
    final id = team["id"] ?? team["team_id"];
    return _parseInt(id);
  }

  static List<dynamic> parseMembers(Map<String, dynamic> team) {
    final raw = team["members"] ??
        team["team_members"] ??
        team["member_list"] ??
        team["members_list"];
    if (raw is List) return raw;
    return [];
  }

  static int teamTotalSize(Map<String, dynamic> team) {
    final size = team["available_team_size"];
    return size;
  }

  static int memberCount(Map<String, dynamic> team) {
    return parseMembers(team).length;
  }

  static int openSpots(Map<String, dynamic> team) {
    final total = teamTotalSize(team);
    return (total - memberCount(team)).clamp(0, total);
  }

  static String formatTeamDate(dynamic value) {
    if (value == null || value.toString().trim().isEmpty) {
      return "Recently";
    }
    try {
      final dt = DateTime.parse(value.toString());
      const months = [
        "Jan", "Feb", "Mar", "Apr", "May", "Jun",
        "Jul", "Aug", "Sep", "Oct", "Nov", "Dec",
      ];
      return "${months[dt.month - 1]} ${dt.day}, ${dt.year}";
    } catch (_) {
      final s = value.toString();
      return s.length > 10 ? s.substring(0, 10) : s;
    }
  }

  static Map<String, dynamic> normalizeTeam(Map<String, dynamic> team) {
    final normalized = Map<String, dynamic>.from(team);
    var members = parseMembers(team);
    if (members.isEmpty && team["leader"] is Map) {
      members = [team["leader"]];
    } else if (members.isEmpty &&
        (team["leader_username"] != null || team["username"] != null)) {
      members = [
        {
          "username": team["leader_username"] ?? team["username"],
          "mem_role": "leader",
          "user_id": team["leader_id"] ?? team["user_id"],
        },
      ];
    }
    normalized["members"] = members;

    var roles = team["req_role"] ?? team["req_roles"];
    if (roles is String && roles.trim().startsWith("[")) {
      try {
        roles = jsonDecode(roles);
      } catch (_) {}
    }
    normalized["req_role"] = roles;

    return normalized;
  }

  static List<String> parseReqRoles(dynamic reqRole) {
    if (reqRole is List) {
      return reqRole
          .map((e) => e is Map ? (e["name"] ?? e["role"] ?? e).toString() : e.toString())
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty && s != "Select")
          .toList();
    }
    if (reqRole is String && reqRole.isNotEmpty) {
      if (reqRole.trim().startsWith("[")) {
        try {
          final decoded = jsonDecode(reqRole);
          if (decoded is List) return parseReqRoles(decoded);
        } catch (_) {}
      }
      return reqRole
          .split(",")
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();
    }
    return [];
  }

  static List<String> parseTeamSkills(dynamic skills) {
    if (skills is List) {
      return skills
          .map((s) => s is Map ? (s["name"] ?? s).toString() : s.toString())
          .where((s) => s.isNotEmpty)
          .toList();
    }
    return [];
  }

  void setTeamsSearchQuery(String value) {
    teamsSearchQuery = value;
    applyTeamsFilter();
    notifyListeners();
  }

  void applyTeamsFilter() {
    if (teamsSearchQuery.trim().isEmpty) {
      filteredTeams = List.from(allTeams);
      return;
    }
    final q = teamsSearchQuery.toLowerCase();
    filteredTeams = allTeams.where((team) {
      final name = (team["team_name"] ?? "").toString().toLowerCase();
      final domain = (team["project_domain"] ?? "").toString().toLowerCase();
      final roles = parseReqRoles(team["req_role"]).join(" ").toLowerCase();
      return name.contains(q) || domain.contains(q) || roles.contains(q);
    }).toList();
  }
  final Map<String, TextEditingController> team_controllers = {
    "teamName": TextEditingController(),
    "projectDomain": TextEditingController(),
    "role": TextEditingController(),
  };

  final Map<String, FocusNode> team_focus = {
    "teamName": FocusNode(),
    "projectDomain": FocusNode(),
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
        reqRole: selectedRoles,
        teamSize: teamSize,
      );

      return result;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  bool isProfileLeader(String profileRole) {
    return profileRole.toLowerCase() == "leader";
  }

  bool isCurrentUserTeamLeader(int? currentUserId) {
    if (myTeam == null || currentUserId == null) return false;
    final members = parseMembers(myTeam!);
    for (final m in members) {
      final memId = m["user_id"] ?? m["id"] ?? m["mem_id"];
      final id = _parseInt(memId, -1);
      if (id == currentUserId) {
        return (m["mem_role"] ?? "").toString().toLowerCase() == "leader";
      }
    }
    return false;
  }

  bool canManageMembers(int? currentUserId, String profileRole) {
    return isProfileLeader(profileRole) ||
        isCurrentUserTeamLeader(currentUserId);
  }

  bool hasTeamSpace() {
    if (myTeam == null) return false;
    return memberCount(myTeam!) < teamTotalSize(myTeam!);
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
        final data = result["data"];
        if (data is Map<String, dynamic>) {
          myTeam = normalizeTeam(data);
        } else {
          myTeam = null;
        }
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

  Future<void> getAllTeams() async {
    try {
      isLoading = true;
      notifyListeners();

      final result = await _teamService.getAllTeams();

      final rawTeams = result["teams"] ?? [];
      final seen = <int>{};
      final unique = <Map<String, dynamic>>[];

      for (final item in rawTeams) {
        if (item is! Map) continue;
        final team = normalizeTeam(Map<String, dynamic>.from(item));
        final id = teamIdFromMap(team);
        if (id != 0) {
          if (seen.contains(id)) continue;
          seen.add(id);
        }
        unique.add(team);
      }

      allTeams = unique;
      teamSummary = result["summary"];
      applyTeamsFilter();

    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  Future<void> getTeamDetails(int teamId) async {
    try {
      isDetailsLoading = true;
      teamDetails = null;
      notifyListeners();
      final result = await _teamService.getTeamDetails(teamId);
      teamDetails = result != null ? normalizeTeam(result) : null;
    } finally {
      isDetailsLoading = false;
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
