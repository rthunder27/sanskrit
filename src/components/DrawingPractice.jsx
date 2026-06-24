import { useState, useEffect, useRef, useCallback } from 'react'
import DrawingCanvas from './DrawingCanvas'
import { computeCoverage } from '../utils/strokeMatch'
import { strokeGuides } from '../data/strokes'
import './DrawingPractice.css'

const SUB_MODES = [
  { key: 'guided',   label: 'Guided' },
  { key: 'unguided', label: 'Unguided' },
  { key: 'freeDraw', label: 'Free Draw' },
  { key: 'memory',   label: 'Memory' },
]

const MEMORY_FLASH_MS = 2000

/**
 * DrawingPractice
 *
 * Container for the Draw mode. Manages character navigation, sub-mode
 * switching, user stroke state, accuracy checking, and the memory-mode
 * flash timer. Only characters present in strokeGuides are shown.
 *
 * @param {Object} props
 * @param {import('../data/devanagari').FlashcardEntry[]} props.entries
 */
function DrawingPractice({ entries }) {
  const available = entries
  const [index, setIndex] = useState(0)
  const [subMode, setSubMode] = useState('guided')
  const [strokes, setStrokes] = useState([])
  const [score, setScore] = useState(null)
  const [memoryVisible, setMemoryVisible] = useState(false)
  const [calibrating, setCalibrating] = useState(false)
  const [calMarkers, setCalMarkers] = useState([])
  const [selectedMarker, setSelectedMarker] = useState(null)
  const timerRef = useRef(null)

  const entry = available[index] || available[0]
  const character = entry?.character
  const guides = character ? strokeGuides[character] : null

  const resetCanvas = useCallback(() => {
    setStrokes([])
    setScore(null)
  }, [])

  useEffect(() => { resetCanvas() }, [index, subMode, resetCanvas])
  useEffect(() => { setCalMarkers([]); setSelectedMarker(null) }, [index])

  useEffect(() => {
    if (subMode === 'memory') {
      setMemoryVisible(true)
      timerRef.current = setTimeout(() => setMemoryVisible(false), MEMORY_FLASH_MS)
      return () => clearTimeout(timerRef.current)
    }
  }, [index, subMode])

  if (available.length === 0) {
    return (
      <div className="drawing-practice">
        <p>No characters in the selected deck.</p>
      </div>
    )
  }

  const handleStrokeAdd = (points) => {
    setStrokes((prev) => [...prev, { points, color: null }])
    setScore(null)
  }

  const handleClear = () => resetCanvas()

  const handleCheck = () => {
    const coverage = computeCoverage(character, strokes)
    setScore(Math.round(coverage * 100))
    const pass = coverage >= 0.35
    setStrokes((prev) =>
      prev.map((s) => ({ ...s, color: pass ? '#38a169' : '#e53e3e' }))
    )
  }

  const handleShowAgain = () => {
    setMemoryVisible(true)
    clearTimeout(timerRef.current)
    timerRef.current = setTimeout(() => setMemoryVisible(false), MEMORY_FLASH_MS)
  }

  const handleCalTap = (pt) => {
    const marker = { x: Math.round(pt.x * 100) / 100, y: Math.round(pt.y * 100) / 100, angle: 90 }
    setCalMarkers((prev) => [...prev, marker])
    setSelectedMarker(calMarkers.length)
  }

  const handleCalAngle = (idx, angle) => {
    setCalMarkers((prev) => prev.map((m, i) => i === idx ? { ...m, angle: Number(angle) } : m))
  }

  const handleCalUndo = () => {
    setCalMarkers((prev) => prev.slice(0, -1))
    setSelectedMarker((s) => s != null && s >= calMarkers.length - 1 ? Math.max(0, calMarkers.length - 2) : s)
  }

  const handleCalCopy = () => {
    const lines = calMarkers.map((m) => `    { x: ${m.x.toFixed(2)}, y: ${m.y.toFixed(2)}, angle: ${m.angle} },`)
    const code = `  '${character}': [\n${lines.join('\n')}\n  ],`
    navigator.clipboard.writeText(code)
    alert('Copied to clipboard!')
  }

  const showGuide = subMode === 'guided' || subMode === 'unguided'
  const showArrows = subMode === 'guided'

  return (
    <div className="drawing-practice">
      {/* Sub-mode selector */}
      <div className="drawing-practice__modes">
        {SUB_MODES.map((m) => (
          <button
            key={m.key}
            className={subMode === m.key ? 'drawing-practice__mode--active' : ''}
            onClick={() => setSubMode(m.key)}
          >
            {m.label}
          </button>
        ))}
      </div>

      {/* Character navigation */}
      <div className="drawing-practice__nav">
        <button onClick={() => { setIndex((i) => (i - 1 + available.length) % available.length) }}>
          ←
        </button>
        <span className="drawing-practice__counter">
          {index + 1} / {available.length}
        </span>
        <button onClick={() => { setIndex((i) => (i + 1) % available.length) }}>
          →
        </button>
      </div>

      {/* Reference character (free draw / memory flash) */}
      {subMode === 'freeDraw' && (
        <div className="drawing-practice__reference">{character}</div>
      )}
      {subMode === 'memory' && (
        <div className="drawing-practice__reference">
          {memoryVisible ? character : '?'}
        </div>
      )}

      {/* Transliteration label */}
      <span className="drawing-practice__label">{entry.transliteration}</span>

      {/* Drawing canvas */}
      <DrawingCanvas
        character={character}
        showGuide={calibrating || showGuide}
        showArrows={!calibrating && showArrows}
        guides={guides}
        strokes={calibrating ? [] : strokes}
        onStrokeAdd={handleStrokeAdd}
        calibrating={calibrating}
        calibrationMarkers={calMarkers}
        onCalibrationTap={handleCalTap}
      />

      {/* Calibrate toggle */}
      <button
        className={`drawing-practice__calibrate ${calibrating ? 'drawing-practice__calibrate--active' : ''}`}
        onClick={() => setCalibrating((c) => !c)}
      >
        {calibrating ? 'Exit Calibrate' : 'Calibrate'}
      </button>

      {/* Calibration controls */}
      {calibrating && (
        <div className="drawing-practice__cal-panel">
          <p className="drawing-practice__cal-hint">
            Click the canvas to place stroke-start markers. Adjust angles below.
          </p>
          {calMarkers.map((m, i) => (
            <div key={i} className="drawing-practice__cal-row">
              <span
                className={`drawing-practice__cal-num ${selectedMarker === i ? 'drawing-practice__cal-num--selected' : ''}`}
                onClick={() => setSelectedMarker(i)}
              >
                {i + 1}
              </span>
              <span className="drawing-practice__cal-pos">
                ({m.x.toFixed(2)}, {m.y.toFixed(2)})
              </span>
              <input
                type="range"
                min="0"
                max="359"
                value={m.angle}
                onChange={(e) => handleCalAngle(i, e.target.value)}
              />
              <span className="drawing-practice__cal-angle">{m.angle}°</span>
            </div>
          ))}
          <div className="drawing-practice__cal-actions">
            <button onClick={handleCalUndo} disabled={calMarkers.length === 0}>
              Undo
            </button>
            <button onClick={handleCalCopy} disabled={calMarkers.length === 0}>
              Copy
            </button>
          </div>
        </div>
      )}

      {/* Action buttons (normal mode) */}
      {!calibrating && (
        <div className="drawing-practice__actions">
          <button onClick={handleClear}>Clear</button>
          <button onClick={handleCheck} disabled={strokes.length === 0}>
            Check
          </button>
          {subMode === 'memory' && !memoryVisible && (
            <button onClick={handleShowAgain}>Show Again</button>
          )}
        </div>
      )}

      {/* Score feedback */}
      {!calibrating && score !== null && (
        <p className={`drawing-practice__score ${score >= 35 ? 'drawing-practice__score--pass' : 'drawing-practice__score--fail'}`}>
          Coverage: {score}%
        </p>
      )}
    </div>
  )
}

export default DrawingPractice
