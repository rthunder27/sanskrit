// Review mode — SRS-based queue showing only cards due today.
// Swipe right = Yes, swipe left = No (when flipped). Tap to flip.

import 'package:flutter/material.dart';
import '../data/devanagari.dart';
import '../db/database.dart';
import '../widgets/flashcard_widget.dart';

const double _swipeThreshold = 80;
const double _dragThreshold = 8;

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
  double _dragX = 0;
  bool _dragging = false;
  String? _flyingOut;
  bool _hasDragged = false;
  double _startX = 0;
  bool _skipTransition = false;

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
      _dragX = 0;
      _flyingOut = null;
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
      _flyingOut = null;
      _dragging = false;
      if (_index + 1 < _dueCards.length) {
        _index++;
        _flipped = false;
        _dragX = 0;
        _skipTransition = true;
      } else {
        _index = _dueCards.length;
      }
    });
    if (_skipTransition) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _skipTransition = false);
      });
    }
  }

  void _swipeAnswer(String direction) {
    if (_flyingOut != null) return;
    setState(() {
      _flyingOut = direction;
      _dragging = false;
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      _answer(direction == 'right');
    });
  }

  void _onPanStart(DragStartDetails d) {
    if (_flyingOut != null) return;
    _startX = d.globalPosition.dx;
    _hasDragged = false;
    _dragging = true;
  }

  void _onPanUpdate(DragUpdateDetails d) {
    if (!_dragging || _flyingOut != null) return;
    final delta = d.globalPosition.dx - _startX;
    if (delta.abs() > _dragThreshold) _hasDragged = true;
    if (_hasDragged && _flipped) setState(() => _dragX = delta);
  }

  void _onPanEnd(DragEndDetails _) {
    if (_flyingOut != null) return;
    setState(() => _dragging = false);
    if (!_hasDragged) {
      setState(() => _flipped = !_flipped);
    } else if (_flipped && _dragX.abs() > _swipeThreshold) {
      _swipeAnswer(_dragX > 0 ? 'right' : 'left');
    } else {
      setState(() => _dragX = 0);
    }
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
                  _dragX = 0;
                  _flyingOut = null;
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

    final double translateX = _flyingOut == 'right'
        ? 500
        : _flyingOut == 'left'
            ? -500
            : _dragX;
    final double rotation = (_flyingOut != null
            ? (_flyingOut == 'right' ? 160.0 : -160.0)
            : _dragX) *
        0.0008 *
        3.14159;

    final wrongOpacity = _flipped ? ((-_dragX) / _swipeThreshold).clamp(0.0, 1.0) : 0.0;
    final rightOpacity = _flipped ? (_dragX / _swipeThreshold).clamp(0.0, 1.0) : 0.0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Review — $progress',
            style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 8),
        SizedBox(
          width: 320,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Opacity(
                opacity: wrongOpacity,
                child: const Text('No',
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              ),
              Opacity(
                opacity: rightOpacity,
                child: const Text('Yes',
                    style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        ClipRect(
          child: SizedBox(
            width: 320,
            height: 230,
            child: Center(
              child: GestureDetector(
                onPanStart: _onPanStart,
                onPanUpdate: _onPanUpdate,
                onPanEnd: _onPanEnd,
                child: AnimatedContainer(
                  duration: (_dragging || _skipTransition) && _flyingOut == null
                      ? Duration.zero
                      : const Duration(milliseconds: 300),
                  transform: Matrix4.identity()
                    ..translateByDouble(translateX, 0.0, 0.0, 1.0)
                    ..rotateZ(rotation),
                  transformAlignment: Alignment.center,
                  child: FlashcardWidget(entry: entry, flipped: _flipped),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _flipped
              ? 'Swipe right = Yes · swipe left = No'
              : 'Tap to reveal before answering',
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
        const SizedBox(height: 16),
        if (_flipped)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red[100]),
                onPressed: () => _swipeAnswer('left'),
                child: const Text('No'),
              ),
              const SizedBox(width: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green[100]),
                onPressed: () => _swipeAnswer('right'),
                child: const Text('Yes'),
              ),
            ],
          ),
      ],
    );
  }
}
