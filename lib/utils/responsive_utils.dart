import 'package:flutter/material.dart';

class ResponsiveUtils {
  static double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
  static double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;

  static bool isWeb(BuildContext context) => screenWidth(context) > 600;

  static double getCardWidth(BuildContext context) {
    double width = screenWidth(context);
    if (width > 1200) return width * 0.2;
    if (width > 600) return width * 0.3;
    return width * 0.45;
  }

  static EdgeInsets getResponsivePadding(BuildContext context) {
    if (isWeb(context)) {
      return EdgeInsets.symmetric(
        horizontal: screenWidth(context) * 0.1,
        vertical: 24,
      );
    }
    return const EdgeInsets.all(16);
  }
}
