// A single flip card widget: character on the front, transliteration + example on the back.

import 'package:flutter/material.dart';
import '../data/devanagari.dart';

class FlashcardWidget extends StatelessWidget {
  /// The character data to display.
  final CardEntry entry;

  /// Whether the card is showing its back face.
  final bool flipped;

  const FlashcardWidget({
    super.key,
    required this.entry,
    required this.flipped,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) {
        final rotate = Tween(begin: 1.0, end: 0.0).animate(animation);
        return AnimatedBuilder(
          animation: rotate,
          builder: (_, c) => Transform(
            transform: Matrix4.rotationY((1 - rotate.value) * 3.14159),
            alignment: Alignment.center,
            child: c,
          ),
          child: child,
        );
      },
      child: flipped ? _BackFace(entry: entry) : _FrontFace(entry: entry),
    );
  }
}

// ---------------------------------------------------------------------------
// Front face — just the Devanagari character
// ---------------------------------------------------------------------------

class _FrontFace extends StatelessWidget {
  final CardEntry entry;
  const _FrontFace({required this.entry});

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      key: const ValueKey('front'),
      child: Text(
        entry.character,
        style: const TextStyle(fontSize: 96, height: 1.1),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Back face — transliteration, pronunciation, example
// ---------------------------------------------------------------------------

class _BackFace extends StatelessWidget {
  final CardEntry entry;
  const _BackFace({required this.entry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _CardShell(
      key: const ValueKey('back'),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(entry.transliteration,
              style: theme.textTheme.headlineMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(entry.pronunciation,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: Colors.grey[600])),
          const SizedBox(height: 16),
          Text(entry.example.word, style: const TextStyle(fontSize: 28)),
          Text('${entry.example.transliteration} — ${entry.example.meaning}',
              style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shared card shell
// ---------------------------------------------------------------------------

class _CardShell extends StatelessWidget {
  final Widget child;

  const _CardShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        width: 300,
        height: 220,
        child: Center(child: Padding(padding: const EdgeInsets.all(16), child: child)),
      ),
    );
  }
}
