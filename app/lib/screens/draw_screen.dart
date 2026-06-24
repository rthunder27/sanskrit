// Draw mode screen — four sub-modes plus a calibration tool.
// All characters in the current deck are available regardless of stroke data.

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../data/devanagari.dart';
import '../data/strokes.dart';
import '../db/database.dart';
import '../widgets/drawing_canvas.dart';
import '../widgets/drawing_painter.dart';

enum DrawSubMode { guided, unguided, freeDraw, memory }

class DrawScreen extends StatefulWidget {
  final List<CardEntry> entries;
  final AppDatabase db;

  const DrawScreen({super.key, required this.entries, required this.db});

  @override
  State<DrawScreen> createState() => _DrawScreenState();
}

class _DrawScreenState extends State<DrawScreen> {
  int _index = 0;
  DrawSubMode _subMode = DrawSubMode.guided;
  List<DrawnStroke> _strokes = [];
  int? _score;
  bool _memoryVisible = false;
  Timer? _memoryTimer;

  // Calibration state
  bool _calibrating = false;
  List<_CalMarker> _calMarkers = [];
  int? _selectedMarker;

  List<CardEntry> get _available => widget.entries;

  @override
  void didUpdateWidget(covariant DrawScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.entries != widget.entries) {
      _index = 0;
      _resetCanvas();
    }
  }

  @override
  void dispose() {
    _memoryTimer?.cancel();
    super.dispose();
  }

  CardEntry get _entry => _available[_index % _available.length];

  void _resetCanvas() {
    setState(() {
      _strokes = [];
      _score = null;
    });
  }

  void _goTo(int newIndex) {
    setState(() {
      _index = (newIndex + _available.length) % _available.length;
      _strokes = [];
      _score = null;
      _calMarkers = [];
      _selectedMarker = null;
    });
    if (_subMode == DrawSubMode.memory) _startMemoryFlash();
  }

  void _setSubMode(DrawSubMode mode) {
    setState(() {
      _subMode = mode;
      _strokes = [];
      _score = null;
    });
    if (mode == DrawSubMode.memory) _startMemoryFlash();
  }

  void _startMemoryFlash() {
    _memoryTimer?.cancel();
    setState(() => _memoryVisible = true);
    _memoryTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _memoryVisible = false);
    });
  }

  void _handleStrokeAdd(List<Offset> points) {
    if (_calibrating) {
      // In calibration mode, use the first point of the stroke as a marker
      final p = points.first;
      setState(() {
        final marker = _CalMarker(
          x: (p.dx * 100).round() / 100,
          y: (p.dy * 100).round() / 100,
          angle: 90,
        );
        _calMarkers.add(marker);
        _selectedMarker = _calMarkers.length - 1;
      });
      return;
    }
    setState(() {
      _strokes.add(DrawnStroke(points: points));
      _score = null;
    });
  }

  void _handleCheck() {
    if (_strokes.isEmpty) return;

    // Heuristic scoring based on stroke spread coverage
    double spreadScore = 0;
    for (final stroke in _strokes) {
      if (stroke.points.length < 2) continue;
      double minX = 1, maxX = 0, minY = 1, maxY = 0;
      for (final p in stroke.points) {
        if (p.dx < minX) minX = p.dx;
        if (p.dx > maxX) maxX = p.dx;
        if (p.dy < minY) minY = p.dy;
        if (p.dy > maxY) maxY = p.dy;
      }
      spreadScore += (maxX - minX) + (maxY - minY);
    }
    final normalizedSpread = (spreadScore / _strokes.length).clamp(0.0, 1.0);
    final coverage = (normalizedSpread * 100).round().clamp(0, 100);

    setState(() {
      _score = coverage;
      final pass = coverage >= 35;
      _strokes = _strokes
          .map((s) => DrawnStroke(
                points: s.points,
                color: pass ? Colors.green : Colors.red,
              ))
          .toList();
    });

    final subModeStr = _subMode.name;
    final record = widget.db.getDrawRecord(_entry.character, subModeStr);
    final updated = (record ?? DrawRecord(character: _entry.character, subMode: subModeStr))
      ..attemptCount += 1
      ..lastAttemptDay = todayEpochDay();
    if (_score! >= 35) updated.passCount += 1;
    final accuracy = _score! / 100;
    if (accuracy > updated.bestAccuracy) updated.bestAccuracy = accuracy;
    widget.db.upsertDrawRecord(updated);
  }

  void _calUndo() {
    if (_calMarkers.isEmpty) return;
    setState(() {
      _calMarkers.removeLast();
      if (_selectedMarker != null && _selectedMarker! >= _calMarkers.length) {
        _selectedMarker = _calMarkers.isEmpty ? null : _calMarkers.length - 1;
      }
    });
  }

  Future<void> _calSave() async {
    final char = _entry.character;
    final entry = {
      'character': char,
      'transliteration': _entry.transliteration,
      'strokes': _calMarkers
          .map((m) => {'x': m.x, 'y': m.y, 'angle': m.angle})
          .toList(),
    };

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/stroke_calibration.json');

    List<dynamic> existing = [];
    if (await file.exists()) {
      try {
        existing = jsonDecode(await file.readAsString()) as List<dynamic>;
      } catch (_) {
        existing = [];
      }
    }

    // Replace existing entry for this character, or append
    existing.removeWhere((e) => e['character'] == char);
    existing.add(entry);

    await file.writeAsString(const JsonEncoder.withIndent('  ').convert(existing));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Saved $char (${existing.length} total) → stroke_calibration.json'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _calShare() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/stroke_calibration.json');
    if (!await file.exists()) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No calibration data saved yet.')),
        );
      }
      return;
    }
    await Share.shareXFiles(
      [XFile(file.path)],
      text: 'Sanskrit stroke calibration data',
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_available.isEmpty) {
      return const Center(child: Text('No characters in the selected deck.'));
    }

    final character = _entry.character;
    final guides = strokeGuides[character];
    final showGuide = _calibrating || _subMode == DrawSubMode.guided || _subMode == DrawSubMode.unguided;
    final showArrows = !_calibrating && _subMode == DrawSubMode.guided;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Column(
          children: [
            // Sub-mode selector
            Wrap(
              spacing: 6,
              runSpacing: 6,
              alignment: WrapAlignment.center,
              children: DrawSubMode.values.map((m) {
                final labels = {
                  DrawSubMode.guided: 'Guided',
                  DrawSubMode.unguided: 'Unguided',
                  DrawSubMode.freeDraw: 'Free Draw',
                  DrawSubMode.memory: 'Memory',
                };
                final selected = m == _subMode;
                return ChoiceChip(
                  label: Text(labels[m]!),
                  selected: selected,
                  onSelected: _calibrating ? null : (_) => _setSubMode(m),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),

            // Character navigation
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => _goTo(_index - 1),
                ),
                Text(
                  '${_index + 1} / ${_available.length}',
                  style: const TextStyle(fontSize: 16),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () => _goTo(_index + 1),
                ),
              ],
            ),

            // Reference character (free draw / memory modes, not when calibrating)
            if (!_calibrating && _subMode == DrawSubMode.freeDraw)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(character, style: const TextStyle(fontSize: 72)),
              ),
            if (!_calibrating && _subMode == DrawSubMode.memory)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  _memoryVisible ? character : '?',
                  style: const TextStyle(fontSize: 72),
                ),
              ),

            // Transliteration label
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                _entry.transliteration,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[500],
                ),
              ),
            ),

            // Drawing canvas
            DrawingCanvas(
              character: character,
              showGuide: showGuide,
              showArrows: showArrows,
              guides: guides,
              strokes: _calibrating ? const [] : _strokes,
              onStrokeAdd: _handleStrokeAdd,
              calibrationMarkers: _calibrating ? _calMarkers : null,
            ),
            const SizedBox(height: 8),

            // Calibrate toggle
            TextButton(
              onPressed: () => setState(() {
                _calibrating = !_calibrating;
                if (_calibrating) {
                  _calMarkers = [];
                  _selectedMarker = null;
                }
              }),
              style: TextButton.styleFrom(
                foregroundColor: _calibrating ? Colors.red : Colors.grey,
              ),
              child: Text(_calibrating ? 'Exit Calibrate' : 'Calibrate'),
            ),

            // Calibration controls
            if (_calibrating) ...[
              Text(
                'Tap the canvas to place stroke-start markers.',
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              ),
              const SizedBox(height: 8),
              ..._calMarkers.asMap().entries.map((e) {
                final i = e.key;
                final m = e.value;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () => setState(() => _selectedMarker = i),
                        child: CircleAvatar(
                          radius: 12,
                          backgroundColor: _selectedMarker == i
                              ? Colors.red
                              : Colors.red.withValues(alpha: 0.6),
                          child: Text('${i + 1}',
                              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '(${m.x.toStringAsFixed(2)}, ${m.y.toStringAsFixed(2)})',
                        style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                      ),
                      SizedBox(
                        width: 120,
                        child: Slider(
                          min: 0,
                          max: 359,
                          value: m.angle.toDouble(),
                          onChanged: (v) => setState(() {
                            _calMarkers[i] = _CalMarker(x: m.x, y: m.y, angle: v.round());
                          }),
                        ),
                      ),
                      SizedBox(
                        width: 35,
                        child: Text('${m.angle}°',
                            style: const TextStyle(fontFamily: 'monospace', fontSize: 12)),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: _calMarkers.isEmpty ? null : _calUndo,
                    child: const Text('Undo'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _calMarkers.isEmpty ? null : _calSave,
                    child: const Text('Save'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _calShare,
                    child: const Text('Share'),
                  ),
                ],
              ),
            ],

            // Normal mode action buttons
            if (!_calibrating) ...[
              const SizedBox(height: 4),
              Wrap(
                spacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: _resetCanvas,
                    icon: const Icon(Icons.clear),
                    label: const Text('Clear'),
                  ),
                  ElevatedButton.icon(
                    onPressed: _strokes.isEmpty ? null : _handleCheck,
                    icon: const Icon(Icons.check),
                    label: const Text('Check'),
                  ),
                  if (_subMode == DrawSubMode.memory && !_memoryVisible)
                    ElevatedButton.icon(
                      onPressed: _startMemoryFlash,
                      icon: const Icon(Icons.visibility),
                      label: const Text('Show Again'),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              if (_score != null)
                Text(
                  'Coverage: $_score%',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: _score! >= 35 ? Colors.green : Colors.red,
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CalMarker {
  final double x;
  final double y;
  final int angle;
  const _CalMarker({required this.x, required this.y, required this.angle});
}
