// Browse mode — step through cards sequentially, flip to reveal, shuffle.

import 'package:flutter/material.dart';
import '../data/devanagari.dart';
import '../widgets/flashcard_widget.dart';

class BrowseScreen extends StatefulWidget {
  final List<CardEntry> entries;

  const BrowseScreen({super.key, required this.entries});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  late List<CardEntry> _deck;
  int _index = 0;
  bool _flipped = false;

  @override
  void initState() {
    super.initState();
    _deck = List.of(widget.entries);
  }

  @override
  void didUpdateWidget(BrowseScreen old) {
    super.didUpdateWidget(old);
    if (old.entries != widget.entries) {
      setState(() {
        _deck = List.of(widget.entries);
        _index = 0;
        _flipped = false;
      });
    }
  }

  /// Randomises the deck order with Fisher-Yates.
  void _shuffle() {
    final copy = List.of(_deck);
    for (int i = copy.length - 1; i > 0; i--) {
      final j = (DateTime.now().microsecond + i) % (i + 1);
      final tmp = copy[i];
      copy[i] = copy[j];
      copy[j] = tmp;
    }
    setState(() {
      _deck = copy;
      _index = 0;
      _flipped = false;
    });
  }

  void _prev() => setState(() {
        _index = (_index - 1 + _deck.length) % _deck.length;
        _flipped = false;
      });

  void _next() => setState(() {
        _index = (_index + 1) % _deck.length;
        _flipped = false;
      });

  @override
  Widget build(BuildContext context) {
    final entry = _deck[_index];
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('${_index + 1} / ${_deck.length}',
            style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () => setState(() => _flipped = !_flipped),
          child: FlashcardWidget(entry: entry, flipped: _flipped),
        ),
        const SizedBox(height: 8),
        const Text('Tap to flip', style: TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: _prev, child: const Text('← Prev')),
            const SizedBox(width: 12),
            ElevatedButton(onPressed: _next, child: const Text('Next →')),
            const SizedBox(width: 12),
            OutlinedButton(onPressed: _shuffle, child: const Text('Shuffle')),
          ],
        ),
      ],
    );
  }
}
