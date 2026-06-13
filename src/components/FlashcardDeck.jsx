import { useState } from 'react'
import Flashcard from './Flashcard'
import './FlashcardDeck.css'

/**
 * FlashcardDeck
 *
 * Renders a single flashcard from `entries` along with controls to flip it
 * and step forward/backward through the deck. The flip state resets
 * whenever the current card changes, so each new card starts showing its
 * front face.
 *
 * @param {Object} props
 * @param {import('../data/devanagari').FlashcardEntry[]} props.entries - The ordered list of cards to study.
 */
function FlashcardDeck({ entries }) {
  const [index, setIndex] = useState(0)
  const [flipped, setFlipped] = useState(false)

  const goTo = (newIndex) => {
    const wrapped = (newIndex + entries.length) % entries.length
    setIndex(wrapped)
    setFlipped(false)
  }

  return (
    <div className="flashcard-deck">
      <Flashcard
        entry={entries[index]}
        flipped={flipped}
        onFlip={() => setFlipped((f) => !f)}
      />
      <div className="flashcard-deck__controls">
        <button onClick={() => goTo(index - 1)}>Previous</button>
        <span className="flashcard-deck__counter">
          {index + 1} / {entries.length}
        </span>
        <button onClick={() => goTo(index + 1)}>Next</button>
      </div>
    </div>
  )
}

export default FlashcardDeck
