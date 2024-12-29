import 'package:flutter/material.dart';
import 'dart:math' as math;

class PieChartPainter extends CustomPainter {
  PieChartPainter({
    required this.data,
    required this.colors,
  });

  final List<double> data;
  final List<Color> colors;

  @override
  void paint(Canvas canvas, Size size) {
    final double minDimension = math.min(size.width, size.height);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = minDimension * 0.18
      ..strokeCap = StrokeCap.round;

    final total = data.fold<double>(0, (sum, value) => sum + value);
    double startAngle = 0; // Start from the top

    for (int i = 0; i < data.length; i++) {
      final sweepAngle = (data[i] / total) * 2 * math.pi;

      paint.color = colors[i];
      canvas.drawArc(
        Rect.fromCircle(
          center: Offset(minDimension / 2, minDimension / 2),
          radius: minDimension / 2.5,
        ),
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      startAngle += sweepAngle; // Update start angle for the next section
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}







