/**
 * Devanagari flashcard data.
 *
 * Each entry describes one Devanagari character and the information shown
 * on the back of its flashcard: a Latin transliteration (IAST), a plain
 * English pronunciation hint, and an example Sanskrit word that uses the
 * character along with its meaning.
 *
 * This starter set covers the independent vowels. Consonants and other
 * character groups can be appended as additional arrays/entries later.
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

/**
 * All flashcard decks, keyed by name. The flashcard deck UI can use this to
 * let the user pick which set of characters to study.
 * @type {Record<string, FlashcardEntry[]>}
 */
export const decks = {
  vowels,
}
