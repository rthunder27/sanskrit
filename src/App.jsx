import FlashcardDeck from './components/FlashcardDeck'
import { decks } from './data/devanagari'
import './App.css'

/**
 * App
 *
 * Top-level component for the Sanskrit learning app. Currently renders the
 * Devanagari flashcard deck for the vowels; later this can grow to switch
 * between decks (vowels, consonants, ...) and other study modes (drawing
 * practice, pronunciation).
 */
function App() {
  return (
    <div className="app">
      <h1>Devanagari Flashcards</h1>
      <FlashcardDeck entries={decks.vowels} />
    </div>
  )
}

export default App
