import 'package:flutter/material.dart';

class CircularPageRoute extends PageRouteBuilder {
  final Widget page;

  CircularPageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return ScaleTransition(
              scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCirc,
                ),
              ),
              child: child,
            );
          },
        );
}
