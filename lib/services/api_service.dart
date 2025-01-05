import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/project.dart';

class ApiService {
  final String baseUrl = dotenv.env['API_BASE_URL'] ?? 'http://localhost:3000';

  Future<List<Project>> fetchProjects() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/projects'));
      
      if (response.statusCode == 200) {
        final List<dynamic> projectsJson = json.decode(response.body);
        return projectsJson.map((json) => Project.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load projects');
      }
    } catch (e) {
      throw Exception('Error connecting to the server: $e');
    }
  }

  Future<Project> createProject(Project project) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/projects'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(project.toJson()),
      );
      
      if (response.statusCode == 201) {
        return Project.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to create project');
      }
    } catch (e) {
      throw Exception('Error connecting to the server: $e');
    }
  }

  Future<void> updateProject(Project project) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/projects/${project.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(project.toJson()),
      );
      
      if (response.statusCode != 200) {
        throw Exception('Failed to update project');
      }
    } catch (e) {
      throw Exception('Error connecting to the server: $e');
    }
  }

  Future<void> deleteProject(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/projects/$id'),
      );
      
      if (response.statusCode != 200) {
        throw Exception('Failed to delete project');
      }
    } catch (e) {
      throw Exception('Error connecting to the server: $e');
    }
  }
}