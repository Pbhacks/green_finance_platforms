import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../providers/project_provider.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, double> budgetData = {
      "Renewables": 2.5,
      "Infrastructure": 4.0,
      "Research": 1.5,
    };

    return Consumer<ProjectProvider>(
      builder: (context, projectProvider, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Portfolio Analytics',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _buildEsgScoreChart(projectProvider),
              const SizedBox(height: 20),
              Text('Budget Allocation', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              SizedBox(
                height: 300,
                child: _buildBudgetPieChart(budgetData),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEsgScoreChart(ProjectProvider provider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ESG Score Distribution',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 10,
                  barGroups: provider.projects
                      .map((project) => BarChartGroupData(
                            x: provider.projects.indexOf(project),
                            barRods: [
                              BarChartRodData(
                                toY: project.esgScore,
                                color: Colors.green,
                              ),
                            ],
                          ))
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetPieChart(Map<String, double> budgetData) {
    final sections = budgetData.entries.map((entry) {
      return PieChartSectionData(
        value: entry.value,
        title: '${entry.key}\n\$${entry.value.toStringAsFixed(2)}M',
        radius: 50,
        showTitle: true,
      );
    }).toList();

    return PieChart(
      PieChartData(
        sections: sections,
        centerSpaceRadius: 40,
        sectionsSpace: 2,
        borderData: FlBorderData(show: false),
        pieTouchData: PieTouchData(
          touchCallback: (event, response) { /* ...handle tap... */ },
        ),
      ),
      swapAnimationCurve: Curves.easeInOut,
      swapAnimationDuration: const Duration(milliseconds: 600),
    );
  }
}
