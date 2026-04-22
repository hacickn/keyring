import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class TimerRing extends StatelessWidget {
  final double t; // 0..1 remaining fraction
  final double size;
  final double strokeWidth;
  final Color? color;

  const TimerRing({
    super.key,
    required this.t,
    this.size = 22,
    this.strokeWidth = 3,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final expiring = t < 0.2;
    final trackColor = expiring ? AppColors.orangeSoft : AppColors.blueSoft;
    final barColor = color ?? (expiring ? AppColors.orange : AppColors.blue);

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _RingPainter(
          t: t,
          trackColor: trackColor,
          barColor: barColor,
          strokeWidth: strokeWidth,
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double t;
  final Color trackColor;
  final Color barColor;
  final double strokeWidth;

  _RingPainter({
    required this.t,
    required this.trackColor,
    required this.barColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (math.min(size.width, size.height) - strokeWidth) / 2;

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = trackColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * t,
      false,
      Paint()
        ..color = barColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.t != t || old.barColor != barColor || old.trackColor != trackColor;
}
