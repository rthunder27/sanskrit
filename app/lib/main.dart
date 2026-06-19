// Sanskrit learning app entry point.
// State: deckKey (vowels/consonants/all) × modeIndex (Browse/Quiz/Chart/Review).
// Switching decks keeps the current mode. Review always uses the full card set.

import 'package:flutter/material.dart';
import 'data/devanagari.dart';
import 'db/database.dart';
import 'screens/browse_screen.dart';
import 'screens/quiz_screen.dart';
import 'screens/chart_screen.dart';
import 'screens/review_screen.dart';

const String appBuildId = '20250619d';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDatabase();
  runApp(const SanskritApp());
}

class SanskritApp extends StatelessWidget {
  const SanskritApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sanskrit',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF7C4DFF)),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7C4DFF),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      home: const _HomeShell(),
    );
  }
}

// ---------------------------------------------------------------------------
// Home shell — deck selector + bottom-nav tabs
// ---------------------------------------------------------------------------

class _HomeShell extends StatefulWidget {
  const _HomeShell();

  @override
  State<_HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<_HomeShell> {
  DeckKey _deckKey = DeckKey.all;
  int _modeIndex = 0;

  /// Single database instance shared across screens.
  final AppDatabase _db = AppDatabase();



  List<CardEntry> get _entries => deckEntries(_deckKey);
  List<CardGroup> get _groups => deckGroups[_deckKey]!;

  Widget _buildBody() => switch (_modeIndex) {
        0 => BrowseScreen(entries: _entries),
        1 => QuizScreen(entries: _entries),
        2 => ChartScreen(groups: _groups),
        3 => ReviewScreen(entries: _entries, db: _db),
        _ => const SizedBox.shrink(),
      };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sanskrit'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Text(appBuildId,
                style: TextStyle(fontSize: 10, color: Colors.grey[500])),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: _DeckSelector(
            selected: _deckKey,
            onChanged: (key) => setState(() => _deckKey = key),
          ),
        ),
      ),
      body: _buildBody(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _modeIndex,
        onDestinationSelected: (i) => setState(() => _modeIndex = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.library_books), label: 'Browse'),
          NavigationDestination(icon: Icon(Icons.quiz), label: 'Quiz'),
          NavigationDestination(icon: Icon(Icons.grid_view), label: 'Chart'),
          NavigationDestination(icon: Icon(Icons.repeat), label: 'Review'),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Deck selector (segmented button in app bar)
// ---------------------------------------------------------------------------

class _DeckSelector extends StatelessWidget {
  final DeckKey selected;
  final ValueChanged<DeckKey> onChanged;

  const _DeckSelector({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: SegmentedButton<DeckKey>(
        segments: const [
          ButtonSegment(value: DeckKey.vowels, label: Text('Vowels')),
          ButtonSegment(value: DeckKey.consonants, label: Text('Consonants')),
          ButtonSegment(value: DeckKey.all, label: Text('All')),
        ],
        selected: {selected},
        onSelectionChanged: (s) => onChanged(s.first),
        style: const ButtonStyle(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
        ),
      ),
    );
  }
}
