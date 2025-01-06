import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/project_provider.dart';
import '../models/project.dart';
import '../utils/esg_calculator.dart';
import '../utils/risk_analyzer.dart';

class AddProjectForm extends StatefulWidget {
  const AddProjectForm({Key? key}) : super(key: key);

  @override
  _AddProjectFormState createState() => _AddProjectFormState();
}

class _AddProjectFormState extends State<AddProjectForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _co2Controller = TextEditingController();
  final _energyController = TextEditingController();
  final _socialImpactController = TextEditingController();
  final _governanceController = TextEditingController();
  final _jobsController = TextEditingController();
  final _investmentController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _co2Controller.dispose();
    _energyController.dispose();
    _socialImpactController.dispose();
    _governanceController.dispose();
    _jobsController.dispose();
    _investmentController.dispose();
    super.dispose();
  }

  double _calculateEsgScore() {
    final environmentalMetrics = {
      'carbonEmissions': -(double.tryParse(_co2Controller.text) ?? 0),
      'renewableEnergy': double.tryParse(_energyController.text) ?? 0,
    };

    final socialMetrics = {
      'communityImpact': double.tryParse(_socialImpactController.text) ?? 0,
      'laborPractices': double.tryParse(_jobsController.text) ?? 0,
    };

    final governanceMetrics = {
      'transparency': double.tryParse(_governanceController.text) ?? 0,
    };

    return EsgCalculator.calculateEsgScore(
      environmentalMetrics: environmentalMetrics,
      socialMetrics: socialMetrics,
      governanceMetrics: governanceMetrics,
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final esgScore = _calculateEsgScore();
      
      final sustainabilityMetrics = {
        'co2Reduction': double.tryParse(_co2Controller.text) ?? 0,
        'energySavings': double.tryParse(_energyController.text) ?? 0,
        'socialImpact': double.tryParse(_socialImpactController.text) ?? 0,
        'governanceScore': double.tryParse(_governanceController.text) ?? 0,
        'jobCreation': double.tryParse(_jobsController.text) ?? 0,
      };

      final investment = double.tryParse(_investmentController.text) ?? 0;
      
      // Analyze risks and get ROI
      final analysis = RiskAnalyzer.analyzeProjectRisk(
        esgScore: esgScore,
        investment: investment,
        sustainabilityMetrics: sustainabilityMetrics,
      );

      final project = Project(
        id: DateTime.now().toString(),
        name: _nameController.text,
        budget: investment,
        esgScore: esgScore,
        sustainabilityMetrics: sustainabilityMetrics,
        roi: analysis['roi'],
        risks: analysis['risks'],
      );

      Provider.of<ProjectProvider>(context, listen: false).addProject(project);
      Navigator.of(context).pop();
    }
  }

  void _clearForm() {
    _nameController.clear();
    _co2Controller.clear();
    _energyController.clear();
    _socialImpactController.clear();
    _governanceController.clear();
    _jobsController.clear();
    _investmentController.clear();
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    String? suffix,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          suffixText: suffix,
          border: const OutlineInputBorder(),
        ),
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a value';
          }
          if (double.tryParse(value) == null) {
            return 'Please enter a valid number';
          }
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Add New Project',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Project Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
              ),
              _buildTextField(
                controller: _co2Controller,
                label: 'CO2 Reduction',
                hint: 'Enter CO2 reduction target',
                suffix: 'tons',
              ),
              _buildTextField(
                controller: _energyController,
                label: 'Energy Savings',
                hint: 'Enter energy savings target',
                suffix: 'kWh',
              ),
              _buildTextField(
                controller: _socialImpactController,
                label: 'Social Impact Score',
                hint: 'Rate from 1-10',
              ),
              _buildTextField(
                controller: _governanceController,
                label: 'Governance Score',
                hint: 'Rate from 1-10',
              ),
              _buildTextField(
                controller: _jobsController,
                label: 'Job Creation',
                hint: 'Expected new jobs',
              ),
              _buildTextField(
                controller: _investmentController,
                label: 'Investment',
                hint: 'Investment amount',
                suffix: 'M',
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: _clearForm,
                    child: const Text('Clear'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text('Add Project'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
