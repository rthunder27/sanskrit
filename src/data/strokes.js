/**
 * Stroke order guide data for Devanagari vowels.
 *
 * Each entry is an array of stroke guides. A guide marks where a stroke
 * begins and which direction it travels, so the guided-tracing mode can
 * render numbered arrows on the canvas.
 *
 * Coordinates are normalised to a [0, 1] square (multiply by canvas size
 * to get pixel positions). Angles follow standard math convention adapted
 * for screen coordinates: 0 = right, 90 = down, 180 = left, 270 = up.
 *
 * The character outline itself comes from font rendering on the canvas,
 * not from these points — so the guides only need to mark stroke starts
 * and directions, not trace the full path.
 *
 * @typedef {Object} StrokeGuide
 * @property {number} x - Normalised x of stroke start (0–1).
 * @property {number} y - Normalised y of stroke start (0–1).
 * @property {number} angle - Direction the stroke travels (degrees).
 */

/** @type {Record<string, StrokeGuide[]>} */
export const strokeGuides = {
  'अ': [
    { x: 0.48, y: 0.18, angle: 225 },
    { x: 0.62, y: 0.18, angle: 90 },
    { x: 0.18, y: 0.18, angle: 0 },
  ],
  'आ': [
    { x: 0.38, y: 0.18, angle: 225 },
    { x: 0.50, y: 0.18, angle: 90 },
    { x: 0.72, y: 0.18, angle: 90 },
    { x: 0.15, y: 0.18, angle: 0 },
  ],
  'इ': [
    { x: 0.45, y: 0.22, angle: 135 },
    { x: 0.40, y: 0.10, angle: 330 },
    { x: 0.20, y: 0.18, angle: 0 },
  ],
  'ई': [
    { x: 0.45, y: 0.22, angle: 135 },
    { x: 0.42, y: 0.62, angle: 90 },
    { x: 0.20, y: 0.18, angle: 0 },
  ],
  'उ': [
    { x: 0.35, y: 0.22, angle: 90 },
    { x: 0.30, y: 0.18, angle: 0 },
  ],
  'ऊ': [
    { x: 0.32, y: 0.22, angle: 90 },
    { x: 0.50, y: 0.60, angle: 90 },
    { x: 0.22, y: 0.18, angle: 0 },
  ],
  'ऋ': [
    { x: 0.30, y: 0.22, angle: 45 },
    { x: 0.35, y: 0.45, angle: 135 },
    { x: 0.62, y: 0.18, angle: 90 },
    { x: 0.18, y: 0.18, angle: 0 },
  ],
  'ए': [
    { x: 0.35, y: 0.28, angle: 200 },
    { x: 0.62, y: 0.18, angle: 90 },
    { x: 0.18, y: 0.18, angle: 0 },
  ],
  'ऐ': [
    { x: 0.35, y: 0.28, angle: 200 },
    { x: 0.38, y: 0.08, angle: 330 },
    { x: 0.62, y: 0.18, angle: 90 },
    { x: 0.18, y: 0.18, angle: 0 },
  ],
  'ओ': [
    { x: 0.32, y: 0.28, angle: 200 },
    { x: 0.68, y: 0.06, angle: 90 },
    { x: 0.58, y: 0.18, angle: 90 },
    { x: 0.15, y: 0.18, angle: 0 },
  ],
  'औ': [
    { x: 0.32, y: 0.28, angle: 200 },
    { x: 0.35, y: 0.08, angle: 330 },
    { x: 0.68, y: 0.06, angle: 90 },
    { x: 0.58, y: 0.18, angle: 90 },
    { x: 0.15, y: 0.18, angle: 0 },
  ],
}
