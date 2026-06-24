// CustomPainter for the drawing canvas.
// Renders: guide character, stroke-order arrows, user strokes, current stroke.

import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../data/strokes.dart';

class DrawingPainter extends CustomPainter {
  final String character;
  final bool showGuide;
  final bool showArrows;
  final List<StrokeGuide>? guides;
  final List<DrawnStroke> strokes;
  final List<Offset> currentPoints;
  final Color penColor;
  final List<dynamic>? calibrationMarkers;

  DrawingPainter({
    required this.character,
    required this.showGuide,
    required this.showArrows,
    this.guides,
    required this.strokes,
    required this.currentPoints,
    required this.penColor,
    this.calibrationMarkers,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;

    // 1. Guide character
    if (showGuide) {
      final tp = TextPainter(
        text: TextSpan(
          text: character,
          style: TextStyle(
            fontSize: s * 0.67,
            color: Colors.grey.withValues(alpha: 0.18),
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset((s - tp.width) / 2, (s - tp.height) / 2 + s * 0.03));
    }

    // 2. Stroke-order arrows
    if (showArrows && guides != null) {
      for (var i = 0; i < guides!.length; i++) {
        final g = guides![i];
        final cx = g.x * s;
        final cy = g.y * s;
        final r = 12.0;
        final arrowLen = 25.0;
        final headLen = 8.0;
        final rad = g.angleRad;

        // Numbered circle
        canvas.drawCircle(
          Offset(cx, cy),
          r,
          Paint()..color = const Color(0xD9646CFF),
        );
        final numPainter = TextPainter(
          text: TextSpan(
            text: '${i + 1}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        numPainter.paint(canvas, Offset(cx - numPainter.width / 2, cy - numPainter.height / 2));

        // Direction arrow
        final ax = cx + math.cos(rad) * arrowLen;
        final ay = cy + math.sin(rad) * arrowLen;
        final arrowPaint = Paint()
          ..color = const Color(0xD9646CFF)
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

        final startX = cx + math.cos(rad) * r;
        final startY = cy + math.sin(rad) * r;
        canvas.drawLine(Offset(startX, startY), Offset(ax, ay), arrowPaint);
        canvas.drawLine(
          Offset(ax, ay),
          Offset(ax - headLen * math.cos(rad - 0.5), ay - headLen * math.sin(rad - 0.5)),
          arrowPaint,
        );
        canvas.drawLine(
          Offset(ax, ay),
          Offset(ax - headLen * math.cos(rad + 0.5), ay - headLen * math.sin(rad + 0.5)),
          arrowPaint,
        );
      }
    }

    // 2b. Calibration markers
    if (calibrationMarkers != null) {
      for (var i = 0; i < calibrationMarkers!.length; i++) {
        final m = calibrationMarkers![i];
        final cx = (m.x as double) * s;
        final cy = (m.y as double) * s;
        final angle = (m.angle as int) * math.pi / 180;
        const r = 12.0;
        const arrowLen = 25.0;
        const headLen = 8.0;

        canvas.drawCircle(
          Offset(cx, cy),
          r,
          Paint()..color = const Color(0xD9DC3C3C),
        );
        final numPainter = TextPainter(
          text: TextSpan(
            text: '${i + 1}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        numPainter.paint(canvas, Offset(cx - numPainter.width / 2, cy - numPainter.height / 2));

        final ax = cx + math.cos(angle) * arrowLen;
        final ay = cy + math.sin(angle) * arrowLen;
        final arrowPaint = Paint()
          ..color = const Color(0xD9DC3C3C)
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;
        canvas.drawLine(Offset(cx + math.cos(angle) * r, cy + math.sin(angle) * r), Offset(ax, ay), arrowPaint);
        canvas.drawLine(Offset(ax, ay), Offset(ax - headLen * math.cos(angle - 0.5), ay - headLen * math.sin(angle - 0.5)), arrowPaint);
        canvas.drawLine(Offset(ax, ay), Offset(ax - headLen * math.cos(angle + 0.5), ay - headLen * math.sin(angle + 0.5)), arrowPaint);
      }
    }

    // 3. Completed strokes
    for (final stroke in strokes) {
      if (stroke.points.length < 2) continue;
      final paint = Paint()
        ..color = stroke.color ?? penColor
        ..strokeWidth = 4
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;
      final path = Path()..moveTo(stroke.points[0].dx * s, stroke.points[0].dy * s);
      for (var i = 1; i < stroke.points.length; i++) {
        path.lineTo(stroke.points[i].dx * s, stroke.points[i].dy * s);
      }
      canvas.drawPath(path, paint);
    }

    // 4. Current in-progress stroke
    if (currentPoints.length > 1) {
      final paint = Paint()
        ..color = penColor
        ..strokeWidth = 4
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;
      final path = Path()..moveTo(currentPoints[0].dx * s, currentPoints[0].dy * s);
      for (var i = 1; i < currentPoints.length; i++) {
        path.lineTo(currentPoints[i].dx * s, currentPoints[i].dy * s);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant DrawingPainter old) => true;
}

/// A completed user-drawn stroke with normalised points and optional colour.
class DrawnStroke {
  final List<Offset> points;
  Color? color;

  DrawnStroke({required this.points, this.color});
}
