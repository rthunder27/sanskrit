// Browse mode — step through cards with swipe animation, flip to reveal, shuffle.

import 'package:flutter/material.dart';
import '../data/devanagari.dart';
import '../widgets/flashcard_widget.dart';

const double _swipeThreshold = 80;
const double _dragThreshold = 8;

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
  double _dragX = 0;
  bool _dragging = false;
  String? _flyingOut;
  bool _hasDragged = false;
  double _startX = 0;
  bool _skipTransition = false;

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
        _dragX = 0;
        _flyingOut = null;
      });
    }
  }

  void _shuffle() {
    if (_flyingOut != null) return;
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
      _dragX = 0;
    });
  }

  void _goTo(int newIndex) {
    setState(() {
      _index = (newIndex + _deck.length) % _deck.length;
      _flipped = false;
    });
  }

  void _swipe(String direction) {
    if (_flyingOut != null) return;
    setState(() {
      _flyingOut = direction;
      _dragging = false;
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      setState(() {
        _index = direction == 'right'
            ? (_index + 1) % _deck.length
            : (_index - 1 + _deck.length) % _deck.length;
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
    final entry = _deck[_index];

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

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('${_index + 1} / ${_deck.length}',
            style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 16),
        ClipRect(
          child: SizedBox(
            width: 320,
            height: 230,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onPanStart: _onPanStart,
              onPanUpdate: _onPanUpdate,
              onPanEnd: _onPanEnd,
              child: AnimatedContainer(
                alignment: Alignment.center,
                duration: (_dragging || _skipTransition) && _flyingOut == null
                    ? Duration.zero
                    : const Duration(milliseconds: 300),
                transform: Matrix4.translationValues(translateX, 0, 0)
                  ..rotateZ(rotation),
                transformAlignment: Alignment.center,
                child: FlashcardWidget(entry: entry, flipped: _flipped),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Text('Tap to flip · swipe to navigate',
            style: TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: () => _goTo(_index - 1), child: const Text('← Prev')),
            const SizedBox(width: 12),
            ElevatedButton(onPressed: () => _goTo(_index + 1), child: const Text('Next →')),
            const SizedBox(width: 12),
            OutlinedButton(onPressed: _shuffle, child: const Text('Shuffle')),
          ],
        ),
      ],
    );
  }
}
