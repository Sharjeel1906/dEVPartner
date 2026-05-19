import 'dart:convert';
import 'package:http/http.dart' as http;

import 'api_client.dart';

class TeamService {
  final ApiClient _client = ApiClient();

  // ================= GET ALL TEAMS =================
  Future<Map<String, dynamic>> getAllTeams() async {
    try {
      final request = http.Request(
        "GET",
        Uri.parse("${ApiClient.baseUrl}/teams/"),
      );

      final response = await _client.sendPublicRequest(request);

      if (response.statusCode == 200) {
        final body = jsonDecode(await response.stream.bytesToString());

        if (body is List) {
          return {
            "summary": <String, dynamic>{},
            "teams": body,
          };
        }

        return {
          "summary": body["summary"] ?? <String, dynamic>{},
          "teams": body["teams"] ?? body["data"] ?? [],
        };
      }

      return {
        "summary": {},
        "teams": [],
      };
    } catch (e) {
      return {
        "summary": {},
        "teams": [],
      };
    }
  }
  // ================= CREATE TEAM =================
  Future<Map<String, dynamic>> createTeam({
    required String teamName,
    required String team_description,
    required String projectDomain,
    required List<String> reqRole,
    required int teamSize,
  }) async {
    try {
      final request = http.Request(
        "POST",
        Uri.parse("${ApiClient.baseUrl}/create_team/"),
      );

      request.headers["Content-Type"] = "application/json";

      request.body = jsonEncode({
        "team_name": teamName,
        "team_description":team_description,
        "project_domain": projectDomain,
        "req_role": reqRole,
        "team_size": teamSize,
      });

      final response = await _client.sendRequest(request);
      final body = await response.stream.bytesToString();
      final data = jsonDecode(body);

      if (response.statusCode == 201) {
        return {
          "success": true,
          "message": data["message"],
          "team_id": data["team_id"],
        };
      }

      return {
        "success": false,
        "message": data["message"] ?? "Failed to create team",
      };
    } catch (e) {
      return {
        "success": false,
        "message": "Something went wrong",
      };
    }
  }

  // ================= ADD TEAM MEMBER =================
  Future<Map<String, dynamic>> addTeamMember({
    required int teamId,
    required int memId,
    String memRole = "member",
  }) async {
    try {
      final request = http.Request(
        "POST",
        Uri.parse("${ApiClient.baseUrl}/add_team_member/"),
      );

      request.headers["Content-Type"] = "application/json";

      request.body = jsonEncode({
        "team_id": teamId,
        "mem_id": memId,
        "mem_role": memRole,
      });

      final response = await _client.sendRequest(request);
      final body = await response.stream.bytesToString();
      final data = jsonDecode(body);

      if (response.statusCode == 201) {
        return {
          "success": true,
          "message": data["message"],
          "member_id": data["member_id"],
        };
      }
      return {
        "success": false,
        "message": data["message"] ?? data["error"] ?? "Failed",
      };
    } catch (e) {
      return {
        "success": false,
        "message": "Something went wrong",
      };
    }
  }

  // ================= GET TEAM DETAILS =================
  Future<Map<String, dynamic>?> getTeamDetails(int teamId) async {
    try {
      final request = http.Request(
        "GET",
        Uri.parse("${ApiClient.baseUrl}/team/$teamId/"),
      );

      final response = await _client.sendRequest(request);

      if (response.statusCode == 200) {
        final body = jsonDecode(await response.stream.bytesToString());
        if (body is Map<String, dynamic>) {
          if (body["data"] is Map<String, dynamic>) {
            return body["data"] as Map<String, dynamic>;
          }
          if (body["team"] is Map<String, dynamic>) {
            return body["team"] as Map<String, dynamic>;
          }
          return body;
        }
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> getMyTeam() async {
    try {
      final request = http.Request(
        "GET",
        Uri.parse("${ApiClient.baseUrl}/my_team/"),
      );

      final response = await _client.sendRequest(request);
      final body = await response.stream.bytesToString();

      final data = jsonDecode(body);

      if (response.statusCode == 200) {
        return {
          "success": true,
          "data": data,
        };
      }

      return {
        "success": false,
        "message": data["message"] ?? "No team found",
      };
    } catch (e) {
      return {
        "success": false,
        "message": "Something went wrong",
      };
    }
  }
}
