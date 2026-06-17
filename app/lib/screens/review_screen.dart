// Review mode — SRS-based queue showing only cards due today.
// Uses SM-2 (see db/database.dart). Correct answers extend the interval; wrong answers reset it.
// Cards with no history are included as new cards.

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import '../data/devanagari.dart';
import '../db/database.dart';
import '../widgets/flashcard_widget.dart';

class ReviewScreen extends StatefulWidget {
  final List<CardEntry> allEntries;
  final AppDatabase db;

  const ReviewScreen({super.key, required this.allEntries, required this.db});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  List<CardEntry>? _dueCards;
  int _index = 0;
  bool _flipped = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadDueCards();
  }

  Future<void> _loadDueCards() async {
    final today = todayEpochDay();
    final due = await widget.db.getDueCards(today);
    final dueChars = {for (final r in due) r.character};

    // Include any card that has never been reviewed (not in DB yet).
    final allChars = {for (final e in widget.allEntries) e.character};
    final allRecords = await widget.db.getAllRecords();
    final seenChars = {for (final r in allRecords) r.character};
    final newChars = allChars.difference(seenChars);

    final dueEntries = widget.allEntries
        .where((e) => dueChars.contains(e.character) || newChars.contains(e.character))
        .toList();

    setState(() {
      _dueCards = dueEntries;
      _loading = false;
    });
  }

  Future<void> _answer(bool correct) async {
    final entry = _dueCards![_index];
    final existing = await widget.db.getRecord(entry.character);
    final updated = applyReview(existing, correct);
    await widget.db.upsertRecord(
      updated.copyWith(character: Value(entry.character)),
    );

    setState(() {
      if (_index + 1 < _dueCards!.length) {
        _index++;
        _flipped = false;
      } else {
        _index = _dueCards!.length; // signals completion
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_dueCards!.isEmpty || _index >= _dueCards!.length) {
      final done = _dueCards!.isEmpty ? 0 : _index;
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _dueCards!.isEmpty
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
                  _loading = true;
                });
                _loadDueCards();
              },
              child: const Text('Reload'),
            ),
          ],
        ),
      );
    }

    final entry = _dueCards![_index];
    final progress = '${_index + 1} / ${_dueCards!.length}';

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Review — $progress',
            style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () => setState(() => _flipped = !_flipped),
          child: FlashcardWidget(entry: entry, flipped: _flipped),
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
