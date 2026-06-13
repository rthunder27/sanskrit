import './Flashcard.css'

/**
 * Flashcard
 *
 * Displays a single Devanagari flashcard. The front shows just the
 * character; the back shows its transliteration, pronunciation hint, and
 * an example word. Clicking the card toggles between the two faces.
 *
 * @param {Object} props
 * @param {import('../data/devanagari').FlashcardEntry} props.entry - The flashcard data to display.
 * @param {boolean} props.flipped - Whether the back face is currently shown.
 * @param {() => void} props.onFlip - Called when the card is clicked, to toggle the flip state.
 */
function Flashcard({ entry, flipped, onFlip }) {
  return (
    <div
      className={`flashcard ${flipped ? 'flashcard--flipped' : ''}`}
      onClick={onFlip}
      role="button"
      tabIndex={0}
      onKeyDown={(e) => {
        if (e.key === 'Enter' || e.key === ' ') onFlip()
      }}
      aria-label="Flashcard, click to flip"
    >
      <div className="flashcard__inner">
        <div className="flashcard__face flashcard__face--front">
          <span className="flashcard__character">{entry.character}</span>
        </div>
        <div className="flashcard__face flashcard__face--back">
          <span className="flashcard__transliteration">{entry.transliteration}</span>
          <span className="flashcard__pronunciation">{entry.pronunciation}</span>
          <div className="flashcard__example">
            <span className="flashcard__example-word">{entry.example.word}</span>
            <span className="flashcard__example-translit">{entry.example.transliteration}</span>
            <span className="flashcard__example-meaning">{entry.example.meaning}</span>
          </div>
        </div>
      </div>
    </div>
  )
}

export default Flashcard
