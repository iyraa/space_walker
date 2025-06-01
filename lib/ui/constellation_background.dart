import 'dart:math';
import 'package:flutter/material.dart';

class AnimatedConstellationBackground extends StatefulWidget {
  final Widget? child;
  const AnimatedConstellationBackground({super.key, this.child});

  @override
  State<AnimatedConstellationBackground> createState() =>
      _AnimatedConstellationBackgroundState();
}

class _AnimatedConstellationBackgroundState
    extends State<AnimatedConstellationBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final int starCount = 60;
  final List<Offset> _stars = [];
  final List<Offset> _velocities = [];
  final Random _rand = Random();

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 60))
          ..addListener(() {
            _moveStars();
          })
          ..repeat();

    // Initialize stars and velocities
    for (int i = 0; i < starCount; i++) {
      _stars.add(Offset(_rand.nextDouble(), _rand.nextDouble()));
      double angle = _rand.nextDouble() * 2 * pi;
      double speed = 0.0005 + _rand.nextDouble() * 0.001;
      _velocities.add(Offset(cos(angle) * speed, sin(angle) * speed));
    }
  }

  void _moveStars() {
    setState(() {
      for (int i = 0; i < starCount; i++) {
        Offset pos = _stars[i] + _velocities[i];
        // Wrap around screen
        double x = pos.dx;
        double y = pos.dy;
        if (x < 0) x += 1;
        if (x > 1) x -= 1;
        if (y < 0) y += 1;
        if (y > 1) y -= 1;
        _stars[i] = Offset(x, y);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color:
          Theme.of(context)
              .colorScheme
              .secondary, // <-- Change this to your desired background color
      child: CustomPaint(
        painter: _ConstellationPainter(_stars),
        size: Size.infinite,
      ),
    );
  }
}

class _ConstellationPainter extends CustomPainter {
  final List<Offset> stars;
  _ConstellationPainter(this.stars);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint starPaint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;

    final Paint linePaint =
        Paint()
          ..color = Colors.white.withOpacity(0.15)
          ..strokeWidth = 1;

    // Draw stars
    for (final star in stars) {
      final Offset pos = Offset(star.dx * size.width, star.dy * size.height);
      canvas.drawCircle(pos, 2, starPaint);
    }

    // Draw lines between close stars (constellations)
    for (int i = 0; i < stars.length; i++) {
      for (int j = i + 1; j < stars.length; j++) {
        final Offset p1 = Offset(
          stars[i].dx * size.width,
          stars[i].dy * size.height,
        );
        final Offset p2 = Offset(
          stars[j].dx * size.width,
          stars[j].dy * size.height,
        );
        final double dist = (p1 - p2).distance;
        if (dist < 80) {
          canvas.drawLine(p1, p2, linePaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ConstellationPainter oldDelegate) => true;
}
