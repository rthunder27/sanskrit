// A single flip card widget: character on the front, transliteration + example on the back.

import 'package:flutter/material.dart';
import '../data/devanagari.dart';

class FlashcardWidget extends StatelessWidget {
  final CardEntry entry;
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
      layoutBuilder: (currentChild, previousChildren) => Stack(
        alignment: Alignment.center,
        children: [
          ...previousChildren,
          ?currentChild,
        ],
      ),
      child: flipped
          ? _BackFace(key: const ValueKey('back'), entry: entry)
          : _FrontFace(key: const ValueKey('front'), entry: entry),
    );
  }
}

class _FrontFace extends StatelessWidget {
  final CardEntry entry;
  const _FrontFace({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      child: Text(
        entry.character,
        style: const TextStyle(fontSize: 96, height: 1.1),
      ),
    );
  }
}

class _BackFace extends StatelessWidget {
  final CardEntry entry;
  const _BackFace({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _CardShell(
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

class _CardShell extends StatelessWidget {
  final Widget child;

  const _CardShell({required this.child});

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
