// All Devanagari character data: vowels, consonants, and their groupings.
// Each CardEntry matches the web app's FlashcardEntry structure so the two
// implementations stay in sync. Groups follow traditional Sanskrit varga order.

/// A single flashcard character with pronunciation metadata.
class CardEntry {
  final String character;
  final String transliteration;
  final String pronunciation;
  final ExampleWord example;

  const CardEntry({
    required this.character,
    required this.transliteration,
    required this.pronunciation,
    required this.example,
  });
}

/// An example word demonstrating a character's use.
class ExampleWord {
  final String word;
  final String transliteration;
  final String meaning;

  const ExampleWord({
    required this.word,
    required this.transliteration,
    required this.meaning,
  });
}

/// A labeled group of characters for chart and deck organisation.
class CardGroup {
  final String label;
  final List<CardEntry> entries;

  /// When true the group renders side-by-side with adjacent paired groups
  /// (used for Semivowels and Sibilants in the reference chart).
  final bool paired;

  const CardGroup({
    required this.label,
    required this.entries,
    this.paired = false,
  });
}

// ---------------------------------------------------------------------------
// Vowels
// ---------------------------------------------------------------------------

const List<CardEntry> vowels = [
  CardEntry(
    character: 'अ',
    transliteration: 'a',
    pronunciation: 'like "u" in "but"',
    example: ExampleWord(word: 'अब', transliteration: 'aba', meaning: 'now'),
  ),
  CardEntry(
    character: 'आ',
    transliteration: 'ā',
    pronunciation: 'like "a" in "father"',
    example: ExampleWord(word: 'आम', transliteration: 'āma', meaning: 'mango'),
  ),
  CardEntry(
    character: 'इ',
    transliteration: 'i',
    pronunciation: 'like "i" in "bit"',
    example: ExampleWord(word: 'इति', transliteration: 'iti', meaning: 'thus'),
  ),
  CardEntry(
    character: 'ई',
    transliteration: 'ī',
    pronunciation: 'like "ee" in "see"',
    example: ExampleWord(word: 'ईश', transliteration: 'īśa', meaning: 'lord'),
  ),
  CardEntry(
    character: 'उ',
    transliteration: 'u',
    pronunciation: 'like "u" in "put"',
    example: ExampleWord(word: 'उप', transliteration: 'upa', meaning: 'near'),
  ),
  CardEntry(
    character: 'ऊ',
    transliteration: 'ū',
    pronunciation: 'like "oo" in "food"',
    example: ExampleWord(word: 'ऊर्जा', transliteration: 'ūrjā', meaning: 'energy'),
  ),
  CardEntry(
    character: 'ऋ',
    transliteration: 'ṛ',
    pronunciation: 'vocalic r, like "ri" in "river"',
    example: ExampleWord(word: 'ऋषि', transliteration: 'ṛṣi', meaning: 'sage'),
  ),
  CardEntry(
    character: 'ए',
    transliteration: 'e',
    pronunciation: 'like "a" in "gate"',
    example: ExampleWord(word: 'एक', transliteration: 'eka', meaning: 'one'),
  ),
  CardEntry(
    character: 'ऐ',
    transliteration: 'ai',
    pronunciation: 'like "ai" in "aisle"',
    example: ExampleWord(word: 'ऐश्वर्य', transliteration: 'aiśvarya', meaning: 'prosperity'),
  ),
  CardEntry(
    character: 'ओ',
    transliteration: 'o',
    pronunciation: 'like "o" in "go"',
    example: ExampleWord(word: 'ओम', transliteration: 'om', meaning: 'sacred syllable'),
  ),
  CardEntry(
    character: 'औ',
    transliteration: 'au',
    pronunciation: 'like "ow" in "cow"',
    example: ExampleWord(word: 'औषध', transliteration: 'auṣadha', meaning: 'medicine'),
  ),
];

// ---------------------------------------------------------------------------
// Consonants (traditional varga order)
// ---------------------------------------------------------------------------

const List<CardEntry> consonants = [
  // Gutturals (kaṇṭhya)
  CardEntry(character: 'क', transliteration: 'ka', pronunciation: 'like "k" in "skip"', example: ExampleWord(word: 'कमल', transliteration: 'kamala', meaning: 'lotus')),
  CardEntry(character: 'ख', transliteration: 'kha', pronunciation: 'aspirated k', example: ExampleWord(word: 'खग', transliteration: 'khaga', meaning: 'bird')),
  CardEntry(character: 'ग', transliteration: 'ga', pronunciation: 'like "g" in "go"', example: ExampleWord(word: 'गज', transliteration: 'gaja', meaning: 'elephant')),
  CardEntry(character: 'घ', transliteration: 'gha', pronunciation: 'aspirated g', example: ExampleWord(word: 'घर', transliteration: 'ghara', meaning: 'house')),
  CardEntry(character: 'ङ', transliteration: 'ṅa', pronunciation: 'like "ng" in "sing"', example: ExampleWord(word: 'अङ्क', transliteration: 'aṅka', meaning: 'number')),
  // Palatals (tālavya)
  CardEntry(character: 'च', transliteration: 'ca', pronunciation: 'like "ch" in "church"', example: ExampleWord(word: 'चन्द्र', transliteration: 'candra', meaning: 'moon')),
  CardEntry(character: 'छ', transliteration: 'cha', pronunciation: 'aspirated ch', example: ExampleWord(word: 'छत्र', transliteration: 'chatra', meaning: 'umbrella')),
  CardEntry(character: 'ज', transliteration: 'ja', pronunciation: 'like "j" in "jump"', example: ExampleWord(word: 'जल', transliteration: 'jala', meaning: 'water')),
  CardEntry(character: 'झ', transliteration: 'jha', pronunciation: 'aspirated j', example: ExampleWord(word: 'झरना', transliteration: 'jharanā', meaning: 'waterfall')),
  CardEntry(character: 'ञ', transliteration: 'ña', pronunciation: 'like "ny" in "canyon"', example: ExampleWord(word: 'ज्ञान', transliteration: 'jñāna', meaning: 'knowledge')),
  // Retroflexes (mūrdhanya)
  CardEntry(character: 'ट', transliteration: 'ṭa', pronunciation: 'retroflex t (tongue tip curled back)', example: ExampleWord(word: 'टमाटर', transliteration: 'ṭamāṭara', meaning: 'tomato')),
  CardEntry(character: 'ठ', transliteration: 'ṭha', pronunciation: 'aspirated retroflex t', example: ExampleWord(word: 'ठाकुर', transliteration: 'ṭhākura', meaning: 'lord')),
  CardEntry(character: 'ड', transliteration: 'ḍa', pronunciation: 'retroflex d', example: ExampleWord(word: 'डमरू', transliteration: 'ḍamarū', meaning: 'small drum')),
  CardEntry(character: 'ढ', transliteration: 'ḍha', pronunciation: 'aspirated retroflex d', example: ExampleWord(word: 'ढोल', transliteration: 'ḍhola', meaning: 'drum')),
  CardEntry(character: 'ण', transliteration: 'ṇa', pronunciation: 'retroflex n', example: ExampleWord(word: 'गण', transliteration: 'gaṇa', meaning: 'group')),
  // Dentals (dantya)
  CardEntry(character: 'त', transliteration: 'ta', pronunciation: 'dental t (tongue at teeth)', example: ExampleWord(word: 'तारा', transliteration: 'tārā', meaning: 'star')),
  CardEntry(character: 'थ', transliteration: 'tha', pronunciation: 'aspirated dental t', example: ExampleWord(word: 'थाली', transliteration: 'thālī', meaning: 'plate')),
  CardEntry(character: 'द', transliteration: 'da', pronunciation: 'dental d', example: ExampleWord(word: 'दिन', transliteration: 'dina', meaning: 'day')),
  CardEntry(character: 'ध', transliteration: 'dha', pronunciation: 'aspirated dental d', example: ExampleWord(word: 'धर्म', transliteration: 'dharma', meaning: 'duty/law')),
  CardEntry(character: 'न', transliteration: 'na', pronunciation: 'like "n" in "name"', example: ExampleWord(word: 'नाम', transliteration: 'nāma', meaning: 'name')),
  // Labials (oṣṭhya)
  CardEntry(character: 'प', transliteration: 'pa', pronunciation: 'like "p" in "spin"', example: ExampleWord(word: 'पद', transliteration: 'pada', meaning: 'word/foot')),
  CardEntry(character: 'फ', transliteration: 'pha', pronunciation: 'aspirated p', example: ExampleWord(word: 'फल', transliteration: 'phala', meaning: 'fruit')),
  CardEntry(character: 'ब', transliteration: 'ba', pronunciation: 'like "b" in "boy"', example: ExampleWord(word: 'बल', transliteration: 'bala', meaning: 'strength')),
  CardEntry(character: 'भ', transliteration: 'bha', pronunciation: 'aspirated b', example: ExampleWord(word: 'भव', transliteration: 'bhava', meaning: 'becoming')),
  CardEntry(character: 'म', transliteration: 'ma', pronunciation: 'like "m" in "man"', example: ExampleWord(word: 'मन', transliteration: 'mana', meaning: 'mind')),
  // Semivowels (antaḥstha)
  CardEntry(character: 'य', transliteration: 'ya', pronunciation: 'like "y" in "yes"', example: ExampleWord(word: 'यज्ञ', transliteration: 'yajña', meaning: 'ritual')),
  CardEntry(character: 'र', transliteration: 'ra', pronunciation: 'like "r" in "run"', example: ExampleWord(word: 'राज', transliteration: 'rāja', meaning: 'king')),
  CardEntry(character: 'ल', transliteration: 'la', pronunciation: 'like "l" in "love"', example: ExampleWord(word: 'लोक', transliteration: 'loka', meaning: 'world')),
  CardEntry(character: 'व', transliteration: 'va', pronunciation: 'between "v" and "w"', example: ExampleWord(word: 'वन', transliteration: 'vana', meaning: 'forest')),
  // Sibilants (ūṣman)
  CardEntry(character: 'श', transliteration: 'śa', pronunciation: 'palatal sh, like "sh" in "ship"', example: ExampleWord(word: 'शक्ति', transliteration: 'śakti', meaning: 'power')),
  CardEntry(character: 'ष', transliteration: 'ṣa', pronunciation: 'retroflex sh', example: ExampleWord(word: 'षट्', transliteration: 'ṣaṭ', meaning: 'six')),
  CardEntry(character: 'स', transliteration: 'sa', pronunciation: 'like "s" in "sun"', example: ExampleWord(word: 'सत्य', transliteration: 'satya', meaning: 'truth')),
  CardEntry(character: 'ह', transliteration: 'ha', pronunciation: 'like "h" in "house"', example: ExampleWord(word: 'हस्त', transliteration: 'hasta', meaning: 'hand')),
];

// ---------------------------------------------------------------------------
// Conjunct consonants (samyuktākṣara)
// ---------------------------------------------------------------------------

const List<CardEntry> conjuncts = [
  CardEntry(character: 'क्ष', transliteration: 'kṣa', pronunciation: 'क् (k) + ष (ṣ)', example: ExampleWord(word: 'राक्षस', transliteration: 'rākṣasa', meaning: 'demon')),
  CardEntry(character: 'ज्ञ', transliteration: 'jña', pronunciation: 'ज् (j) + ञ (ñ)', example: ExampleWord(word: 'यज्ञ', transliteration: 'yajña', meaning: 'sacrifice')),
  CardEntry(character: 'श्र', transliteration: 'śra', pronunciation: 'श् (ś) + र (r)', example: ExampleWord(word: 'श्रुति', transliteration: 'śruti', meaning: 'scripture')),
  CardEntry(character: 'त्र', transliteration: 'tra', pronunciation: 'त् (t) + र (r)', example: ExampleWord(word: 'मित्र', transliteration: 'mitra', meaning: 'friend')),
  CardEntry(character: 'क्त', transliteration: 'kta', pronunciation: 'क् (k) + त (t)', example: ExampleWord(word: 'भक्ति', transliteration: 'bhakti', meaning: 'devotion')),
  CardEntry(character: 'स्त', transliteration: 'sta', pronunciation: 'स् (s) + त (t)', example: ExampleWord(word: 'नमस्ते', transliteration: 'namaste', meaning: 'greeting of respect')),
  CardEntry(character: 'स्थ', transliteration: 'stha', pronunciation: 'स् (s) + थ (th)', example: ExampleWord(word: 'स्थान', transliteration: 'sthāna', meaning: 'place')),
  CardEntry(character: 'न्त', transliteration: 'nta', pronunciation: 'न् (n) + त (t)', example: ExampleWord(word: 'शान्ति', transliteration: 'śānti', meaning: 'peace')),
  CardEntry(character: 'न्द', transliteration: 'nda', pronunciation: 'न् (n) + द (d)', example: ExampleWord(word: 'आनन्द', transliteration: 'ānanda', meaning: 'bliss')),
  CardEntry(character: 'न्ध', transliteration: 'ndha', pronunciation: 'न् (n) + ध (dh)', example: ExampleWord(word: 'बन्ध', transliteration: 'bandha', meaning: 'bond')),
  CardEntry(character: 'ण्ड', transliteration: 'ṇḍa', pronunciation: 'ण् (ṇ) + ड (ḍ)', example: ExampleWord(word: 'खण्ड', transliteration: 'khaṇḍa', meaning: 'section')),
  CardEntry(character: 'ङ्ग', transliteration: 'ṅga', pronunciation: 'ङ् (ṅ) + ग (g)', example: ExampleWord(word: 'अङ्ग', transliteration: 'aṅga', meaning: 'limb')),
  CardEntry(character: 'ञ्च', transliteration: 'ñca', pronunciation: 'ञ् (ñ) + च (c)', example: ExampleWord(word: 'पञ्च', transliteration: 'pañca', meaning: 'five')),
  CardEntry(character: 'ष्ट', transliteration: 'ṣṭa', pronunciation: 'ष् (ṣ) + ट (ṭ)', example: ExampleWord(word: 'कष्ट', transliteration: 'kaṣṭa', meaning: 'hardship')),
  CardEntry(character: 'द्ध', transliteration: 'ddha', pronunciation: 'द् (d) + ध (dh)', example: ExampleWord(word: 'बुद्ध', transliteration: 'buddha', meaning: 'awakened one')),
  CardEntry(character: 'द्य', transliteration: 'dya', pronunciation: 'द् (d) + य (y)', example: ExampleWord(word: 'विद्या', transliteration: 'vidyā', meaning: 'knowledge')),
  CardEntry(character: 'त्त', transliteration: 'tta', pronunciation: 'त् (t) + त (t)', example: ExampleWord(word: 'चित्त', transliteration: 'citta', meaning: 'mind')),
  CardEntry(character: 'प्र', transliteration: 'pra', pronunciation: 'प् (p) + र (r)', example: ExampleWord(word: 'प्रकाश', transliteration: 'prakāśa', meaning: 'light')),
  CardEntry(character: 'ब्र', transliteration: 'bra', pronunciation: 'ब् (b) + र (r)', example: ExampleWord(word: 'ब्रह्मन्', transliteration: 'brahman', meaning: 'the absolute')),
  CardEntry(character: 'ग्र', transliteration: 'gra', pronunciation: 'ग् (g) + र (r)', example: ExampleWord(word: 'ग्राम', transliteration: 'grāma', meaning: 'village')),
  CardEntry(character: 'द्र', transliteration: 'dra', pronunciation: 'द् (d) + र (r)', example: ExampleWord(word: 'इन्द्र', transliteration: 'indra', meaning: 'king of gods')),
  CardEntry(character: 'स्व', transliteration: 'sva', pronunciation: 'स् (s) + व (v)', example: ExampleWord(word: 'स्वर', transliteration: 'svara', meaning: 'sound')),
  CardEntry(character: 'त्व', transliteration: 'tva', pronunciation: 'त् (t) + व (v)', example: ExampleWord(word: 'तत्त्व', transliteration: 'tattva', meaning: 'truth/element')),
  CardEntry(character: 'द्व', transliteration: 'dva', pronunciation: 'द् (d) + व (v)', example: ExampleWord(word: 'द्वार', transliteration: 'dvāra', meaning: 'door')),
  CardEntry(character: 'श्व', transliteration: 'śva', pronunciation: 'श् (ś) + व (v)', example: ExampleWord(word: 'अश्व', transliteration: 'aśva', meaning: 'horse')),
];

// ---------------------------------------------------------------------------
// Combined deck
// ---------------------------------------------------------------------------

final List<CardEntry> all = [...vowels, ...consonants];

// ---------------------------------------------------------------------------
// Named decks
// ---------------------------------------------------------------------------

/// All available deck identifiers.
enum DeckKey { vowels, consonants, conjuncts, all }

/// Returns the flat entry list for a given deck.
List<CardEntry> deckEntries(DeckKey key) => switch (key) {
      DeckKey.vowels => vowels,
      DeckKey.consonants => consonants,
      DeckKey.conjuncts => conjuncts,
      DeckKey.all => all,
    };

// ---------------------------------------------------------------------------
// Groups (for reference chart)
// ---------------------------------------------------------------------------

// List indexing is not a const expression in Dart, so these are final.
final List<CardGroup> vowelGroups = [
  CardGroup(label: 'Simple vowels', entries: vowels.sublist(0, 7)),
  CardGroup(label: 'Diphthongs',    entries: vowels.sublist(7)),
];

final List<CardGroup> consonantGroups = [
  CardGroup(label: 'Gutturals',   entries: consonants.sublist(0, 5)),
  CardGroup(label: 'Palatals',    entries: consonants.sublist(5, 10)),
  CardGroup(label: 'Retroflexes', entries: consonants.sublist(10, 15)),
  CardGroup(label: 'Dentals',     entries: consonants.sublist(15, 20)),
  CardGroup(label: 'Labials',     entries: consonants.sublist(20, 25)),
  CardGroup(label: 'Semivowels',  entries: consonants.sublist(25, 29), paired: true),
  CardGroup(label: 'Sibilants',   entries: consonants.sublist(29, 33), paired: true),
];

final List<CardGroup> conjunctGroups = [
  CardGroup(label: 'Special ligatures',  entries: conjuncts.sublist(0, 2)),
  CardGroup(label: 'Sub-र ligatures',    entries: [conjuncts[3], conjuncts[2], conjuncts[17], conjuncts[18], conjuncts[19], conjuncts[20]]),
  CardGroup(label: 'Sibilant clusters',  entries: [conjuncts[5], conjuncts[6], conjuncts[21], conjuncts[13], conjuncts[24]]),
  CardGroup(label: 'Nasal clusters',     entries: [conjuncts[7], conjuncts[8], conjuncts[9], conjuncts[10], conjuncts[11], conjuncts[12]]),
  CardGroup(label: 'Other clusters',     entries: [conjuncts[4], conjuncts[14], conjuncts[15], conjuncts[16], conjuncts[22], conjuncts[23]]),
];

final Map<DeckKey, List<CardGroup>> deckGroups = {
  DeckKey.vowels:     vowelGroups,
  DeckKey.consonants: consonantGroups,
  DeckKey.conjuncts:  conjunctGroups,
  DeckKey.all:        [...vowelGroups, ...consonantGroups],
};
