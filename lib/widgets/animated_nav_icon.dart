import 'package:flutter/material.dart';

class AnimatedNavIcon extends StatefulWidget {
  final IconData icon;
  final bool isSelected;
  final Color? selectedColor;
  final Color? unselectedColor;

  const AnimatedNavIcon({
    super.key,
    required this.icon,
    this.isSelected = false,
    this.selectedColor,
    this.unselectedColor,
  });

  @override
  State<AnimatedNavIcon> createState() => _AnimatedNavIconState();
}

class _AnimatedNavIconState extends State<AnimatedNavIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    if (widget.isSelected) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(AnimatedNavIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected != oldWidget.isSelected) {
      if (widget.isSelected) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedColor = widget.selectedColor ?? theme.colorScheme.primary;
    final unselectedColor =
        widget.unselectedColor ?? theme.colorScheme.onSurface.withOpacity(0.6);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Icon(
            widget.icon,
            color: Color.lerp(
              unselectedColor,
              selectedColor,
              _opacityAnimation.value,
            ),
          ),
        );
      },
    );
  }
}