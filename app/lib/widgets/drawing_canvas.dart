// Drawing canvas widget — wraps CustomPaint with GestureDetector for touch input.

import 'package:flutter/material.dart';
import '../data/strokes.dart';
import 'drawing_painter.dart';

class DrawingCanvas extends StatefulWidget {
  final String character;
  final bool showGuide;
  final bool showArrows;
  final List<StrokeGuide>? guides;
  final List<DrawnStroke> strokes;
  final ValueChanged<List<Offset>> onStrokeAdd;
  final List<dynamic>? calibrationMarkers;

  const DrawingCanvas({
    super.key,
    required this.character,
    required this.showGuide,
    required this.showArrows,
    this.guides,
    required this.strokes,
    required this.onStrokeAdd,
    this.calibrationMarkers,
  });

  @override
  State<DrawingCanvas> createState() => _DrawingCanvasState();
}

class _DrawingCanvasState extends State<DrawingCanvas> {
  List<Offset> _currentPoints = [];

  Offset _toNorm(Offset local, Size size) {
    return Offset(
      (local.dx / size.width).clamp(0.0, 1.0),
      (local.dy / size.height).clamp(0.0, 1.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final penColor = isDark ? const Color(0xFFC8C8FF) : const Color(0xFF333399);
    final borderColor = isDark ? Colors.grey[700]! : Colors.grey[300]!;

    return LayoutBuilder(builder: (context, constraints) {
      final canvasSize = constraints.maxWidth.clamp(0.0, 300.0);
      return GestureDetector(
        onTapUp: widget.calibrationMarkers != null
            ? (d) {
                final box = context.findRenderObject() as RenderBox;
                widget.onStrokeAdd([_toNorm(d.localPosition, box.size)]);
              }
            : null,
        onPanStart: (d) {
          final box = context.findRenderObject() as RenderBox;
          setState(() {
            _currentPoints = [_toNorm(d.localPosition, box.size)];
          });
        },
        onPanUpdate: (d) {
          final box = context.findRenderObject() as RenderBox;
          setState(() {
            _currentPoints = [..._currentPoints, _toNorm(d.localPosition, box.size)];
          });
        },
        onPanEnd: (_) {
          if (_currentPoints.isNotEmpty) {
            widget.onStrokeAdd(_currentPoints);
          }
          setState(() => _currentPoints = []);
        },
        onPanCancel: () => setState(() => _currentPoints = []),
        child: Container(
          width: canvasSize,
          height: canvasSize,
          decoration: BoxDecoration(
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(8),
          ),
          child: CustomPaint(
            size: Size(canvasSize, canvasSize),
            painter: DrawingPainter(
              character: widget.character,
              showGuide: widget.showGuide,
              showArrows: widget.showArrows,
              guides: widget.guides,
              strokes: widget.strokes,
              currentPoints: widget.calibrationMarkers != null ? const [] : _currentPoints,
              penColor: penColor,
              calibrationMarkers: widget.calibrationMarkers,
            ),
          ),
        ),
      );
    });
  }
}
