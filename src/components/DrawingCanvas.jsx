import { useRef, useEffect, useCallback, useState } from 'react'

/**
 * Canvas size in CSS pixels. The canvas is always square.
 * The internal resolution is doubled for crisp rendering on high-DPI screens.
 */
const SIZE = 300
const DPR = typeof window !== 'undefined' ? window.devicePixelRatio || 1 : 1
const RES = SIZE * DPR

const PEN_WIDTH = 4 * DPR
const GUIDE_FONT_SIZE = Math.round(200 * DPR)
const ARROW_CIRCLE_R = 12 * DPR
const ARROW_LEN = 25 * DPR
const ARROW_HEAD = 8 * DPR

/**
 * DrawingCanvas
 *
 * A square HTML5 canvas for freehand Devanagari character drawing.
 *
 * Rendering layers (bottom to top):
 *   1. Light-gray font-rendered character guide (tracing modes only).
 *   2. Numbered stroke-order arrows (guided mode only).
 *   3. User-drawn strokes (colored after accuracy check).
 *   4. The stroke currently being drawn.
 *
 * @param {Object} props
 * @param {string}  props.character    - The Devanagari character to practise.
 * @param {boolean} props.showGuide    - Render the character as a translucent overlay.
 * @param {boolean} props.showArrows   - Render stroke-order arrows.
 * @param {import('../data/strokes').StrokeGuide[]} [props.guides] - Stroke-order data.
 * @param {Array<{points: {x:number,y:number}[], color: string|null}>} props.strokes
 *   Completed strokes. Each stroke has normalised points and an optional colour
 *   override (set after accuracy checking).
 * @param {(points: {x:number,y:number}[]) => void} props.onStrokeAdd
 *   Called when the user finishes drawing a stroke (pointer up).
 */
function DrawingCanvas({ character, showGuide, showArrows, guides, strokes, onStrokeAdd, calibrating, calibrationMarkers, onCalibrationTap }) {
  const canvasRef = useRef(null)
  const [currentPoints, setCurrentPoints] = useState([])
  const isDrawingRef = useRef(false)
  const isDark = typeof window !== 'undefined'
    && window.matchMedia('(prefers-color-scheme: dark)').matches

  const defaultStrokeColor = isDark ? '#c8c8ff' : '#333399'

  const redraw = useCallback(() => {
    const canvas = canvasRef.current
    if (!canvas) return
    const ctx = canvas.getContext('2d')
    ctx.clearRect(0, 0, RES, RES)

    // 1. Guide character
    if (showGuide && character) {
      ctx.save()
      ctx.font = `${GUIDE_FONT_SIZE}px serif`
      ctx.textAlign = 'center'
      ctx.textBaseline = 'middle'
      ctx.fillStyle = isDark
        ? 'rgba(200, 200, 200, 0.18)'
        : 'rgba(100, 100, 100, 0.18)'
      ctx.fillText(character, RES / 2, RES / 2 + 10 * DPR)
      ctx.restore()
    }

    // 2. Stroke-order arrows
    if (showArrows && guides) {
      guides.forEach((g, i) => {
        const cx = g.x * RES
        const cy = g.y * RES
        const rad = (g.angle * Math.PI) / 180

        ctx.save()
        ctx.beginPath()
        ctx.arc(cx, cy, ARROW_CIRCLE_R, 0, 2 * Math.PI)
        ctx.fillStyle = 'rgba(100, 108, 255, 0.85)'
        ctx.fill()
        ctx.fillStyle = '#fff'
        ctx.font = `bold ${14 * DPR}px sans-serif`
        ctx.textAlign = 'center'
        ctx.textBaseline = 'middle'
        ctx.fillText(String(i + 1), cx, cy)
        ctx.restore()

        const ax = cx + Math.cos(rad) * ARROW_LEN
        const ay = cy + Math.sin(rad) * ARROW_LEN
        ctx.save()
        ctx.strokeStyle = 'rgba(100, 108, 255, 0.85)'
        ctx.lineWidth = 2 * DPR
        ctx.beginPath()
        ctx.moveTo(cx + Math.cos(rad) * ARROW_CIRCLE_R, cy + Math.sin(rad) * ARROW_CIRCLE_R)
        ctx.lineTo(ax, ay)
        ctx.lineTo(ax - ARROW_HEAD * Math.cos(rad - 0.5), ay - ARROW_HEAD * Math.sin(rad - 0.5))
        ctx.moveTo(ax, ay)
        ctx.lineTo(ax - ARROW_HEAD * Math.cos(rad + 0.5), ay - ARROW_HEAD * Math.sin(rad + 0.5))
        ctx.stroke()
        ctx.restore()
      })
    }

    // 2b. Calibration markers
    if (calibrating && calibrationMarkers) {
      calibrationMarkers.forEach((m, i) => {
        const cx = m.x * RES
        const cy = m.y * RES
        const rad = (m.angle * Math.PI) / 180

        ctx.save()
        ctx.beginPath()
        ctx.arc(cx, cy, ARROW_CIRCLE_R, 0, 2 * Math.PI)
        ctx.fillStyle = 'rgba(220, 60, 60, 0.85)'
        ctx.fill()
        ctx.fillStyle = '#fff'
        ctx.font = `bold ${14 * DPR}px sans-serif`
        ctx.textAlign = 'center'
        ctx.textBaseline = 'middle'
        ctx.fillText(String(i + 1), cx, cy)
        ctx.restore()

        const ax = cx + Math.cos(rad) * ARROW_LEN
        const ay = cy + Math.sin(rad) * ARROW_LEN
        ctx.save()
        ctx.strokeStyle = 'rgba(220, 60, 60, 0.85)'
        ctx.lineWidth = 2 * DPR
        ctx.beginPath()
        ctx.moveTo(cx + Math.cos(rad) * ARROW_CIRCLE_R, cy + Math.sin(rad) * ARROW_CIRCLE_R)
        ctx.lineTo(ax, ay)
        ctx.lineTo(ax - ARROW_HEAD * Math.cos(rad - 0.5), ay - ARROW_HEAD * Math.sin(rad - 0.5))
        ctx.moveTo(ax, ay)
        ctx.lineTo(ax - ARROW_HEAD * Math.cos(rad + 0.5), ay - ARROW_HEAD * Math.sin(rad + 0.5))
        ctx.stroke()
        ctx.restore()
      })
    }

    // 3. Completed strokes
    strokes.forEach((s) => {
      if (s.points.length < 2) return
      ctx.save()
      ctx.strokeStyle = s.color || defaultStrokeColor
      ctx.lineWidth = PEN_WIDTH
      ctx.lineCap = 'round'
      ctx.lineJoin = 'round'
      ctx.beginPath()
      ctx.moveTo(s.points[0].x * RES, s.points[0].y * RES)
      for (let i = 1; i < s.points.length; i++) {
        ctx.lineTo(s.points[i].x * RES, s.points[i].y * RES)
      }
      ctx.stroke()
      ctx.restore()
    })

    // 4. Current in-progress stroke
    if (currentPoints.length > 1) {
      ctx.save()
      ctx.strokeStyle = defaultStrokeColor
      ctx.lineWidth = PEN_WIDTH
      ctx.lineCap = 'round'
      ctx.lineJoin = 'round'
      ctx.beginPath()
      ctx.moveTo(currentPoints[0].x * RES, currentPoints[0].y * RES)
      for (let i = 1; i < currentPoints.length; i++) {
        ctx.lineTo(currentPoints[i].x * RES, currentPoints[i].y * RES)
      }
      ctx.stroke()
      ctx.restore()
    }
  }, [character, showGuide, showArrows, guides, strokes, currentPoints, isDark, defaultStrokeColor, calibrating, calibrationMarkers])

  useEffect(() => { redraw() }, [redraw])

  const toNorm = (e) => {
    const rect = canvasRef.current.getBoundingClientRect()
    return {
      x: (e.clientX - rect.left) / rect.width,
      y: (e.clientY - rect.top) / rect.height,
    }
  }

  const onPointerDown = (e) => {
    if (calibrating) {
      const pt = toNorm(e)
      if (onCalibrationTap) onCalibrationTap(pt)
      return
    }
    e.currentTarget.setPointerCapture(e.pointerId)
    isDrawingRef.current = true
    setCurrentPoints([toNorm(e)])
  }

  const onPointerMove = (e) => {
    if (!isDrawingRef.current) return
    setCurrentPoints((prev) => [...prev, toNorm(e)])
  }

  const onPointerUp = () => {
    if (!isDrawingRef.current) return
    isDrawingRef.current = false
    if (currentPoints.length > 1) {
      onStrokeAdd(currentPoints)
    }
    setCurrentPoints([])
  }

  const onPointerCancel = () => {
    isDrawingRef.current = false
    setCurrentPoints([])
  }

  return (
    <canvas
      ref={canvasRef}
      width={RES}
      height={RES}
      style={{
        width: SIZE,
        height: SIZE,
        border: `1px solid ${isDark ? '#555' : '#ccc'}`,
        borderRadius: 8,
        touchAction: 'none',
        cursor: 'crosshair',
      }}
      onPointerDown={onPointerDown}
      onPointerMove={onPointerMove}
      onPointerUp={onPointerUp}
      onPointerCancel={onPointerCancel}
    />
  )
}

export default DrawingCanvas
