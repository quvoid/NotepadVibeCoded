import 'dart:math';
import 'package:flutter/material.dart';

class AnimatedBorderContainer extends StatefulWidget {
  final Widget child;
  final List<Color> gradientColors;
  final double borderWidth;
  final double borderRadius;

  const AnimatedBorderContainer({
    super.key,
    required this.child,
    required this.gradientColors,
    this.borderWidth = 2.0,
    this.borderRadius = 16.0,
  });

  @override
  State<AnimatedBorderContainer> createState() => _AnimatedBorderContainerState();
}

class _AnimatedBorderContainerState extends State<AnimatedBorderContainer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          painter: _GradientBorderPainter(
            animationValue: _controller.value,
            gradientColors: widget.gradientColors,
            borderWidth: widget.borderWidth,
            borderRadius: widget.borderRadius,
          ),
          child: Padding(
            padding: EdgeInsets.all(widget.borderWidth),
            child: widget.child,
          ),
        );
      },
    );
  }
}

class _GradientBorderPainter extends CustomPainter {
  final double animationValue;
  final List<Color> gradientColors;
  final double borderWidth;
  final double borderRadius;

  _GradientBorderPainter({
    required this.animationValue,
    required this.gradientColors,
    required this.borderWidth,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));

    // Create a rotating SweepGradient
    // We rotate it by shifting the transform based on animationValue
    final gradient = SweepGradient(
      colors: [...gradientColors, gradientColors.first],
      stops: _generateStops(gradientColors.length + 1),
      transform: GradientRotation(animationValue * 2 * pi),
    );

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    canvas.drawRRect(rrect, paint);
  }
  
  List<double> _generateStops(int count) {
      if (count <= 1) return [0.0];
      return List.generate(count, (index) => index / (count - 1));
  }

  @override
  bool shouldRepaint(covariant _GradientBorderPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
