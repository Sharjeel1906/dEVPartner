import 'package:flutter/cupertino.dart';
import '../model/team_services.dart';

class TeamProvider extends ChangeNotifier {
  final TeamService _teamService = TeamService();
  bool isLoading = false;

  final Map<String, TextEditingController> team_controllers = {
    "teamName": TextEditingController(),
    "projectDomain": TextEditingController(),
    "reqRole": TextEditingController(),
    "teamSize": TextEditingController(),
  };

  Future<List<dynamic>> getAllTeams() async {
    try {
      isLoading = true;
      notifyListeners();

      final result = await _teamService.getAllTeams();
      return result;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> createTeam({
    required String teamName,
    required String projectDomain,
    required String reqRole,
    required int teamSize,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final result = await _teamService.createTeam(
        teamName: teamName,
        projectDomain: projectDomain,
        reqRole: reqRole,
        teamSize: teamSize,
      );
      return result;
    } finally {
      isLoading = false;
      notifyListeners();
    }
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

      return result;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
Future<Map<String, dynamic>?> getTeamDetails(int teamId) async {
  try {
    isLoading = true;
    notifyListeners();

    final result = await _teamService.getTeamDetails(teamId);
    return result;
  } finally {
    isLoading = false;
    notifyListeners();
  }
}

@override
  void dispose() {
    for (var c in team_controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void clear() {
    for (var controller in team_controllers.values) {
      controller.clear();
    }
    notifyListeners();
  }
}
