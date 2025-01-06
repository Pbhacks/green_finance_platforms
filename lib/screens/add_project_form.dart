import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/project_provider.dart';
import '../models/project.dart';

class AddProjectForm extends StatefulWidget {
  const AddProjectForm({Key? key}) : super(key: key);

  @override
  _AddProjectFormState createState() => _AddProjectFormState();
}

class _AddProjectFormState extends State<AddProjectForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  double _budgetValue = 0.0; // For slider state

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final project = Project(
        id: DateTime.now().toString(),
        name: name,
        budget: _budgetValue, // Use slider value
        esgScore: 0.0, // Default value, update as needed
        roi: 0.0, // Default value, update as needed
        sustainabilityMetrics: {}, // Default value, update as needed
        risks: [], // Default value, update as needed
      );

      Provider.of<ProjectProvider>(context, listen: false).addProject(project);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Project'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Project Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a project name';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            Text('Budget: \$${_budgetValue.toStringAsFixed(2)}'),
            Slider(
              value: _budgetValue,
              min: 0,
              max: 10, // up to 10M, adjust as needed
              divisions: 100,
              label: '\$${_budgetValue.toStringAsFixed(2)}M',
              onChanged: (value) {
                setState(() {
                  _budgetValue = value;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submitForm,
          child: const Text('Add'),
        ),
      ],
    );
  }
}
