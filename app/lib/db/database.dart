// Local persistence for SRS review history using Hive (pure Dart, no native deps).
// Schema: one ReviewRecord per card, tracks SM-2 state and mastery level.

import 'package:hive_flutter/hive_flutter.dart';

const String _boxName = 'review_records';

/// Initialises Hive storage. Call once at app start before accessing the DB.
Future<void> initDatabase() async {
  await Hive.initFlutter();
  await Hive.openBox<Map>(_boxName);
}

// ---------------------------------------------------------------------------
// ReviewRecord — plain Dart class, serialised as Map in Hive
// ---------------------------------------------------------------------------

class ReviewRecord {
  final String character;
  double easeFactor;
  int intervalDays;
  int nextReviewDay;
  int correctCount;
  int incorrectCount;
  int masteryLevel;

  ReviewRecord({
    required this.character,
    this.easeFactor = 2.5,
    this.intervalDays = 1,
    this.nextReviewDay = 0,
    this.correctCount = 0,
    this.incorrectCount = 0,
    this.masteryLevel = 0,
  });

  factory ReviewRecord.fromMap(String character, Map map) => ReviewRecord(
        character: character,
        easeFactor: (map['easeFactor'] as num?)?.toDouble() ?? 2.5,
        intervalDays: map['intervalDays'] as int? ?? 1,
        nextReviewDay: map['nextReviewDay'] as int? ?? 0,
        correctCount: map['correctCount'] as int? ?? 0,
        incorrectCount: map['incorrectCount'] as int? ?? 0,
        masteryLevel: map['masteryLevel'] as int? ?? 0,
      );

  Map<String, dynamic> toMap() => {
        'easeFactor': easeFactor,
        'intervalDays': intervalDays,
        'nextReviewDay': nextReviewDay,
        'correctCount': correctCount,
        'incorrectCount': incorrectCount,
        'masteryLevel': masteryLevel,
      };
}

// ---------------------------------------------------------------------------
// Database access
// ---------------------------------------------------------------------------

class AppDatabase {
  Box<Map> get _box => Hive.box<Map>(_boxName);

  /// Returns all cards whose [nextReviewDay] is on or before [todayEpochDay].
  List<ReviewRecord> getDueCards(int todayEpochDay) {
    final results = <ReviewRecord>[];
    for (final key in _box.keys) {
      final map = _box.get(key);
      if (map != null) {
        final record = ReviewRecord.fromMap(key as String, map);
        if (record.nextReviewDay <= todayEpochDay) {
          results.add(record);
        }
      }
    }
    return results;
  }

  /// Returns the review record for [character], or null if never reviewed.
  ReviewRecord? getRecord(String character) {
    final map = _box.get(character);
    return map == null ? null : ReviewRecord.fromMap(character, map);
  }

  /// Upserts a review record.
  Future<void> upsertRecord(ReviewRecord record) =>
      _box.put(record.character, record.toMap());

  /// Returns all review records.
  List<ReviewRecord> getAllRecords() => _box.keys
      .map((k) => ReviewRecord.fromMap(k as String, _box.get(k)!))
      .toList();

  /// Returns the set of all characters that have been reviewed.
  Set<String> getSeenCharacters() =>
      _box.keys.cast<String>().toSet();
}

// ---------------------------------------------------------------------------
// SM-2 algorithm
// ---------------------------------------------------------------------------

/// Epoch day number for today (days since 1970-01-01).
int todayEpochDay() =>
    DateTime.now().toUtc().difference(DateTime.utc(1970)).inDays;

/// Applies one SM-2 review step and returns an updated [ReviewRecord].
ReviewRecord applyReview(ReviewRecord? record, String character, bool correct) {
  final today = todayEpochDay();

  double ease = record?.easeFactor ?? 2.5;
  int interval = record?.intervalDays ?? 1;
  int correctN = record?.correctCount ?? 0;
  int incorrectN = record?.incorrectCount ?? 0;

  if (correct) {
    ease = (ease + 0.1).clamp(1.3, 5.0);
    interval = record == null
        ? 1
        : record.intervalDays == 1
            ? 6
            : (interval * ease).round();
    correctN++;
  } else {
    ease = (ease - 0.2).clamp(1.3, 5.0);
    interval = 1;
    incorrectN++;
  }

  // Mastery: 0=New, 1=Learning (<3 correct), 2=Review (interval<21), 3=Mastered
  final mastery = correctN == 0
      ? 0
      : correctN < 3
          ? 1
          : interval < 21
              ? 2
              : 3;

  return ReviewRecord(
    character: character,
    easeFactor: ease,
    intervalDays: interval,
    nextReviewDay: today + interval,
    correctCount: correctN,
    incorrectCount: incorrectN,
    masteryLevel: mastery,
  );
}
