import { useState } from 'react'
import FlashcardDeck from './components/FlashcardDeck'
import { decks } from './data/devanagari'
import './App.css'

/** Human-readable labels for each deck key in `decks`. */
const deckLabels = {
  vowels: 'Vowels',
  consonants: 'Consonants',
}

/**
 * App
 *
 * Top-level component for the Sanskrit learning app. Lets the user pick
 * which Devanagari flashcard deck to study (vowels, consonants, ...) and
 * renders that deck. Later this can grow to include other study modes
 * (drawing practice, pronunciation).
 */
function App() {
  const [deckKey, setDeckKey] = useState('vowels')

  return (
    <div className="app">
      <h1>Devanagari Flashcards</h1>
      <div className="deck-selector">
        {Object.keys(decks).map((key) => (
          <button
            key={key}
            className={key === deckKey ? 'deck-selector__button--active' : ''}
            onClick={() => setDeckKey(key)}
          >
            {deckLabels[key] ?? key}
          </button>
        ))}
      </div>
      <FlashcardDeck key={deckKey} entries={decks[deckKey]} />
    </div>
  )
}

export default App
