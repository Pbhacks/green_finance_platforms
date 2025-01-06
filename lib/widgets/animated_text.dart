import 'package:flutter/material.dart';

class AnimatedText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final Duration duration;
  final Curve curve;

  const AnimatedText(
    this.text, {
    this.style,
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.easeInOut,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: duration,
      curve: curve,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 20),
            child: Text(
              text,
              style: style,
            ),
          ),
        );
      },
    );
  }
}
