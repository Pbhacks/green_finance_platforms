import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/project_provider.dart';
import '../utils/responsive_utils.dart';
import '../theme/typography.dart';
import 'animated_text.dart';

class DashboardSummary extends StatelessWidget {
  const DashboardSummary({super.key});

  @override
  Widget build(BuildContext context) {
    final projectProvider = Provider.of<ProjectProvider>(context);
    final isWeb = ResponsiveUtils.isWeb(context);
    final crossAxisCount = isWeb ? 3 : 2;
    
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: crossAxisCount,
      childAspectRatio: isWeb ? 1.8 : 1.5,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildAnimatedCard(
          'Total Budget',
          '\$${projectProvider.totalBudget.toStringAsFixed(2)}M',
          Icons.attach_money,
          Colors.teal.shade300,
        ),
        _buildAnimatedCard(
          'Avg ESG Score',
          projectProvider.averageEsgScore.toStringAsFixed(1),
          Icons.eco,
          Colors.green.shade300,
        ),
        _buildAnimatedCard(
          'Projects',
          projectProvider.projects.length.toString(),
          Icons.business,
          Colors.blue.shade300,
        ),
      ],
    );
  }

  Widget _buildAnimatedCard(String title, String value, IconData icon, Color color) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWeb = ResponsiveUtils.isWeb(context);
        final iconSize = isWeb ? 32.0 : 24.0;
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;
        
        return TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: 1),
          duration: const Duration(milliseconds: 500),
          builder: (context, double value, child) {
            return Transform.scale(
              scale: value,
              child: Card(
                elevation: isDarkMode ? 8 : 2,
                shadowColor: isDarkMode ? color.withOpacity(0.5) : Colors.black12,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: LinearGradient(
                      colors: [
                        color.withOpacity(isDarkMode ? 0.4 : 0.7),
                        color.withOpacity(isDarkMode ? 0.2 : 0.4),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: isDarkMode ? [
                      BoxShadow(
                        color: color.withOpacity(0.2),
                        blurRadius: 15,
                        spreadRadius: -8,
                      ),
                    ] : [],
                  ),
                  child: child,
                ),
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.all(isWeb ? 16 : 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, 
                  size: iconSize,
                  color: isDarkMode ? Colors.white70 : Colors.black87,
                ),
                SizedBox(height: isWeb ? 8 : 4),
                AnimatedText(
                  title,
                  style: AppTypography.labelLarge.copyWith(
                    color: isDarkMode ? Colors.white70 : Colors.black87,
                    shadows: isDarkMode ? [
                      Shadow(
                        color: color.withOpacity(0.5),
                        blurRadius: 8,
                      ),
                    ] : null,
                  ),
                  duration: const Duration(milliseconds: 300),
                ),
                AnimatedText(
                  value,
                  style: AppTypography.displayMedium.copyWith(
                    color: isDarkMode ? Colors.white : Colors.black87,
                    shadows: isDarkMode ? [
                      Shadow(
                        color: color.withOpacity(0.5),
                        blurRadius: 12,
                      ),
                    ] : null,
                  ),
                  duration: const Duration(milliseconds: 400),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}