import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/project_provider.dart';

class ProjectListScreen extends StatelessWidget {
  const ProjectListScreen({super.key});

  Future<bool> _confirmDelete(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this project?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProjectProvider>(
      builder: (context, projectProvider, child) {
        final projects = projectProvider.projects;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Projects'),
          ),
          body: projects.isEmpty 
              ? const Center(child: Text('No projects added yet'))
              : ListView.builder(
                  itemCount: projects.length,
                  itemBuilder: (context, index) {
                    final project = projects[index];
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.all(8),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Project Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    project.name,
                                    style: Theme.of(context).textTheme.titleLarge,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'ESG Score: ${project.esgScore.toStringAsFixed(2)}',
                                    style: Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  Text(
                                    'ROI: ${project.roi.toStringAsFixed(1)}%',
                                    style: Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  if (project.risks.isNotEmpty) ...[
                                    const SizedBox(height: 8),
                                    Text(
                                      'Risks:',
                                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    ...project.risks.map((risk) => Padding(
                                      padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                                      child: Text(
                                        '• $risk',
                                        style: Theme.of(context).textTheme.bodyMedium,
                                      ),
                                    )),
                                  ],
                                ],
                              ),
                            ),
                            // Delete Button
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red, size: 28),
                              onPressed: () async {
                                if (await _confirmDelete(context)) {
                                  projectProvider.deleteProject(project.id);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Project deleted')),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
