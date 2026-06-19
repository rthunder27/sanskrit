// Quiz mode — swipe-based card queue.
// Swipe right / "Got it" → correct, card removed. Swipe left / "Missed" → wrong, moved to back.
// Tap card → flip.

import 'package:flutter/material.dart';
import '../data/devanagari.dart';
import '../widgets/flashcard_widget.dart';

const double _swipeThreshold = 80;
const double _dragThreshold = 8;

class QuizScreen extends StatefulWidget {
  final List<CardEntry> entries;

  const QuizScreen({super.key, required this.entries});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late List<CardEntry> _queue;
  bool _flipped = false;
  double _dragX = 0;
  bool _dragging = false;
  String? _flyingOut; // 'left' | 'right' | null
  bool _hasDragged = false;
  double _startX = 0;
  int _total = 0;
  bool _skipTransition = false;

  @override
  void initState() {
    super.initState();
    _reset();
  }

  @override
  void didUpdateWidget(QuizScreen old) {
    super.didUpdateWidget(old);
    if (old.entries != widget.entries) _reset();
  }

  void _reset() => setState(() {
        _queue = List.of(widget.entries);
        _total = _queue.length;
        _flipped = false;
        _dragX = 0;
        _flyingOut = null;
      });

  void _shuffle() {
    if (_flyingOut != null) return;
    final copy = List.of(_queue);
    for (int i = copy.length - 1; i > 0; i--) {
      final j = (DateTime.now().microsecond + i) % (i + 1);
      final tmp = copy[i];
      copy[i] = copy[j];
      copy[j] = tmp;
    }
    setState(() {
      _queue = copy;
      _flipped = false;
      _dragX = 0;
    });
  }

  /// Animate current card off-screen in [direction] then advance the queue.
  void _swipe(String direction) {
    if (_flyingOut != null) return;
    setState(() {
      _flyingOut = direction;
      _dragging = false;
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      setState(() {
        if (direction == 'right') {
          _queue = _queue.sublist(1);
        } else {
          _queue = [..._queue.sublist(1), _queue[0]];
        }
        _flipped = false;
        _dragX = 0;
        _flyingOut = null;
        _skipTransition = true;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _skipTransition = false);
      });
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
    if (_hasDragged) setState(() => _dragX = delta);
  }

  void _onPanEnd(DragEndDetails _) {
    if (_flyingOut != null) return;
    setState(() => _dragging = false);
    if (!_hasDragged) {
      setState(() => _flipped = !_flipped);
    } else if (_dragX.abs() > _swipeThreshold) {
      _swipe(_dragX > 0 ? 'right' : 'left');
    } else {
      setState(() => _dragX = 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_queue.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('All done! Every card answered correctly.',
                textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: _reset, child: const Text('Restart')),
          ],
        ),
      );
    }

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

    final wrongOpacity = ((-_dragX) / _swipeThreshold).clamp(0.0, 1.0);
    final rightOpacity = (_dragX / _swipeThreshold).clamp(0.0, 1.0);

    final done = _total - _queue.length;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('$done / $_total done · ${_queue.length} remaining',
            style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 8),
        // Wrong/Right labels above the card stage so they're never occluded.
        SizedBox(
          width: 320,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Opacity(
                opacity: wrongOpacity,
                child: const Text('Wrong',
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              ),
              Opacity(
                opacity: rightOpacity,
                child: const Text('Right',
                    style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        // Stage with overflow:hidden equivalent (ClipRect) to clip the exiting card.
        ClipRect(
          child: SizedBox(
            width: 320,
            height: 230,
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
                // Key on the entry forces a widget rebuild (and thus a fade-in
                // via AnimatedOpacity) whenever a new card reaches the front.
                child: AnimatedOpacity(
                  key: ValueKey(_queue[0].character),
                  opacity: _flyingOut != null ? 0.0 : 1.0,
                  duration: const Duration(milliseconds: 250),
                  child: FlashcardWidget(entry: _queue[0], flipped: _flipped),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Text('Tap to flip · swipe right if you knew it · swipe left if you didn\'t',
            style: TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red[100]),
              onPressed: () => _swipe('left'),
              child: const Text('Missed'),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green[100]),
              onPressed: () => _swipe('right'),
              child: const Text('Got it'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(onPressed: _shuffle, child: const Text('Shuffle')),
            const SizedBox(width: 12),
            OutlinedButton(onPressed: _reset, child: const Text('Reset')),
          ],
        ),
      ],
    );
  }
}
