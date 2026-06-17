// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ReviewRecordsTable extends ReviewRecords
    with TableInfo<$ReviewRecordsTable, ReviewRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReviewRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _characterMeta = const VerificationMeta(
    'character',
  );
  @override
  late final GeneratedColumn<String> character = GeneratedColumn<String>(
    'character',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _easeFactorMeta = const VerificationMeta(
    'easeFactor',
  );
  @override
  late final GeneratedColumn<double> easeFactor = GeneratedColumn<double>(
    'ease_factor',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(2.5),
  );
  static const VerificationMeta _intervalDaysMeta = const VerificationMeta(
    'intervalDays',
  );
  @override
  late final GeneratedColumn<int> intervalDays = GeneratedColumn<int>(
    'interval_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _nextReviewDayMeta = const VerificationMeta(
    'nextReviewDay',
  );
  @override
  late final GeneratedColumn<int> nextReviewDay = GeneratedColumn<int>(
    'next_review_day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _correctCountMeta = const VerificationMeta(
    'correctCount',
  );
  @override
  late final GeneratedColumn<int> correctCount = GeneratedColumn<int>(
    'correct_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _incorrectCountMeta = const VerificationMeta(
    'incorrectCount',
  );
  @override
  late final GeneratedColumn<int> incorrectCount = GeneratedColumn<int>(
    'incorrect_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _masteryLevelMeta = const VerificationMeta(
    'masteryLevel',
  );
  @override
  late final GeneratedColumn<int> masteryLevel = GeneratedColumn<int>(
    'mastery_level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    character,
    easeFactor,
    intervalDays,
    nextReviewDay,
    correctCount,
    incorrectCount,
    masteryLevel,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'review_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReviewRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('character')) {
      context.handle(
        _characterMeta,
        character.isAcceptableOrUnknown(data['character']!, _characterMeta),
      );
    } else if (isInserting) {
      context.missing(_characterMeta);
    }
    if (data.containsKey('ease_factor')) {
      context.handle(
        _easeFactorMeta,
        easeFactor.isAcceptableOrUnknown(data['ease_factor']!, _easeFactorMeta),
      );
    }
    if (data.containsKey('interval_days')) {
      context.handle(
        _intervalDaysMeta,
        intervalDays.isAcceptableOrUnknown(
          data['interval_days']!,
          _intervalDaysMeta,
        ),
      );
    }
    if (data.containsKey('next_review_day')) {
      context.handle(
        _nextReviewDayMeta,
        nextReviewDay.isAcceptableOrUnknown(
          data['next_review_day']!,
          _nextReviewDayMeta,
        ),
      );
    }
    if (data.containsKey('correct_count')) {
      context.handle(
        _correctCountMeta,
        correctCount.isAcceptableOrUnknown(
          data['correct_count']!,
          _correctCountMeta,
        ),
      );
    }
    if (data.containsKey('incorrect_count')) {
      context.handle(
        _incorrectCountMeta,
        incorrectCount.isAcceptableOrUnknown(
          data['incorrect_count']!,
          _incorrectCountMeta,
        ),
      );
    }
    if (data.containsKey('mastery_level')) {
      context.handle(
        _masteryLevelMeta,
        masteryLevel.isAcceptableOrUnknown(
          data['mastery_level']!,
          _masteryLevelMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {character};
  @override
  ReviewRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReviewRecord(
      character: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}character'],
      )!,
      easeFactor: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}ease_factor'],
      )!,
      intervalDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}interval_days'],
      )!,
      nextReviewDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}next_review_day'],
      )!,
      correctCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}correct_count'],
      )!,
      incorrectCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}incorrect_count'],
      )!,
      masteryLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}mastery_level'],
      )!,
    );
  }

  @override
  $ReviewRecordsTable createAlias(String alias) {
    return $ReviewRecordsTable(attachedDatabase, alias);
  }
}

class ReviewRecord extends DataClass implements Insertable<ReviewRecord> {
  /// Unique identifier: the Devanagari character string (e.g. "क").
  final String character;

  /// SM-2 ease factor (default 2.5, minimum 1.3).
  final double easeFactor;

  /// Current inter-review interval in days.
  final int intervalDays;

  /// Epoch day of the next scheduled review (days since Unix epoch).
  final int nextReviewDay;

  /// Total correct answers for this card.
  final int correctCount;

  /// Total incorrect answers for this card.
  final int incorrectCount;

  /// Mastery level: 0=New, 1=Learning, 2=Review, 3=Mastered.
  final int masteryLevel;
  const ReviewRecord({
    required this.character,
    required this.easeFactor,
    required this.intervalDays,
    required this.nextReviewDay,
    required this.correctCount,
    required this.incorrectCount,
    required this.masteryLevel,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['character'] = Variable<String>(character);
    map['ease_factor'] = Variable<double>(easeFactor);
    map['interval_days'] = Variable<int>(intervalDays);
    map['next_review_day'] = Variable<int>(nextReviewDay);
    map['correct_count'] = Variable<int>(correctCount);
    map['incorrect_count'] = Variable<int>(incorrectCount);
    map['mastery_level'] = Variable<int>(masteryLevel);
    return map;
  }

  ReviewRecordsCompanion toCompanion(bool nullToAbsent) {
    return ReviewRecordsCompanion(
      character: Value(character),
      easeFactor: Value(easeFactor),
      intervalDays: Value(intervalDays),
      nextReviewDay: Value(nextReviewDay),
      correctCount: Value(correctCount),
      incorrectCount: Value(incorrectCount),
      masteryLevel: Value(masteryLevel),
    );
  }

  factory ReviewRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReviewRecord(
      character: serializer.fromJson<String>(json['character']),
      easeFactor: serializer.fromJson<double>(json['easeFactor']),
      intervalDays: serializer.fromJson<int>(json['intervalDays']),
      nextReviewDay: serializer.fromJson<int>(json['nextReviewDay']),
      correctCount: serializer.fromJson<int>(json['correctCount']),
      incorrectCount: serializer.fromJson<int>(json['incorrectCount']),
      masteryLevel: serializer.fromJson<int>(json['masteryLevel']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'character': serializer.toJson<String>(character),
      'easeFactor': serializer.toJson<double>(easeFactor),
      'intervalDays': serializer.toJson<int>(intervalDays),
      'nextReviewDay': serializer.toJson<int>(nextReviewDay),
      'correctCount': serializer.toJson<int>(correctCount),
      'incorrectCount': serializer.toJson<int>(incorrectCount),
      'masteryLevel': serializer.toJson<int>(masteryLevel),
    };
  }

  ReviewRecord copyWith({
    String? character,
    double? easeFactor,
    int? intervalDays,
    int? nextReviewDay,
    int? correctCount,
    int? incorrectCount,
    int? masteryLevel,
  }) => ReviewRecord(
    character: character ?? this.character,
    easeFactor: easeFactor ?? this.easeFactor,
    intervalDays: intervalDays ?? this.intervalDays,
    nextReviewDay: nextReviewDay ?? this.nextReviewDay,
    correctCount: correctCount ?? this.correctCount,
    incorrectCount: incorrectCount ?? this.incorrectCount,
    masteryLevel: masteryLevel ?? this.masteryLevel,
  );
  ReviewRecord copyWithCompanion(ReviewRecordsCompanion data) {
    return ReviewRecord(
      character: data.character.present ? data.character.value : this.character,
      easeFactor: data.easeFactor.present
          ? data.easeFactor.value
          : this.easeFactor,
      intervalDays: data.intervalDays.present
          ? data.intervalDays.value
          : this.intervalDays,
      nextReviewDay: data.nextReviewDay.present
          ? data.nextReviewDay.value
          : this.nextReviewDay,
      correctCount: data.correctCount.present
          ? data.correctCount.value
          : this.correctCount,
      incorrectCount: data.incorrectCount.present
          ? data.incorrectCount.value
          : this.incorrectCount,
      masteryLevel: data.masteryLevel.present
          ? data.masteryLevel.value
          : this.masteryLevel,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReviewRecord(')
          ..write('character: $character, ')
          ..write('easeFactor: $easeFactor, ')
          ..write('intervalDays: $intervalDays, ')
          ..write('nextReviewDay: $nextReviewDay, ')
          ..write('correctCount: $correctCount, ')
          ..write('incorrectCount: $incorrectCount, ')
          ..write('masteryLevel: $masteryLevel')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    character,
    easeFactor,
    intervalDays,
    nextReviewDay,
    correctCount,
    incorrectCount,
    masteryLevel,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReviewRecord &&
          other.character == this.character &&
          other.easeFactor == this.easeFactor &&
          other.intervalDays == this.intervalDays &&
          other.nextReviewDay == this.nextReviewDay &&
          other.correctCount == this.correctCount &&
          other.incorrectCount == this.incorrectCount &&
          other.masteryLevel == this.masteryLevel);
}

class ReviewRecordsCompanion extends UpdateCompanion<ReviewRecord> {
  final Value<String> character;
  final Value<double> easeFactor;
  final Value<int> intervalDays;
  final Value<int> nextReviewDay;
  final Value<int> correctCount;
  final Value<int> incorrectCount;
  final Value<int> masteryLevel;
  final Value<int> rowid;
  const ReviewRecordsCompanion({
    this.character = const Value.absent(),
    this.easeFactor = const Value.absent(),
    this.intervalDays = const Value.absent(),
    this.nextReviewDay = const Value.absent(),
    this.correctCount = const Value.absent(),
    this.incorrectCount = const Value.absent(),
    this.masteryLevel = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReviewRecordsCompanion.insert({
    required String character,
    this.easeFactor = const Value.absent(),
    this.intervalDays = const Value.absent(),
    this.nextReviewDay = const Value.absent(),
    this.correctCount = const Value.absent(),
    this.incorrectCount = const Value.absent(),
    this.masteryLevel = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : character = Value(character);
  static Insertable<ReviewRecord> custom({
    Expression<String>? character,
    Expression<double>? easeFactor,
    Expression<int>? intervalDays,
    Expression<int>? nextReviewDay,
    Expression<int>? correctCount,
    Expression<int>? incorrectCount,
    Expression<int>? masteryLevel,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (character != null) 'character': character,
      if (easeFactor != null) 'ease_factor': easeFactor,
      if (intervalDays != null) 'interval_days': intervalDays,
      if (nextReviewDay != null) 'next_review_day': nextReviewDay,
      if (correctCount != null) 'correct_count': correctCount,
      if (incorrectCount != null) 'incorrect_count': incorrectCount,
      if (masteryLevel != null) 'mastery_level': masteryLevel,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReviewRecordsCompanion copyWith({
    Value<String>? character,
    Value<double>? easeFactor,
    Value<int>? intervalDays,
    Value<int>? nextReviewDay,
    Value<int>? correctCount,
    Value<int>? incorrectCount,
    Value<int>? masteryLevel,
    Value<int>? rowid,
  }) {
    return ReviewRecordsCompanion(
      character: character ?? this.character,
      easeFactor: easeFactor ?? this.easeFactor,
      intervalDays: intervalDays ?? this.intervalDays,
      nextReviewDay: nextReviewDay ?? this.nextReviewDay,
      correctCount: correctCount ?? this.correctCount,
      incorrectCount: incorrectCount ?? this.incorrectCount,
      masteryLevel: masteryLevel ?? this.masteryLevel,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (character.present) {
      map['character'] = Variable<String>(character.value);
    }
    if (easeFactor.present) {
      map['ease_factor'] = Variable<double>(easeFactor.value);
    }
    if (intervalDays.present) {
      map['interval_days'] = Variable<int>(intervalDays.value);
    }
    if (nextReviewDay.present) {
      map['next_review_day'] = Variable<int>(nextReviewDay.value);
    }
    if (correctCount.present) {
      map['correct_count'] = Variable<int>(correctCount.value);
    }
    if (incorrectCount.present) {
      map['incorrect_count'] = Variable<int>(incorrectCount.value);
    }
    if (masteryLevel.present) {
      map['mastery_level'] = Variable<int>(masteryLevel.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReviewRecordsCompanion(')
          ..write('character: $character, ')
          ..write('easeFactor: $easeFactor, ')
          ..write('intervalDays: $intervalDays, ')
          ..write('nextReviewDay: $nextReviewDay, ')
          ..write('correctCount: $correctCount, ')
          ..write('incorrectCount: $incorrectCount, ')
          ..write('masteryLevel: $masteryLevel, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ReviewRecordsTable reviewRecords = $ReviewRecordsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [reviewRecords];
}

typedef $$ReviewRecordsTableCreateCompanionBuilder =
    ReviewRecordsCompanion Function({
      required String character,
      Value<double> easeFactor,
      Value<int> intervalDays,
      Value<int> nextReviewDay,
      Value<int> correctCount,
      Value<int> incorrectCount,
      Value<int> masteryLevel,
      Value<int> rowid,
    });
typedef $$ReviewRecordsTableUpdateCompanionBuilder =
    ReviewRecordsCompanion Function({
      Value<String> character,
      Value<double> easeFactor,
      Value<int> intervalDays,
      Value<int> nextReviewDay,
      Value<int> correctCount,
      Value<int> incorrectCount,
      Value<int> masteryLevel,
      Value<int> rowid,
    });

class $$ReviewRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $ReviewRecordsTable> {
  $$ReviewRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get character => $composableBuilder(
    column: $table.character,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get easeFactor => $composableBuilder(
    column: $table.easeFactor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get intervalDays => $composableBuilder(
    column: $table.intervalDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get nextReviewDay => $composableBuilder(
    column: $table.nextReviewDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get correctCount => $composableBuilder(
    column: $table.correctCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get incorrectCount => $composableBuilder(
    column: $table.incorrectCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get masteryLevel => $composableBuilder(
    column: $table.masteryLevel,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ReviewRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReviewRecordsTable> {
  $$ReviewRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get character => $composableBuilder(
    column: $table.character,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get easeFactor => $composableBuilder(
    column: $table.easeFactor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get intervalDays => $composableBuilder(
    column: $table.intervalDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get nextReviewDay => $composableBuilder(
    column: $table.nextReviewDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get correctCount => $composableBuilder(
    column: $table.correctCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get incorrectCount => $composableBuilder(
    column: $table.incorrectCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get masteryLevel => $composableBuilder(
    column: $table.masteryLevel,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ReviewRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReviewRecordsTable> {
  $$ReviewRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get character =>
      $composableBuilder(column: $table.character, builder: (column) => column);

  GeneratedColumn<double> get easeFactor => $composableBuilder(
    column: $table.easeFactor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get intervalDays => $composableBuilder(
    column: $table.intervalDays,
    builder: (column) => column,
  );

  GeneratedColumn<int> get nextReviewDay => $composableBuilder(
    column: $table.nextReviewDay,
    builder: (column) => column,
  );

  GeneratedColumn<int> get correctCount => $composableBuilder(
    column: $table.correctCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get incorrectCount => $composableBuilder(
    column: $table.incorrectCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get masteryLevel => $composableBuilder(
    column: $table.masteryLevel,
    builder: (column) => column,
  );
}

class $$ReviewRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReviewRecordsTable,
          ReviewRecord,
          $$ReviewRecordsTableFilterComposer,
          $$ReviewRecordsTableOrderingComposer,
          $$ReviewRecordsTableAnnotationComposer,
          $$ReviewRecordsTableCreateCompanionBuilder,
          $$ReviewRecordsTableUpdateCompanionBuilder,
          (
            ReviewRecord,
            BaseReferences<_$AppDatabase, $ReviewRecordsTable, ReviewRecord>,
          ),
          ReviewRecord,
          PrefetchHooks Function()
        > {
  $$ReviewRecordsTableTableManager(_$AppDatabase db, $ReviewRecordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReviewRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReviewRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReviewRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> character = const Value.absent(),
                Value<double> easeFactor = const Value.absent(),
                Value<int> intervalDays = const Value.absent(),
                Value<int> nextReviewDay = const Value.absent(),
                Value<int> correctCount = const Value.absent(),
                Value<int> incorrectCount = const Value.absent(),
                Value<int> masteryLevel = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReviewRecordsCompanion(
                character: character,
                easeFactor: easeFactor,
                intervalDays: intervalDays,
                nextReviewDay: nextReviewDay,
                correctCount: correctCount,
                incorrectCount: incorrectCount,
                masteryLevel: masteryLevel,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String character,
                Value<double> easeFactor = const Value.absent(),
                Value<int> intervalDays = const Value.absent(),
                Value<int> nextReviewDay = const Value.absent(),
                Value<int> correctCount = const Value.absent(),
                Value<int> incorrectCount = const Value.absent(),
                Value<int> masteryLevel = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReviewRecordsCompanion.insert(
                character: character,
                easeFactor: easeFactor,
                intervalDays: intervalDays,
                nextReviewDay: nextReviewDay,
                correctCount: correctCount,
                incorrectCount: incorrectCount,
                masteryLevel: masteryLevel,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ReviewRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReviewRecordsTable,
      ReviewRecord,
      $$ReviewRecordsTableFilterComposer,
      $$ReviewRecordsTableOrderingComposer,
      $$ReviewRecordsTableAnnotationComposer,
      $$ReviewRecordsTableCreateCompanionBuilder,
      $$ReviewRecordsTableUpdateCompanionBuilder,
      (
        ReviewRecord,
        BaseReferences<_$AppDatabase, $ReviewRecordsTable, ReviewRecord>,
      ),
      ReviewRecord,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ReviewRecordsTableTableManager get reviewRecords =>
      $$ReviewRecordsTableTableManager(_db, _db.reviewRecords);
}
