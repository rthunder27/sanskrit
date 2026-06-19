# sanskrit
The purpose of this repo is to build an app to help one self-learn Sanskrit.

Features
1) Devanagari flash cards, learn how to identify and pronounce each letter. One side is just the character, the other has the english transliteration, phonetic pronunciation, and an example of it in a word.
2) Use the touch screen to practice drawing each character.
3) Learn pronunciation (maybe)

Perhaps vocab and grammar after exploring these features, definitely 1, probably 2, and maybe 3.

## Progress

- [x] Project scaffolded as a React + Vite web app, deployed to GitHub Pages
- [x] Devanagari flashcards (feature 1):
  - Vowels and consonants decks, plus a combined "All" deck
  - **Browse mode** — step through cards with Previous/Next, flip to reveal,
    shuffle to randomize order
  - **Quiz mode** — swipe right if you knew it (removes the card), swipe left
    if you didn't (moves it to the back for another pass); tap to flip;
    fallback Missed/Got-it buttons also available; card clips off-screen on
    swipe and new card fades in from centre; Shuffle and Reset buttons to
    randomise the remaining queue or restore all cards in original order
  - **Chart mode** — structured reference grid: vowels split into simple
    vowels and diphthongs; consonants in labeled varga rows (Gutturals,
    Palatals, Retroflexes, Dentals, Labials) with Semivowels and Sibilants
    displayed side-by-side below
- [ ] Conjunct consonants (samyuktākṣara) — a curated deck of ~20-30 common
      conjunct ligatures; card front shows the conjunct, back shows which
      consonants combine to form it, transliteration, and example word
- [ ] Touch-screen character drawing practice (feature 2)
- [ ] Pronunciation practice (feature 3) — planned for a future native
      (e.g. Flutter) rebuild, since it needs microphone/audio APIs

## Getting started

### Requirements

This project uses Vite 4, which requires **Node 16 or later**. If your
system's glibc is older than 2.28 (e.g. Ubuntu 18.04), Node 18+ prebuilt
binaries won't run — use Node 16 via [nvm](https://github.com/nvm-sh/nvm):

```sh
nvm install 16
nvm use 16
```

A `.nvmrc` file is included, so `nvm use` will pick the right version
automatically.

### Setup

```sh
npm install
```

### Run the dev server

```sh
npm run dev
```

This starts Vite's dev server (default: http://localhost:5173) with hot
module reloading.

### Lint

```sh
npm run lint
```

### Build for production

```sh
npm run build
```

Outputs static files to `dist/`. Preview the production build with:

```sh
npm run preview
```

## Project structure

- `src/data/devanagari.js` — flashcard content (characters, transliteration,
  pronunciation hints, example words), organized into named decks
- `src/components/Flashcard.jsx` — single flip card component
- `src/components/FlashcardDeck.jsx` — Browse mode: deck navigation with
  previous/next and shuffle
- `src/components/FlashcardQuiz.jsx` — Quiz mode: swipe-based review queue
- `src/components/ReferenceChart.jsx` — Chart mode: static character grid
- `src/App.jsx` — top-level app, deck selector, mode switcher
