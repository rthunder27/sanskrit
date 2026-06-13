# sanskrit
The purpose of this repo is to build an app to help one self-learn Sanskrit.

Features
1) Devanagari flash cards, learn how to identify and pronounce each letter. One side is just the character, the other has the english transliteration, phonetic pronunciation, and an example of it in a word.
2) Use the touch screen to practice drawing each character.
3) Learn pronunciation (maybe)

Perhaps vocab and grammar after exploring these features, definitely 1, probably 2, and maybe 3.

## Progress

- [x] Project scaffolded as a React + Vite web app
- [x] Devanagari flashcards (feature 1) — vowels and consonants, with a deck
      selector to switch between them
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
- `src/components/FlashcardDeck.jsx` — deck navigation (previous/next, card
  counter)
- `src/App.jsx` — top-level app, deck selector
