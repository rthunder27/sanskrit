// Review mode — SRS-based queue showing only cards due today.
// Uses SM-2 (see db/database.dart). Correct answers extend the interval; wrong answers reset it.
// Cards with no history are included as new cards.

import 'package:flutter/material.dart';
import '../data/devanagari.dart';
import '../db/database.dart';
import '../widgets/flashcard_widget.dart';

class ReviewScreen extends StatefulWidget {
  final List<CardEntry> entries;
  final AppDatabase db;

  const ReviewScreen({super.key, required this.entries, required this.db});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  late List<CardEntry> _dueCards;
  int _index = 0;
  bool _flipped = false;

  @override
  void initState() {
    super.initState();
    _loadDueCards();
  }

  @override
  void didUpdateWidget(ReviewScreen old) {
    super.didUpdateWidget(old);
    if (old.entries != widget.entries) {
      _index = 0;
      _flipped = false;
      _loadDueCards();
    }
  }

  void _loadDueCards() {
    final today = todayEpochDay();
    final due = widget.db.getDueCards(today);
    final dueChars = {for (final r in due) r.character};

    final seenChars = widget.db.getSeenCharacters();
    final newChars = widget.entries
        .where((e) => !seenChars.contains(e.character))
        .map((e) => e.character)
        .toSet();

    setState(() {
      _dueCards = widget.entries
          .where((e) => dueChars.contains(e.character) || newChars.contains(e.character))
          .toList();
    });
  }

  Future<void> _answer(bool correct) async {
    final entry = _dueCards[_index];
    final existing = widget.db.getRecord(entry.character);
    final updated = applyReview(existing, entry.character, correct);
    await widget.db.upsertRecord(updated);

    setState(() {
      if (_index + 1 < _dueCards.length) {
        _index++;
        _flipped = false;
      } else {
        _index = _dueCards.length;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_dueCards.isEmpty || _index >= _dueCards.length) {
      final done = _dueCards.isEmpty ? 0 : _index;
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _dueCards.isEmpty
                  ? 'No cards due for review today!'
                  : 'Review complete! $done card${done == 1 ? '' : 's'} reviewed.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _index = 0;
                  _flipped = false;
                });
                _loadDueCards();
              },
              child: const Text('Reload'),
            ),
          ],
        ),
      );
    }

    final entry = _dueCards[_index];
    final progress = '${_index + 1} / ${_dueCards.length}';

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Review — $progress',
            style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 16),
        SizedBox(
          width: 320,
          height: 230,
          child: Center(
            child: GestureDetector(
              onTap: () => setState(() => _flipped = !_flipped),
              child: FlashcardWidget(entry: entry, flipped: _flipped),
            ),
          ),
        ),
        const SizedBox(height: 8),
        if (!_flipped)
          const Text('Tap to reveal before answering',
              style: TextStyle(color: Colors.grey, fontSize: 12))
        else ...[
          const Text('Did you know it?',
              style: TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red[100]),
                onPressed: () => _answer(false),
                child: const Text('No'),
              ),
              const SizedBox(width: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green[100]),
                onPressed: () => _answer(true),
                child: const Text('Yes'),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
