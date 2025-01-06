import 'package:flutter/material.dart';
import 'package:green_finance_platform/screens/add_project_form.dart';
import 'package:green_finance_platform/widgets/dashboard_summary.dart';
import 'package:green_finance_platform/widgets/optimization_panel.dart';
import 'package:green_finance_platform/widgets/project_list.dart';
import 'dart:math';
import 'package:flutter_animate/flutter_animate.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _openAddProjectForm() {
    showDialog(
      context: context,
      builder: (context) {
        return const AddProjectForm();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Home Screen'),
                    const SizedBox(width: 8),
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _controller.value * 2 * pi,
                          child: const Icon(Icons.eco),
                        );
                      },
                    ),
                  ],
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.teal.shade300,
                        Colors.teal.shade200,
                        Colors.greenAccent.shade200,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ];
        },
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: AnimateList(
                interval: Duration(milliseconds: 100),
                effects: [FadeEffect(duration: Duration(milliseconds: 500))],
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
        ),
      ),
      floatingActionButton: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, 10 * sin(_controller.value * 2 * pi)),
            child: FloatingActionButton(
              onPressed: _openAddProjectForm,
              child: const Icon(Icons.add),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          );
        },
      ),
    );
  }
}
