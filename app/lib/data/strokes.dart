// Stroke order guide data for Devanagari vowels.
// Each entry marks where a stroke starts and which direction it travels,
// so the guided-tracing mode can render numbered arrows on the canvas.
// Coordinates are normalised to [0, 1]. Angles: 0=right, 90=down, 180=left, 270=up.

import 'dart:math' as math;

/// A single stroke-order guide marker.
class StrokeGuide {
  final double x;
  final double y;
  final double angle;

  const StrokeGuide(this.x, this.y, this.angle);

  double get angleRad => angle * math.pi / 180;
}

/// Stroke order guides keyed by character.
const Map<String, List<StrokeGuide>> strokeGuides = {
  'अ': [
    StrokeGuide(0.48, 0.18, 225),
    StrokeGuide(0.62, 0.18, 90),
    StrokeGuide(0.18, 0.18, 0),
  ],
  'आ': [
    StrokeGuide(0.38, 0.18, 225),
    StrokeGuide(0.50, 0.18, 90),
    StrokeGuide(0.72, 0.18, 90),
    StrokeGuide(0.15, 0.18, 0),
  ],
  'इ': [
    StrokeGuide(0.45, 0.22, 135),
    StrokeGuide(0.40, 0.10, 330),
    StrokeGuide(0.20, 0.18, 0),
  ],
  'ई': [
    StrokeGuide(0.45, 0.22, 135),
    StrokeGuide(0.42, 0.62, 90),
    StrokeGuide(0.20, 0.18, 0),
  ],
  'उ': [
    StrokeGuide(0.35, 0.22, 90),
    StrokeGuide(0.30, 0.18, 0),
  ],
  'ऊ': [
    StrokeGuide(0.32, 0.22, 90),
    StrokeGuide(0.50, 0.60, 90),
    StrokeGuide(0.22, 0.18, 0),
  ],
  'ऋ': [
    StrokeGuide(0.30, 0.22, 45),
    StrokeGuide(0.35, 0.45, 135),
    StrokeGuide(0.62, 0.18, 90),
    StrokeGuide(0.18, 0.18, 0),
  ],
  'ए': [
    StrokeGuide(0.35, 0.28, 200),
    StrokeGuide(0.62, 0.18, 90),
    StrokeGuide(0.18, 0.18, 0),
  ],
  'ऐ': [
    StrokeGuide(0.35, 0.28, 200),
    StrokeGuide(0.38, 0.08, 330),
    StrokeGuide(0.62, 0.18, 90),
    StrokeGuide(0.18, 0.18, 0),
  ],
  'ओ': [
    StrokeGuide(0.32, 0.28, 200),
    StrokeGuide(0.68, 0.06, 90),
    StrokeGuide(0.58, 0.18, 90),
    StrokeGuide(0.15, 0.18, 0),
  ],
  'औ': [
    StrokeGuide(0.32, 0.28, 200),
    StrokeGuide(0.35, 0.08, 330),
    StrokeGuide(0.68, 0.06, 90),
    StrokeGuide(0.58, 0.18, 90),
    StrokeGuide(0.15, 0.18, 0),
  ],
};
