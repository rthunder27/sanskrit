// Reference chart mode — displays all characters in traditional varga groupings.
// Semivowels and Sibilants render side-by-side (paired groups).

import 'package:flutter/material.dart';
import '../data/devanagari.dart';

class ChartScreen extends StatelessWidget {
  final List<CardGroup> groups;

  const ChartScreen({super.key, required this.groups});

  @override
  Widget build(BuildContext context) {
    // Collect consecutive paired groups into paired rows.
    final rows = <List<CardGroup>>[];
    var i = 0;
    while (i < groups.length) {
      if (groups[i].paired &&
          i + 1 < groups.length &&
          groups[i + 1].paired) {
        rows.add([groups[i], groups[i + 1]]);
        i += 2;
      } else {
        rows.add([groups[i]]);
        i++;
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: rows.map((rowGroups) {
          if (rowGroups.length == 2) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: rowGroups
                    .map((g) => Expanded(child: _GroupBlock(group: g)))
                    .toList(),
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _GroupBlock(group: rowGroups[0]),
          );
        }).toList(),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// A labeled block of character cells for one varga group.
// ---------------------------------------------------------------------------

class _GroupBlock extends StatelessWidget {
  final CardGroup group;

  const _GroupBlock({required this.group});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(group.label,
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.copyWith(color: Colors.grey[600])),
        const SizedBox(height: 4),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: group.entries.map((e) => _CharCell(entry: e)).toList(),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// A single character cell with tooltip showing transliteration.
// ---------------------------------------------------------------------------

class _CharCell extends StatelessWidget {
  final CardEntry entry;

  const _CharCell({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: '${entry.transliteration} — ${entry.pronunciation}',
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(entry.character, style: const TextStyle(fontSize: 28)),
            Text(entry.transliteration,
                style: const TextStyle(fontSize: 13, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
