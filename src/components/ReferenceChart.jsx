import './ReferenceChart.css'

/**
 * ReferenceChart
 *
 * A static grid showing every character in the current deck alongside its
 * IAST transliteration and pronunciation hint. Intended as a quick visual
 * reference — no interaction, no quiz logic.
 *
 * @param {Object} props
 * @param {import('../data/devanagari').FlashcardEntry[]} props.entries - The deck to display.
 */
function ReferenceChart({ entries }) {
  return (
    <div className="reference-chart">
      {entries.map((entry) => (
        <div key={entry.character} className="reference-chart__cell">
          <span className="reference-chart__character">{entry.character}</span>
          <span className="reference-chart__transliteration">{entry.transliteration}</span>
          <span className="reference-chart__pronunciation">{entry.pronunciation}</span>
        </div>
      ))}
    </div>
  )
}

export default ReferenceChart
