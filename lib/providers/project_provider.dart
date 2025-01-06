import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/project.dart';

class ProjectProvider with ChangeNotifier {
  List<Project> _projects = [];

  ProjectProvider() {
    _loadProjects();
  }

  List<Project> get projects => _projects;

  double get totalBudget => _projects.fold(0, (sum, project) => sum + project.budget);

  double get averageEsgScore => _projects.isEmpty
      ? 0
      : _projects.fold(0.0, (sum, project) => sum + project.esgScore) / _projects.length;

  void addProject(Project project) {
    _projects.add(project);
    _saveProjects();
    notifyListeners();
  }

  void removeProject(String id) {
    _projects.removeWhere((project) => project.id == id);
    _saveProjects();
    notifyListeners();
  }

  void updateProject(Project updatedProject) {
    final index = _projects.indexWhere((project) => project.id == updatedProject.id);
    if (index != -1) {
      _projects[index] = updatedProject;
      _saveProjects();
      notifyListeners();
    }
  }

  void deleteProject(String id) {
    _projects.removeWhere((project) => project.id == id);
    notifyListeners();
  }

  List<Project> getOptimizedPortfolio(double maxBudget) {
    // Simple greedy algorithm for portfolio optimization
    // In a real application, this would use more sophisticated methods
    List<Project> sortedProjects = List.from(_projects)
      ..sort((a, b) => (b.esgScore / b.budget).compareTo(a.esgScore / a.budget));

    List<Project> optimizedPortfolio = [];
    double currentBudget = 0;

    for (var project in sortedProjects) {
      if (currentBudget + project.budget <= maxBudget) {
        optimizedPortfolio.add(project);
        currentBudget += project.budget;
      }
    }

    return optimizedPortfolio;
  }

  Future<void> _saveProjects() async {
    final prefs = await SharedPreferences.getInstance();
    final projectsJson = jsonEncode(_projects.map((project) => project.toJson()).toList());
    await prefs.setString('projects', projectsJson);
  }

  Future<void> _loadProjects() async {
    final prefs = await SharedPreferences.getInstance();
    final projectsJson = prefs.getString('projects');
    if (projectsJson != null) {
      final List<dynamic> projectsList = jsonDecode(projectsJson);
      _projects = projectsList.map((json) => Project.fromJson(json)).toList();
      notifyListeners();
    }
  }

  Future<void> clearAllProjects() async {
    _projects.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('projects');
    notifyListeners();
  }
}