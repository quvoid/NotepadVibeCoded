import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:dart_vader_notes/src/core/utils/constants.dart';

class StarfieldWidget extends StatefulWidget {
  const StarfieldWidget({super.key});

  @override
  State<StarfieldWidget> createState() => _StarfieldWidgetState();
}

class _StarfieldWidgetState extends State<StarfieldWidget> with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  final List<Star> _stars = [];
  final Random _random = Random();
  double _time = 0;

  @override
  void initState() {
    super.initState();
    _initStars();
    _ticker = createTicker((elapsed) {
      setState(() {
        _time = elapsed.inMilliseconds / 1000.0;
        _updateStars();
      });
    })..start();
  }

  void _initStars() {
    for (int i = 0; i < 150; i++) {
      _stars.add(Star(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        z: _random.nextDouble() * 2 + 0.1, // Depth
        size: _random.nextDouble() * 2 + 0.5,
      ));
    }
  }

  void _updateStars() {
    // Move stars to simulate forward motion (warp speed effect)
    for (var star in _stars) {
      // Move star closer (decrease z) or move radially
      // Let's do a simple vertical scroll or radial expansion
      // Simple parallax:
      star.y += 0.001 * star.z; 
      if (star.y > 1.0) {
        star.y = 0;
        star.x = _random.nextDouble();
      }
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black, // Deep space black
      child: CustomPaint(
        painter: StarPainter(_stars, _time),
        child: Container(),
      ),
    );
  }
}

class Star {
  double x;
  double y;
  double z;
  double size;

  Star({required this.x, required this.y, required this.z, required this.size});
}

class StarPainter extends CustomPainter {
  final List<Star> stars;
  final double time;

  StarPainter(this.stars, this.time);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;

    for (var star in stars) {
      final x = star.x * size.width;
      final y = star.y * size.height;
      
      // Twinkle effect
      final opacity = (sin(time * 5 + star.x * 10) + 1) / 2 * 0.5 + 0.3;
      
      paint.color = Colors.white.withValues(alpha: opacity);
      
      // Draw star
      canvas.drawCircle(Offset(x, y), star.size, paint);
      
      // Occasional Sith Red or Jedi Blue stars
      if (star.z > 1.8) {
         final glowPaint = Paint()
           ..color = (star.x > 0.5 ? AppConstants.sithRed : AppConstants.lightsaberGlow).withValues(alpha: 0.3)
           ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
         canvas.drawCircle(Offset(x, y), star.size * 2, glowPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant StarPainter oldDelegate) => true;
}
