import { useState } from 'react'
import FlashcardDeck from './components/FlashcardDeck'
import FlashcardQuiz from './components/FlashcardQuiz'
import ReferenceChart from './components/ReferenceChart'
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
 * Top-level component. Lets the user pick a deck and switch between three modes:
 * - Browse: step through cards in order (or shuffled) with Previous/Next.
 * - Quiz:   swipe-based review queue — right to mark correct, left to retry.
 * - Chart:  static grid of all characters with transliterations for quick reference.
 *
 * Switching decks always resets back to Browse mode.
 */
function App() {
  const [deckKey, setDeckKey] = useState('vowels')
  const [mode, setMode] = useState('browse') // 'browse' | 'quiz' | 'chart'

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
        <button
          className={mode === 'chart' ? 'mode-selector__button--active' : ''}
          onClick={() => setMode('chart')}
        >
          Chart
        </button>
      </div>

      {mode === 'browse' && <FlashcardDeck key={deckKey} entries={decks[deckKey]} />}
      {mode === 'quiz' && <FlashcardQuiz key={deckKey} entries={decks[deckKey]} onExit={() => setMode('browse')} />}
      {mode === 'chart' && <ReferenceChart entries={decks[deckKey]} />}
    </div>
  )
}

export default App
