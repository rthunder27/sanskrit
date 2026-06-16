import { useState } from 'react'
import FlashcardDeck from './components/FlashcardDeck'
import FlashcardQuiz from './components/FlashcardQuiz'
import { decks } from './data/devanagari'
import './App.css'

/** Human-readable labels for each deck key in `decks`. */
const deckLabels = {
  vowels: 'Vowels',
  consonants: 'Consonants',
  all: 'All',
}

/**
 * App
 *
 * Top-level component. Lets the user pick a deck and switch between two modes:
 * - Browse: step through cards in order (or shuffled) with Previous/Next.
 * - Quiz:   swipe-based review queue — right to mark correct, left to retry.
 *
 * Switching decks always resets back to Browse mode.
 */
function App() {
  const [deckKey, setDeckKey] = useState('vowels')
  const [mode, setMode] = useState('browse') // 'browse' | 'quiz'

  const switchDeck = (key) => {
    setDeckKey(key)
    setMode('browse')
  }

  return (
    <div className="app">
      <h1>Devanagari Flashcards</h1>

      <div className="deck-selector">
        {Object.keys(decks).map((key) => (
          <button
            key={key}
            className={key === deckKey ? 'deck-selector__button--active' : ''}
            onClick={() => switchDeck(key)}
          >
            {deckLabels[key] ?? key}
          </button>
        ))}
      </div>

      <div className="mode-selector">
        <button
          className={mode === 'browse' ? 'mode-selector__button--active' : ''}
          onClick={() => setMode('browse')}
        >
          Browse
        </button>
        <button
          className={mode === 'quiz' ? 'mode-selector__button--active' : ''}
          onClick={() => setMode('quiz')}
        >
          Quiz
        </button>
      </div>

      {mode === 'browse' ? (
        <FlashcardDeck key={deckKey} entries={decks[deckKey]} />
      ) : (
        <FlashcardQuiz key={deckKey} entries={decks[deckKey]} onExit={() => setMode('browse')} />
      )}
    </div>
  )
}

export default App
