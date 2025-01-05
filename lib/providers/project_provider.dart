import 'package:flutter/foundation.dart';
import '../models/project.dart';

class ProjectProvider with ChangeNotifier {
  List<Project> _projects = [];
  
  List<Project> get projects => _projects;

  double get totalBudget => _projects.fold(0, (sum, project) => sum + project.budget);
  
  double get averageEsgScore => _projects.isEmpty 
    ? 0 
    : _projects.fold(0.0, (sum, project) => sum + project.esgScore) / _projects.length;

  void addProject(Project project) {
    _projects.add(project);
    notifyListeners();
  }

  void removeProject(String id) {
    _projects.removeWhere((project) => project.id == id);
    notifyListeners();
  }

  void updateProject(Project updatedProject) {
    final index = _projects.indexWhere((project) => project.id == updatedProject.id);
    if (index != -1) {
      _projects[index] = updatedProject;
      notifyListeners();
    }
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
}