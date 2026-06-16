import { useState } from 'react'
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

/**
 * FlashcardDeck
 *
 * Renders a single flashcard from `entries` along with controls to flip it,
 * step forward/backward through the deck, and shuffle the order. Shuffling
 * randomizes the current deck and resets to card 1. Switching to a different
 * deck (which remounts this component) always restores the original order.
 *
 * @param {Object} props
 * @param {import('../data/devanagari').FlashcardEntry[]} props.entries - The ordered list of cards to study.
 */
function FlashcardDeck({ entries }) {
  const [displayEntries, setDisplayEntries] = useState(entries)
  const [index, setIndex] = useState(0)
  const [flipped, setFlipped] = useState(false)

  const goTo = (newIndex) => {
    const wrapped = (newIndex + displayEntries.length) % displayEntries.length
    setIndex(wrapped)
    setFlipped(false)
  }

  const handleShuffle = () => {
    setDisplayEntries(shuffle(entries))
    setIndex(0)
    setFlipped(false)
  }

  return (
    <div className="flashcard-deck">
      <Flashcard
        entry={displayEntries[index]}
        flipped={flipped}
        onFlip={() => setFlipped((f) => !f)}
      />
      <div className="flashcard-deck__controls">
        <button onClick={() => goTo(index - 1)}>Previous</button>
        <span className="flashcard-deck__counter">
          {index + 1} / {displayEntries.length}
        </span>
        <button onClick={() => goTo(index + 1)}>Next</button>
      </div>
      <button onClick={handleShuffle}>Shuffle</button>
    </div>
  )
}

export default FlashcardDeck
