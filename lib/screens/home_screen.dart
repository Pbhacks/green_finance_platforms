import 'package:flutter/material.dart';
import 'package:green_finance_platform/screens/add_project_form.dart';
import 'package:green_finance_platform/widgets/dashboard_summary.dart';
import 'package:green_finance_platform/widgets/optimization_panel.dart';
import 'package:green_finance_platform/widgets/project_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, dynamic>> _projects = [];

  void _addProject(String name, double budget) {
    setState(() {
      _projects.add({'name': name, 'budget': budget});
    });
  }

  void _openAddProjectForm() {
    showDialog(
      context: context,
      builder: (context) {
        return AddProjectForm(onAddProject: _addProject);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              DashboardSummary(),
              SizedBox(height: 20),
              OptimizationPanel(),
              SizedBox(height: 20),
              ProjectList(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddProjectForm,
        child: const Icon(Icons.add),
      ),
    );
  }
}
