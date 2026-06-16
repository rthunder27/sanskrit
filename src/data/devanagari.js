/**
 * Devanagari flashcard data.
 *
 * Each entry describes one Devanagari character and the information shown
 * on the back of its flashcard: a Latin transliteration (IAST), a plain
 * English pronunciation hint, and an example Sanskrit word that uses the
 * character along with its meaning.
 *
 * Currently covers the independent vowels and the 33 consonants. Other
 * character groups (e.g. conjuncts) can be appended as additional
 * arrays/entries later.
 */

/**
 * @typedef {Object} FlashcardEntry
 * @property {string} character - The Devanagari character (front of card).
 * @property {string} transliteration - IAST transliteration (back of card).
 * @property {string} pronunciation - Plain-English pronunciation hint.
 * @property {Object} example - An example word that uses the character.
 * @property {string} example.word - The example word in Devanagari.
 * @property {string} example.transliteration - IAST transliteration of the example word.
 * @property {string} example.meaning - English meaning of the example word.
 */

/** @type {FlashcardEntry[]} */
export const vowels = [
  {
    character: 'अ',
    transliteration: 'a',
    pronunciation: "like 'a' in 'about'",
    example: { word: 'अनार', transliteration: 'anār', meaning: 'pomegranate' },
  },
  {
    character: 'आ',
    transliteration: 'ā',
    pronunciation: "like 'a' in 'father'",
    example: { word: 'आम', transliteration: 'āma', meaning: 'mango' },
  },
  {
    character: 'इ',
    transliteration: 'i',
    pronunciation: "like 'i' in 'bit'",
    example: { word: 'इति', transliteration: 'iti', meaning: 'thus (a quotation marker)' },
  },
  {
    character: 'ई',
    transliteration: 'ī',
    pronunciation: "like 'ee' in 'feet'",
    example: { word: 'ईश', transliteration: 'īśa', meaning: 'lord' },
  },
  {
    character: 'उ',
    transliteration: 'u',
    pronunciation: "like 'u' in 'put'",
    example: { word: 'उदय', transliteration: 'udaya', meaning: 'rising/sunrise' },
  },
  {
    character: 'ऊ',
    transliteration: 'ū',
    pronunciation: "like 'oo' in 'pool'",
    example: { word: 'ऊन', transliteration: 'ūna', meaning: 'wool' },
  },
  {
    character: 'ऋ',
    transliteration: 'ṛ',
    pronunciation: "a rolled 'ri', like 'ri' in 'rip'",
    example: { word: 'ऋषि', transliteration: 'ṛṣi', meaning: 'sage' },
  },
  {
    character: 'ए',
    transliteration: 'e',
    pronunciation: "like 'ay' in 'play'",
    example: { word: 'एक', transliteration: 'eka', meaning: 'one' },
  },
  {
    character: 'ऐ',
    transliteration: 'ai',
    pronunciation: "like 'ai' in 'aisle'",
    example: { word: 'ऐरावत', transliteration: 'airāvata', meaning: "Indra's elephant" },
  },
  {
    character: 'ओ',
    transliteration: 'o',
    pronunciation: "like 'o' in 'go'",
    example: { word: 'ओम्', transliteration: 'om', meaning: 'sacred syllable Om' },
  },
  {
    character: 'औ',
    transliteration: 'au',
    pronunciation: "like 'ow' in 'cow'",
    example: { word: 'औषध', transliteration: 'auṣadha', meaning: 'medicine' },
  },
]

/** @type {FlashcardEntry[]} */
export const consonants = [
  {
    character: 'क',
    transliteration: 'ka',
    pronunciation: "like 'k' in 'skate'",
    example: { word: 'कमल', transliteration: 'kamala', meaning: 'lotus' },
  },
  {
    character: 'ख',
    transliteration: 'kha',
    pronunciation: "an aspirated 'k', like 'k' in 'kite'",
    example: { word: 'खग', transliteration: 'khaga', meaning: 'bird' },
  },
  {
    character: 'ग',
    transliteration: 'ga',
    pronunciation: "like 'g' in 'go'",
    example: { word: 'गज', transliteration: 'gaja', meaning: 'elephant' },
  },
  {
    character: 'घ',
    transliteration: 'gha',
    pronunciation: "an aspirated 'g'",
    example: { word: 'घण्टा', transliteration: 'ghaṇṭā', meaning: 'bell' },
  },
  {
    character: 'ङ',
    transliteration: 'ṅa',
    pronunciation: "like 'ng' in 'sing'",
    example: { word: 'रङ्ग', transliteration: 'raṅga', meaning: 'color' },
  },
  {
    character: 'च',
    transliteration: 'ca',
    pronunciation: "like 'ch' in 'chair'",
    example: { word: 'चन्द्र', transliteration: 'candra', meaning: 'moon' },
  },
  {
    character: 'छ',
    transliteration: 'cha',
    pronunciation: "an aspirated 'ch'",
    example: { word: 'छाया', transliteration: 'chāyā', meaning: 'shadow' },
  },
  {
    character: 'ज',
    transliteration: 'ja',
    pronunciation: "like 'j' in 'jar'",
    example: { word: 'जल', transliteration: 'jala', meaning: 'water' },
  },
  {
    character: 'झ',
    transliteration: 'jha',
    pronunciation: "an aspirated 'j'",
    example: { word: 'झष', transliteration: 'jhaṣa', meaning: 'fish' },
  },
  {
    character: 'ञ',
    transliteration: 'ña',
    pronunciation: "like 'ny' in 'canyon'",
    example: { word: 'पञ्च', transliteration: 'pañca', meaning: 'five' },
  },
  {
    character: 'ट',
    transliteration: 'ṭa',
    pronunciation: "a retroflex 't', tongue curled back",
    example: { word: 'टीका', transliteration: 'ṭīkā', meaning: 'commentary' },
  },
  {
    character: 'ठ',
    transliteration: 'ṭha',
    pronunciation: "an aspirated retroflex 't'",
    example: { word: 'पाठ', transliteration: 'pāṭha', meaning: 'lesson' },
  },
  {
    character: 'ड',
    transliteration: 'ḍa',
    pronunciation: "a retroflex 'd', tongue curled back",
    example: { word: 'डमरु', transliteration: 'ḍamaru', meaning: 'small hand drum' },
  },
  {
    character: 'ढ',
    transliteration: 'ḍha',
    pronunciation: "an aspirated retroflex 'd'",
    example: { word: 'ढाल', transliteration: 'ḍhāla', meaning: 'shield' },
  },
  {
    character: 'ण',
    transliteration: 'ṇa',
    pronunciation: "a retroflex 'n', tongue curled back",
    example: { word: 'गणेश', transliteration: 'gaṇeśa', meaning: 'Ganesha' },
  },
  {
    character: 'त',
    transliteration: 'ta',
    pronunciation: "a dental 't', tongue against the teeth",
    example: { word: 'तल', transliteration: 'tala', meaning: 'surface' },
  },
  {
    character: 'थ',
    transliteration: 'tha',
    pronunciation: "an aspirated dental 't'",
    example: { word: 'स्थान', transliteration: 'sthāna', meaning: 'place' },
  },
  {
    character: 'द',
    transliteration: 'da',
    pronunciation: "a dental 'd', tongue against the teeth",
    example: { word: 'दिन', transliteration: 'dina', meaning: 'day' },
  },
  {
    character: 'ध',
    transliteration: 'dha',
    pronunciation: "an aspirated dental 'd'",
    example: { word: 'धन', transliteration: 'dhana', meaning: 'wealth' },
  },
  {
    character: 'न',
    transliteration: 'na',
    pronunciation: "like 'n' in 'name'",
    example: { word: 'नाम', transliteration: 'nāma', meaning: 'name' },
  },
  {
    character: 'प',
    transliteration: 'pa',
    pronunciation: "like 'p' in 'spin'",
    example: { word: 'पुष्प', transliteration: 'puṣpa', meaning: 'flower' },
  },
  {
    character: 'फ',
    transliteration: 'pha',
    pronunciation: "an aspirated 'p', like 'p' in 'pin'",
    example: { word: 'फल', transliteration: 'phala', meaning: 'fruit' },
  },
  {
    character: 'ब',
    transliteration: 'ba',
    pronunciation: "like 'b' in 'bun'",
    example: { word: 'बल', transliteration: 'bala', meaning: 'strength' },
  },
  {
    character: 'भ',
    transliteration: 'bha',
    pronunciation: "an aspirated 'b'",
    example: { word: 'भूमि', transliteration: 'bhūmi', meaning: 'earth' },
  },
  {
    character: 'म',
    transliteration: 'ma',
    pronunciation: "like 'm' in 'mother'",
    example: { word: 'मन', transliteration: 'mana', meaning: 'mind' },
  },
  {
    character: 'य',
    transliteration: 'ya',
    pronunciation: "like 'y' in 'yes'",
    example: { word: 'योग', transliteration: 'yoga', meaning: 'union' },
  },
  {
    character: 'र',
    transliteration: 'ra',
    pronunciation: "a rolled/tapped 'r'",
    example: { word: 'राम', transliteration: 'rāma', meaning: 'Rama' },
  },
  {
    character: 'ल',
    transliteration: 'la',
    pronunciation: "like 'l' in 'love'",
    example: { word: 'लता', transliteration: 'latā', meaning: 'vine' },
  },
  {
    character: 'व',
    transliteration: 'va',
    pronunciation: "between 'v' and 'w'",
    example: { word: 'वायु', transliteration: 'vāyu', meaning: 'wind' },
  },
  {
    character: 'श',
    transliteration: 'śa',
    pronunciation: "like 'sh' in 'shine'",
    example: { word: 'शिव', transliteration: 'śiva', meaning: 'Shiva' },
  },
  {
    character: 'ष',
    transliteration: 'ṣa',
    pronunciation: "a retroflex 'sh'",
    example: { word: 'षट्', transliteration: 'ṣaṭ', meaning: 'six' },
  },
  {
    character: 'स',
    transliteration: 'sa',
    pronunciation: "like 's' in 'sun'",
    example: { word: 'सूर्य', transliteration: 'sūrya', meaning: 'sun' },
  },
  {
    character: 'ह',
    transliteration: 'ha',
    pronunciation: "like 'h' in 'house'",
    example: { word: 'हृदय', transliteration: 'hṛdaya', meaning: 'heart' },
  },
]

/** All vowels followed by all consonants, for a combined study session. @type {FlashcardEntry[]} */
export const all = [...vowels, ...consonants]

/**
 * All flashcard decks, keyed by name. The flashcard deck UI can use this to
 * let the user pick which set of characters to study.
 * @type {Record<string, FlashcardEntry[]>}
 */
export const decks = {
  vowels,
  consonants,
  all,
}

/**
 * @typedef {Object} CharGroup
 * @property {string} label - Display name for this group.
 * @property {FlashcardEntry[]} entries - Characters in the group.
 * @property {boolean} [paired] - When true, this group is displayed side-by-side
 *   with adjacent paired groups in the reference chart.
 */

/**
 * Consonants organised into their traditional Sanskrit grammatical groups
 * (vargas). The last two groups are marked `paired` so the chart can render
 * them side-by-side rather than as separate full-width rows.
 * @type {CharGroup[]}
 */
export const consonantGroups = [
  { label: 'Gutturals',   entries: consonants.slice(0, 5) },
  { label: 'Palatals',    entries: consonants.slice(5, 10) },
  { label: 'Retroflexes', entries: consonants.slice(10, 15) },
  { label: 'Dentals',     entries: consonants.slice(15, 20) },
  { label: 'Labials',     entries: consonants.slice(20, 25) },
  { label: 'Semivowels',  entries: consonants.slice(25, 29), paired: true },
  { label: 'Sibilants',   entries: consonants.slice(29, 33), paired: true },
]

/**
 * Groups to use in the reference chart for each deck. Vowels are a single
 * unlabelled group; consonants use the structured varga grouping; all
 * combines both.
 * @type {Record<string, CharGroup[]>}
 */
export const deckGroups = {
  vowels: [{ label: 'Vowels', entries: vowels }],
  consonants: consonantGroups,
  all: [{ label: 'Vowels', entries: vowels }, ...consonantGroups],
}
