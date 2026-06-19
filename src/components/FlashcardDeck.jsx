import { useState, useRef } from 'react'
import Flashcard from './Flashcard'
import './FlashcardDeck.css'

/**
 * Returns a new array with the elements of `arr` in a random order
 * using the Fisher-Yates shuffle algorithm.
 *
 * @template T
 * @param {T[]} arr
 * @returns {T[]}
 */
function shuffle(arr) {
  const copy = [...arr]
  for (let i = copy.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1))
    ;[copy[i], copy[j]] = [copy[j], copy[i]]
  }
  return copy
}

/** Minimum horizontal distance (px) to register as a swipe. */
const SWIPE_THRESHOLD = 80

/** Minimum movement (px) before a drag starts (avoids eating taps). */
const DRAG_THRESHOLD = 8

/**
 * FlashcardDeck
 *
 * Browse mode with swipe animation matching quiz mode. Swipe right to advance,
 * swipe left to go back. The current card flies off-screen and the next card
 * fades in from the centre.
 *
 * @param {Object} props
 * @param {import('../data/devanagari').FlashcardEntry[]} props.entries
 */
function FlashcardDeck({ entries }) {
  const [displayEntries, setDisplayEntries] = useState(entries)
  const [index, setIndex] = useState(0)
  const [flipped, setFlipped] = useState(false)
  const [dragX, setDragX] = useState(0)
  const [dragging, setDragging] = useState(false)
  const [flyingOut, setFlyingOut] = useState(null)

  const startXRef = useRef(null)
  const hasDraggedRef = useRef(false)

  const goTo = (newIndex) => {
    const wrapped = (newIndex + displayEntries.length) % displayEntries.length
    setIndex(wrapped)
    setFlipped(false)
  }

  const handleShuffle = () => {
    setDisplayEntries(shuffle(entries))
    setIndex(0)
    setFlipped(false)
    setDragX(0)
  }

  const handleSwipe = (direction) => {
    setFlyingOut(direction)
    setDragging(false)
    setTimeout(() => {
      goTo(direction === 'right' ? index + 1 : index - 1)
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

  const translateX = flyingOut === 'right'
    ? '160%'
    : flyingOut === 'left'
    ? '-160%'
    : `${dragX}px`
  const rotation = (flyingOut ? (flyingOut === 'right' ? 1 : -1) * 160 : dragX) * 0.08

  const cardStyle = {
    transform: `translateX(${translateX}) rotate(${rotation}deg)`,
    transition: dragging && !flyingOut ? 'none' : 'transform 0.3s ease',
    touchAction: 'none',
    userSelect: 'none',
  }

  return (
    <div className="flashcard-deck">
      <span className="flashcard-deck__counter">
        {index + 1} / {displayEntries.length}
      </span>

      <div
        className="flashcard-deck__stage"
        onPointerDown={onPointerDown}
        onPointerMove={onPointerMove}
        onPointerUp={onPointerUp}
        onPointerCancel={onPointerCancel}
      >
        <div key={displayEntries[index].character} className="flashcard-deck__card-enter">
          <div style={cardStyle}>
            <Flashcard
              entry={displayEntries[index]}
              flipped={flipped}
              onFlip={() => {}}
            />
          </div>
        </div>
      </div>

      <p className="flashcard-deck__hint">Tap to flip &middot; swipe to navigate</p>

      <div className="flashcard-deck__controls">
        <button onClick={() => goTo(index - 1)}>Previous</button>
        <button onClick={() => goTo(index + 1)}>Next</button>
      </div>
      <button onClick={handleShuffle}>Shuffle</button>
    </div>
  )
}

export default FlashcardDeck
