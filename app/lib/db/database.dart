// Drift database — local SQLite persistence for SRS review history.
// Run `dart run build_runner build` after editing this file to regenerate database.g.dart.
// Schema: review_records — one row per card, tracks SM-2 state and mastery level.

import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

// ---------------------------------------------------------------------------
// Table definition
// ---------------------------------------------------------------------------

/// Stores one row per card with all state needed for SM-2 spaced repetition.
class ReviewRecords extends Table {
  /// Unique identifier: the Devanagari character string (e.g. "क").
  TextColumn get character => text()();

  /// SM-2 ease factor (default 2.5, minimum 1.3).
  RealColumn get easeFactor => real().withDefault(const Constant(2.5))();

  /// Current inter-review interval in days.
  IntColumn get intervalDays => integer().withDefault(const Constant(1))();

  /// Epoch day of the next scheduled review (days since Unix epoch).
  IntColumn get nextReviewDay => integer().withDefault(const Constant(0))();

  /// Total correct answers for this card.
  IntColumn get correctCount => integer().withDefault(const Constant(0))();

  /// Total incorrect answers for this card.
  IntColumn get incorrectCount => integer().withDefault(const Constant(0))();

  /// Mastery level: 0=New, 1=Learning, 2=Review, 3=Mastered.
  IntColumn get masteryLevel => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {character};
}

// ---------------------------------------------------------------------------
// Database class
// ---------------------------------------------------------------------------

@DriftDatabase(tables: [ReviewRecords])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // --- Queries ---

  /// Returns all cards whose [nextReviewDay] is on or before today.
  Future<List<ReviewRecord>> getDueCards(int todayEpochDay) =>
      (select(reviewRecords)
            ..where((r) => r.nextReviewDay.isSmallerOrEqualValue(todayEpochDay)))
          .get();

  /// Returns the review record for [character], or null if never reviewed.
  Future<ReviewRecord?> getRecord(String character) =>
      (select(reviewRecords)..where((r) => r.character.equals(character)))
          .getSingleOrNull();

  /// Upserts a review record (insert or replace on primary-key conflict).
  Future<void> upsertRecord(ReviewRecordsCompanion record) =>
      into(reviewRecords).insertOnConflictUpdate(record);

  /// Returns all review records (used for stats screen in Phase 2).
  Future<List<ReviewRecord>> getAllRecords() => select(reviewRecords).get();
}

// ---------------------------------------------------------------------------
// SM-2 algorithm
// ---------------------------------------------------------------------------

/// Epoch day number for today (days since 1970-01-01).
int todayEpochDay() =>
    DateTime.now().toUtc().difference(DateTime.utc(1970)).inDays;

/// Applies one SM-2 review step and returns an updated [ReviewRecordsCompanion].
///
/// [record] is the current row (or null for a new card).
/// [correct] is whether the user answered correctly.
///
/// SM-2 rules:
///   - Correct: interval grows (×easeFactor, minimum 1 day → 6 days → …),
///     ease factor increases slightly.
///   - Incorrect: interval resets to 1, ease factor decreases (min 1.3).
ReviewRecordsCompanion applyReview(ReviewRecord? record, bool correct) {
  final today = todayEpochDay();

  double ease = record?.easeFactor ?? 2.5;
  int interval = record?.intervalDays ?? 1;
  int correct0 = record?.correctCount ?? 0;
  int incorrect0 = record?.incorrectCount ?? 0;
  String character = record?.character ?? '';

  if (correct) {
    ease = (ease + 0.1).clamp(1.3, 5.0);
    interval = record == null
        ? 1
        : record.intervalDays == 1
            ? 6
            : (interval * ease).round();
    correct0++;
  } else {
    ease = (ease - 0.2).clamp(1.3, 5.0);
    interval = 1;
    incorrect0++;
  }

  // Mastery: 0=New (never seen), 1=Learning (<3 correct), 2=Review (interval<21), 3=Mastered
  final mastery = correct0 == 0
      ? 0
      : correct0 < 3
          ? 1
          : interval < 21
              ? 2
              : 3;

  return ReviewRecordsCompanion(
    character: Value(character),
    easeFactor: Value(ease),
    intervalDays: Value(interval),
    nextReviewDay: Value(today + interval),
    correctCount: Value(correct0),
    incorrectCount: Value(incorrect0),
    masteryLevel: Value(mastery),
  );
}

// ---------------------------------------------------------------------------
// Connection helper
// ---------------------------------------------------------------------------

LazyDatabase _openConnection() => LazyDatabase(() async {
      final dir = await getApplicationDocumentsDirectory();
      final file = File(p.join(dir.path, 'sanskrit_srs.db'));
      return NativeDatabase(file);
    });
