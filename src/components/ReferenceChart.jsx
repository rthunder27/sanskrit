import './ReferenceChart.css'

/**
 * CharCell
 *
 * A single cell in the reference chart showing the Devanagari character,
 * its IAST transliteration, and a short pronunciation hint.
 *
 * @param {Object} props
 * @param {import('../data/devanagari').FlashcardEntry} props.entry
 */
function CharCell({ entry }) {
  return (
    <div className="reference-chart__cell">
      <span className="reference-chart__character">{entry.character}</span>
      <span className="reference-chart__transliteration">{entry.transliteration}</span>
      <span className="reference-chart__pronunciation">{entry.pronunciation}</span>
    </div>
  )
}

/**
 * GroupRow
 *
 * Renders a labeled row of CharCells for a single character group.
 * The grid column count matches the number of entries so varga rows
 * always have exactly 5 columns.
 *
 * @param {Object} props
 * @param {import('../data/devanagari').CharGroup} props.group
 * @param {string} [props.className]
 */
function GroupRow({ group, className = '' }) {
  return (
    <section className={`reference-chart__group ${className}`}>
      <h3 className="reference-chart__group-label">{group.label}</h3>
      <div
        className="reference-chart__cells"
        style={{ gridTemplateColumns: `repeat(${group.entries.length}, 1fr)` }}
      >
        {group.entries.map((entry) => (
          <CharCell key={entry.character} entry={entry} />
        ))}
      </div>
    </section>
  )
}

/**
 * ReferenceChart
 *
 * A structured reference grid of Devanagari characters. Groups are rendered
 * as labeled rows; consecutive groups with `paired: true` are displayed
 * side-by-side rather than as separate full-width rows.
 *
 * @param {Object} props
 * @param {import('../data/devanagari').CharGroup[]} props.groups - Ordered list of character groups to display.
 */
function ReferenceChart({ groups }) {
  // Collect consecutive paired groups so they can be rendered side-by-side.
  const rows = []
  let i = 0
  while (i < groups.length) {
    if (groups[i].paired) {
      const paired = []
      while (i < groups.length && groups[i].paired) {
        paired.push(groups[i])
        i++
      }
      rows.push({ type: 'paired', groups: paired })
    } else {
      rows.push({ type: 'single', group: groups[i] })
      i++
    }
  }

  return (
    <div className="reference-chart">
      {rows.map((row, ri) =>
        row.type === 'single' ? (
          <GroupRow key={ri} group={row.group} />
        ) : (
          <div key={ri} className="reference-chart__paired-row">
            {row.groups.map((g) => (
              <GroupRow key={g.label} group={g} className="reference-chart__group--paired" />
            ))}
          </div>
        )
      )}
    </div>
  )
}

export default ReferenceChart
