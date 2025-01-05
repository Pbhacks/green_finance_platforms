import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/project_provider.dart';
import '../models/project.dart'; // Add this import

class OptimizationPanel extends StatefulWidget {
  const OptimizationPanel({super.key});

  @override
  OptimizationPanelState createState() => OptimizationPanelState();
}

class OptimizationPanelState extends State<OptimizationPanel> {
  double _maxBudget = 100.0;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Portfolio Optimization',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Maximum Budget: '),
                Expanded(
                  child: Slider(
                    value: _maxBudget,
                    min: 0,
                    max: 1000,
                    divisions: 100,
                    label: '\$${_maxBudget.round()}M',
                    onChanged: (value) {
                      setState(() {
                        _maxBudget = value;
                      });
                    },
                  ),
                ),
                Text('\$${_maxBudget.round()}M'),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final projectProvider =
                    Provider.of<ProjectProvider>(context, listen: false);
                final optimizedPortfolio =
                    projectProvider.getOptimizedPortfolio(_maxBudget);
                _showOptimizationResults(context, optimizedPortfolio);
              },
              child: const Text('Optimize Portfolio'),
            ),
          ],
        ),
      ),
    );
  }

  void _showOptimizationResults(
      BuildContext context, List<Project> optimizedPortfolio) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Optimization Results'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Recommended Projects: ${optimizedPortfolio.length}'),
              const SizedBox(height: 8),
              ...optimizedPortfolio.map((project) => ListTile(
                    title: Text(project.name),
                    subtitle: Text('ESG Score: ${project.esgScore}'),
                    trailing: Text('\$${project.budget}M'),
                  )),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
