
import 'package:flutter/material.dart';
import 'package:insonmode_fluter/core/theme/app_theme.dart';

class NeonButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final Color? color;
  final double width;
  final double height;

  const NeonButton({
    super.key,
    required this.text,
    required this.onTap,
    this.color,
    this.width = double.infinity,
    this.height = 56,
  });

  @override
  State<NeonButton> createState() => _NeonButtonState();
}

class _NeonButtonState extends State<NeonButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onTap();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final glowColor = widget.color ?? AppTheme.neonCyan;

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: widget.width,
            height: widget.height,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: glowColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: glowColor, width: 2),
              boxShadow: [
                BoxShadow(
                  color: glowColor.withOpacity(0.4),
                  blurRadius: 15,
                  spreadRadius: 1,
                  offset: const Offset(0, 0),
                ),
                BoxShadow(
                  color: glowColor.withOpacity(0.2),
                  blurRadius: 30,
                  spreadRadius: 5,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: Text(
              widget.text.toUpperCase(),
              style: AppTheme.darkTheme.textTheme.displayMedium?.copyWith(
                fontSize: 18,
                color: glowColor,
                shadows: [
                  Shadow(
                    color: glowColor,
                    blurRadius: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
