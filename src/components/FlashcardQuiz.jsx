import { useState, useRef } from 'react'
import Flashcard from './Flashcard'
import './FlashcardQuiz.css'

/** Minimum horizontal distance (px) to register as an intentional swipe. */
const SWIPE_THRESHOLD = 80

/** Minimum horizontal distance (px) before a drag starts (avoids eating taps). */
const DRAG_THRESHOLD = 8

/**
 * FlashcardQuiz
 *
 * A swipe-based quiz mode. Cards are shown one at a time from a queue.
 * - Tap the card to flip it and reveal the answer.
 * - Swipe right (or click "Got it") to mark the card correct and remove it.
 * - Swipe left  (or click "Missed") to mark it wrong and move it to the back
 *   of the queue for another attempt.
 *
 * When the queue empties the user sees a completion screen with a restart option.
 *
 * @param {Object} props
 * @param {import('../data/devanagari').FlashcardEntry[]} props.entries - The full ordered card list.
 * @param {() => void} props.onExit - Called when the user wants to leave quiz mode.
 */
function FlashcardQuiz({ entries, onExit }) {
  const total = entries.length
  const [queue, setQueue] = useState([...entries])
  const [flipped, setFlipped] = useState(false)
  const [dragX, setDragX] = useState(0)
  const [dragging, setDragging] = useState(false)
  const [flyingOut, setFlyingOut] = useState(null) // 'left' | 'right' | null

  const startXRef = useRef(null)
  const hasDraggedRef = useRef(false)

  /** Animate the current card off-screen in `direction`, then update the queue. */
  const handleSwipe = (direction) => {
    setFlyingOut(direction)
    setDragging(false)
    setTimeout(() => {
      setQueue((prev) =>
        direction === 'right'
          ? prev.slice(1)
          : [...prev.slice(1), prev[0]]
      )
      setFlipped(false)
      setDragX(0)
      setFlyingOut(null)
    }, 300)
  }

  const onPointerDown = (e) => {
    if (flyingOut) return
    e.currentTarget.setPointerCapture(e.pointerId)
    startXRef.current = e.clientX
    hasDraggedRef.current = false
    setDragging(true)
  }

  const onPointerMove = (e) => {
    if (!dragging || flyingOut) return
    const delta = e.clientX - startXRef.current
    if (Math.abs(delta) > DRAG_THRESHOLD) hasDraggedRef.current = true
    if (hasDraggedRef.current) setDragX(delta)
  }

  const onPointerUp = () => {
    if (flyingOut) return
    setDragging(false)
    if (!hasDraggedRef.current) {
      setFlipped((f) => !f)
    } else if (Math.abs(dragX) > SWIPE_THRESHOLD) {
      handleSwipe(dragX > 0 ? 'right' : 'left')
    } else {
      setDragX(0)
    }
  }

  const onPointerCancel = () => {
    setDragging(false)
    setDragX(0)
  }

  if (queue.length === 0) {
    return (
      <div className="flashcard-quiz">
        <p className="flashcard-quiz__done-message">All done! Every card answered correctly.</p>
        <div className="flashcard-quiz__done-controls">
          <button onClick={() => { setQueue([...entries]); setFlipped(false) }}>
            Restart
          </button>
          <button onClick={onExit}>Back to Browse</button>
        </div>
      </div>
    )
  }

  const translateX = flyingOut === 'right'
    ? '130%'
    : flyingOut === 'left'
    ? '-130%'
    : `${dragX}px`
  const rotation = (flyingOut ? (flyingOut === 'right' ? 1 : -1) * 130 : dragX) * 0.08
  const cardStyle = {
    transform: `translateX(${translateX}) rotate(${rotation}deg)`,
    transition: dragging && !flyingOut ? 'none' : 'transform 0.3s ease',
    touchAction: 'none',
    userSelect: 'none',
  }

  const wrongOpacity = Math.max(0, Math.min(1, -dragX / SWIPE_THRESHOLD))
  const rightOpacity = Math.max(0, Math.min(1, dragX / SWIPE_THRESHOLD))

  return (
    <div className="flashcard-quiz">
      <p className="flashcard-quiz__progress">
        {total - queue.length} / {total} done · {queue.length} remaining
      </p>

      <div
        className="flashcard-quiz__stage"
        onPointerDown={onPointerDown}
        onPointerMove={onPointerMove}
        onPointerUp={onPointerUp}
        onPointerCancel={onPointerCancel}
      >
        <span
          className="flashcard-quiz__label flashcard-quiz__label--wrong"
          style={{ opacity: wrongOpacity }}
        >
          Wrong
        </span>

        <div style={cardStyle}>
          <Flashcard entry={queue[0]} flipped={flipped} onFlip={() => {}} />
        </div>

        <span
          className="flashcard-quiz__label flashcard-quiz__label--right"
          style={{ opacity: rightOpacity }}
        >
          Right
        </span>
      </div>

      <p className="flashcard-quiz__hint">Tap to flip &middot; swipe right if you knew it &middot; swipe left if you didn&apos;t</p>

      <div className="flashcard-quiz__buttons">
        <button className="flashcard-quiz__btn--wrong" onClick={() => handleSwipe('left')}>
          Missed
        </button>
        <button className="flashcard-quiz__btn--right" onClick={() => handleSwipe('right')}>
          Got it
        </button>
      </div>

      <button className="flashcard-quiz__exit" onClick={onExit}>Exit Quiz</button>
    </div>
  )
}

export default FlashcardQuiz
