// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $TaskRowsTable extends TaskRows with TableInfo<$TaskRowsTable, TaskRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _dueDateTimeMeta = const VerificationMeta(
    'dueDateTime',
  );
  @override
  late final GeneratedColumn<DateTime> dueDateTime = GeneratedColumn<DateTime>(
    'due_date_time',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hasDueTimeMeta = const VerificationMeta(
    'hasDueTime',
  );
  @override
  late final GeneratedColumn<bool> hasDueTime = GeneratedColumn<bool>(
    'has_due_time',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_due_time" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<String> priority = GeneratedColumn<String>(
    'priority',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isCompletedMeta = const VerificationMeta(
    'isCompleted',
  );
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
    'is_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reminderEnabledMeta = const VerificationMeta(
    'reminderEnabled',
  );
  @override
  late final GeneratedColumn<bool> reminderEnabled = GeneratedColumn<bool>(
    'reminder_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("reminder_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _reminderOffsetMeta = const VerificationMeta(
    'reminderOffset',
  );
  @override
  late final GeneratedColumn<String> reminderOffset = GeneratedColumn<String>(
    'reminder_offset',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reminderSyncStatusMeta =
      const VerificationMeta('reminderSyncStatus');
  @override
  late final GeneratedColumn<String> reminderSyncStatus =
      GeneratedColumn<String>(
        'reminder_sync_status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    note,
    dueDateTime,
    hasDueTime,
    priority,
    isCompleted,
    completedAt,
    reminderEnabled,
    reminderOffset,
    reminderSyncStatus,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('due_date_time')) {
      context.handle(
        _dueDateTimeMeta,
        dueDateTime.isAcceptableOrUnknown(
          data['due_date_time']!,
          _dueDateTimeMeta,
        ),
      );
    }
    if (data.containsKey('has_due_time')) {
      context.handle(
        _hasDueTimeMeta,
        hasDueTime.isAcceptableOrUnknown(
          data['has_due_time']!,
          _hasDueTimeMeta,
        ),
      );
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    } else if (isInserting) {
      context.missing(_priorityMeta);
    }
    if (data.containsKey('is_completed')) {
      context.handle(
        _isCompletedMeta,
        isCompleted.isAcceptableOrUnknown(
          data['is_completed']!,
          _isCompletedMeta,
        ),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('reminder_enabled')) {
      context.handle(
        _reminderEnabledMeta,
        reminderEnabled.isAcceptableOrUnknown(
          data['reminder_enabled']!,
          _reminderEnabledMeta,
        ),
      );
    }
    if (data.containsKey('reminder_offset')) {
      context.handle(
        _reminderOffsetMeta,
        reminderOffset.isAcceptableOrUnknown(
          data['reminder_offset']!,
          _reminderOffsetMeta,
        ),
      );
    }
    if (data.containsKey('reminder_sync_status')) {
      context.handle(
        _reminderSyncStatusMeta,
        reminderSyncStatus.isAcceptableOrUnknown(
          data['reminder_sync_status']!,
          _reminderSyncStatusMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_reminderSyncStatusMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
      dueDateTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_date_time'],
      ),
      hasDueTime: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_due_time'],
      )!,
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}priority'],
      )!,
      isCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_completed'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      reminderEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}reminder_enabled'],
      )!,
      reminderOffset: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reminder_offset'],
      ),
      reminderSyncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reminder_sync_status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $TaskRowsTable createAlias(String alias) {
    return $TaskRowsTable(attachedDatabase, alias);
  }
}

class TaskRow extends DataClass implements Insertable<TaskRow> {
  final String id;
  final String title;
  final String note;
  final DateTime? dueDateTime;
  final bool hasDueTime;
  final String priority;
  final bool isCompleted;
  final DateTime? completedAt;
  final bool reminderEnabled;
  final String? reminderOffset;
  final String reminderSyncStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  const TaskRow({
    required this.id,
    required this.title,
    required this.note,
    this.dueDateTime,
    required this.hasDueTime,
    required this.priority,
    required this.isCompleted,
    this.completedAt,
    required this.reminderEnabled,
    this.reminderOffset,
    required this.reminderSyncStatus,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['note'] = Variable<String>(note);
    if (!nullToAbsent || dueDateTime != null) {
      map['due_date_time'] = Variable<DateTime>(dueDateTime);
    }
    map['has_due_time'] = Variable<bool>(hasDueTime);
    map['priority'] = Variable<String>(priority);
    map['is_completed'] = Variable<bool>(isCompleted);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    map['reminder_enabled'] = Variable<bool>(reminderEnabled);
    if (!nullToAbsent || reminderOffset != null) {
      map['reminder_offset'] = Variable<String>(reminderOffset);
    }
    map['reminder_sync_status'] = Variable<String>(reminderSyncStatus);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TaskRowsCompanion toCompanion(bool nullToAbsent) {
    return TaskRowsCompanion(
      id: Value(id),
      title: Value(title),
      note: Value(note),
      dueDateTime: dueDateTime == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDateTime),
      hasDueTime: Value(hasDueTime),
      priority: Value(priority),
      isCompleted: Value(isCompleted),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      reminderEnabled: Value(reminderEnabled),
      reminderOffset: reminderOffset == null && nullToAbsent
          ? const Value.absent()
          : Value(reminderOffset),
      reminderSyncStatus: Value(reminderSyncStatus),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory TaskRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskRow(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      note: serializer.fromJson<String>(json['note']),
      dueDateTime: serializer.fromJson<DateTime?>(json['dueDateTime']),
      hasDueTime: serializer.fromJson<bool>(json['hasDueTime']),
      priority: serializer.fromJson<String>(json['priority']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      reminderEnabled: serializer.fromJson<bool>(json['reminderEnabled']),
      reminderOffset: serializer.fromJson<String?>(json['reminderOffset']),
      reminderSyncStatus: serializer.fromJson<String>(
        json['reminderSyncStatus'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'note': serializer.toJson<String>(note),
      'dueDateTime': serializer.toJson<DateTime?>(dueDateTime),
      'hasDueTime': serializer.toJson<bool>(hasDueTime),
      'priority': serializer.toJson<String>(priority),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'reminderEnabled': serializer.toJson<bool>(reminderEnabled),
      'reminderOffset': serializer.toJson<String?>(reminderOffset),
      'reminderSyncStatus': serializer.toJson<String>(reminderSyncStatus),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TaskRow copyWith({
    String? id,
    String? title,
    String? note,
    Value<DateTime?> dueDateTime = const Value.absent(),
    bool? hasDueTime,
    String? priority,
    bool? isCompleted,
    Value<DateTime?> completedAt = const Value.absent(),
    bool? reminderEnabled,
    Value<String?> reminderOffset = const Value.absent(),
    String? reminderSyncStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => TaskRow(
    id: id ?? this.id,
    title: title ?? this.title,
    note: note ?? this.note,
    dueDateTime: dueDateTime.present ? dueDateTime.value : this.dueDateTime,
    hasDueTime: hasDueTime ?? this.hasDueTime,
    priority: priority ?? this.priority,
    isCompleted: isCompleted ?? this.isCompleted,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    reminderEnabled: reminderEnabled ?? this.reminderEnabled,
    reminderOffset: reminderOffset.present
        ? reminderOffset.value
        : this.reminderOffset,
    reminderSyncStatus: reminderSyncStatus ?? this.reminderSyncStatus,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  TaskRow copyWithCompanion(TaskRowsCompanion data) {
    return TaskRow(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      note: data.note.present ? data.note.value : this.note,
      dueDateTime: data.dueDateTime.present
          ? data.dueDateTime.value
          : this.dueDateTime,
      hasDueTime: data.hasDueTime.present
          ? data.hasDueTime.value
          : this.hasDueTime,
      priority: data.priority.present ? data.priority.value : this.priority,
      isCompleted: data.isCompleted.present
          ? data.isCompleted.value
          : this.isCompleted,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      reminderEnabled: data.reminderEnabled.present
          ? data.reminderEnabled.value
          : this.reminderEnabled,
      reminderOffset: data.reminderOffset.present
          ? data.reminderOffset.value
          : this.reminderOffset,
      reminderSyncStatus: data.reminderSyncStatus.present
          ? data.reminderSyncStatus.value
          : this.reminderSyncStatus,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskRow(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('note: $note, ')
          ..write('dueDateTime: $dueDateTime, ')
          ..write('hasDueTime: $hasDueTime, ')
          ..write('priority: $priority, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('completedAt: $completedAt, ')
          ..write('reminderEnabled: $reminderEnabled, ')
          ..write('reminderOffset: $reminderOffset, ')
          ..write('reminderSyncStatus: $reminderSyncStatus, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    note,
    dueDateTime,
    hasDueTime,
    priority,
    isCompleted,
    completedAt,
    reminderEnabled,
    reminderOffset,
    reminderSyncStatus,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskRow &&
          other.id == this.id &&
          other.title == this.title &&
          other.note == this.note &&
          other.dueDateTime == this.dueDateTime &&
          other.hasDueTime == this.hasDueTime &&
          other.priority == this.priority &&
          other.isCompleted == this.isCompleted &&
          other.completedAt == this.completedAt &&
          other.reminderEnabled == this.reminderEnabled &&
          other.reminderOffset == this.reminderOffset &&
          other.reminderSyncStatus == this.reminderSyncStatus &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TaskRowsCompanion extends UpdateCompanion<TaskRow> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> note;
  final Value<DateTime?> dueDateTime;
  final Value<bool> hasDueTime;
  final Value<String> priority;
  final Value<bool> isCompleted;
  final Value<DateTime?> completedAt;
  final Value<bool> reminderEnabled;
  final Value<String?> reminderOffset;
  final Value<String> reminderSyncStatus;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const TaskRowsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.note = const Value.absent(),
    this.dueDateTime = const Value.absent(),
    this.hasDueTime = const Value.absent(),
    this.priority = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.reminderEnabled = const Value.absent(),
    this.reminderOffset = const Value.absent(),
    this.reminderSyncStatus = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TaskRowsCompanion.insert({
    required String id,
    required String title,
    this.note = const Value.absent(),
    this.dueDateTime = const Value.absent(),
    this.hasDueTime = const Value.absent(),
    required String priority,
    this.isCompleted = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.reminderEnabled = const Value.absent(),
    this.reminderOffset = const Value.absent(),
    required String reminderSyncStatus,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       priority = Value(priority),
       reminderSyncStatus = Value(reminderSyncStatus),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<TaskRow> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? note,
    Expression<DateTime>? dueDateTime,
    Expression<bool>? hasDueTime,
    Expression<String>? priority,
    Expression<bool>? isCompleted,
    Expression<DateTime>? completedAt,
    Expression<bool>? reminderEnabled,
    Expression<String>? reminderOffset,
    Expression<String>? reminderSyncStatus,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (note != null) 'note': note,
      if (dueDateTime != null) 'due_date_time': dueDateTime,
      if (hasDueTime != null) 'has_due_time': hasDueTime,
      if (priority != null) 'priority': priority,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (completedAt != null) 'completed_at': completedAt,
      if (reminderEnabled != null) 'reminder_enabled': reminderEnabled,
      if (reminderOffset != null) 'reminder_offset': reminderOffset,
      if (reminderSyncStatus != null)
        'reminder_sync_status': reminderSyncStatus,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TaskRowsCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? note,
    Value<DateTime?>? dueDateTime,
    Value<bool>? hasDueTime,
    Value<String>? priority,
    Value<bool>? isCompleted,
    Value<DateTime?>? completedAt,
    Value<bool>? reminderEnabled,
    Value<String?>? reminderOffset,
    Value<String>? reminderSyncStatus,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return TaskRowsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      note: note ?? this.note,
      dueDateTime: dueDateTime ?? this.dueDateTime,
      hasDueTime: hasDueTime ?? this.hasDueTime,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      reminderOffset: reminderOffset ?? this.reminderOffset,
      reminderSyncStatus: reminderSyncStatus ?? this.reminderSyncStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (dueDateTime.present) {
      map['due_date_time'] = Variable<DateTime>(dueDateTime.value);
    }
    if (hasDueTime.present) {
      map['has_due_time'] = Variable<bool>(hasDueTime.value);
    }
    if (priority.present) {
      map['priority'] = Variable<String>(priority.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (reminderEnabled.present) {
      map['reminder_enabled'] = Variable<bool>(reminderEnabled.value);
    }
    if (reminderOffset.present) {
      map['reminder_offset'] = Variable<String>(reminderOffset.value);
    }
    if (reminderSyncStatus.present) {
      map['reminder_sync_status'] = Variable<String>(reminderSyncStatus.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskRowsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('note: $note, ')
          ..write('dueDateTime: $dueDateTime, ')
          ..write('hasDueTime: $hasDueTime, ')
          ..write('priority: $priority, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('completedAt: $completedAt, ')
          ..write('reminderEnabled: $reminderEnabled, ')
          ..write('reminderOffset: $reminderOffset, ')
          ..write('reminderSyncStatus: $reminderSyncStatus, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NotificationJobRowsTable extends NotificationJobRows
    with TableInfo<$NotificationJobRowsTable, NotificationJobRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotificationJobRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
    'task_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _operationMeta = const VerificationMeta(
    'operation',
  );
  @override
  late final GeneratedColumn<String> operation = GeneratedColumn<String>(
    'operation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scheduledAtMeta = const VerificationMeta(
    'scheduledAt',
  );
  @override
  late final GeneratedColumn<DateTime> scheduledAt = GeneratedColumn<DateTime>(
    'scheduled_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _attemptCountMeta = const VerificationMeta(
    'attemptCount',
  );
  @override
  late final GeneratedColumn<int> attemptCount = GeneratedColumn<int>(
    'attempt_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    taskId,
    operation,
    scheduledAt,
    attemptCount,
    lastError,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notification_job_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<NotificationJobRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('operation')) {
      context.handle(
        _operationMeta,
        operation.isAcceptableOrUnknown(data['operation']!, _operationMeta),
      );
    } else if (isInserting) {
      context.missing(_operationMeta);
    }
    if (data.containsKey('scheduled_at')) {
      context.handle(
        _scheduledAtMeta,
        scheduledAt.isAcceptableOrUnknown(
          data['scheduled_at']!,
          _scheduledAtMeta,
        ),
      );
    }
    if (data.containsKey('attempt_count')) {
      context.handle(
        _attemptCountMeta,
        attemptCount.isAcceptableOrUnknown(
          data['attempt_count']!,
          _attemptCountMeta,
        ),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NotificationJobRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NotificationJobRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_id'],
      )!,
      operation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation'],
      )!,
      scheduledAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}scheduled_at'],
      ),
      attemptCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempt_count'],
      )!,
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $NotificationJobRowsTable createAlias(String alias) {
    return $NotificationJobRowsTable(attachedDatabase, alias);
  }
}

class NotificationJobRow extends DataClass
    implements Insertable<NotificationJobRow> {
  final int id;
  final String taskId;
  final String operation;
  final DateTime? scheduledAt;
  final int attemptCount;
  final String? lastError;
  final DateTime createdAt;
  const NotificationJobRow({
    required this.id,
    required this.taskId,
    required this.operation,
    this.scheduledAt,
    required this.attemptCount,
    this.lastError,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['task_id'] = Variable<String>(taskId);
    map['operation'] = Variable<String>(operation);
    if (!nullToAbsent || scheduledAt != null) {
      map['scheduled_at'] = Variable<DateTime>(scheduledAt);
    }
    map['attempt_count'] = Variable<int>(attemptCount);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  NotificationJobRowsCompanion toCompanion(bool nullToAbsent) {
    return NotificationJobRowsCompanion(
      id: Value(id),
      taskId: Value(taskId),
      operation: Value(operation),
      scheduledAt: scheduledAt == null && nullToAbsent
          ? const Value.absent()
          : Value(scheduledAt),
      attemptCount: Value(attemptCount),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      createdAt: Value(createdAt),
    );
  }

  factory NotificationJobRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NotificationJobRow(
      id: serializer.fromJson<int>(json['id']),
      taskId: serializer.fromJson<String>(json['taskId']),
      operation: serializer.fromJson<String>(json['operation']),
      scheduledAt: serializer.fromJson<DateTime?>(json['scheduledAt']),
      attemptCount: serializer.fromJson<int>(json['attemptCount']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'taskId': serializer.toJson<String>(taskId),
      'operation': serializer.toJson<String>(operation),
      'scheduledAt': serializer.toJson<DateTime?>(scheduledAt),
      'attemptCount': serializer.toJson<int>(attemptCount),
      'lastError': serializer.toJson<String?>(lastError),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  NotificationJobRow copyWith({
    int? id,
    String? taskId,
    String? operation,
    Value<DateTime?> scheduledAt = const Value.absent(),
    int? attemptCount,
    Value<String?> lastError = const Value.absent(),
    DateTime? createdAt,
  }) => NotificationJobRow(
    id: id ?? this.id,
    taskId: taskId ?? this.taskId,
    operation: operation ?? this.operation,
    scheduledAt: scheduledAt.present ? scheduledAt.value : this.scheduledAt,
    attemptCount: attemptCount ?? this.attemptCount,
    lastError: lastError.present ? lastError.value : this.lastError,
    createdAt: createdAt ?? this.createdAt,
  );
  NotificationJobRow copyWithCompanion(NotificationJobRowsCompanion data) {
    return NotificationJobRow(
      id: data.id.present ? data.id.value : this.id,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      operation: data.operation.present ? data.operation.value : this.operation,
      scheduledAt: data.scheduledAt.present
          ? data.scheduledAt.value
          : this.scheduledAt,
      attemptCount: data.attemptCount.present
          ? data.attemptCount.value
          : this.attemptCount,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NotificationJobRow(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('operation: $operation, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('attemptCount: $attemptCount, ')
          ..write('lastError: $lastError, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    taskId,
    operation,
    scheduledAt,
    attemptCount,
    lastError,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NotificationJobRow &&
          other.id == this.id &&
          other.taskId == this.taskId &&
          other.operation == this.operation &&
          other.scheduledAt == this.scheduledAt &&
          other.attemptCount == this.attemptCount &&
          other.lastError == this.lastError &&
          other.createdAt == this.createdAt);
}

class NotificationJobRowsCompanion extends UpdateCompanion<NotificationJobRow> {
  final Value<int> id;
  final Value<String> taskId;
  final Value<String> operation;
  final Value<DateTime?> scheduledAt;
  final Value<int> attemptCount;
  final Value<String?> lastError;
  final Value<DateTime> createdAt;
  const NotificationJobRowsCompanion({
    this.id = const Value.absent(),
    this.taskId = const Value.absent(),
    this.operation = const Value.absent(),
    this.scheduledAt = const Value.absent(),
    this.attemptCount = const Value.absent(),
    this.lastError = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  NotificationJobRowsCompanion.insert({
    this.id = const Value.absent(),
    required String taskId,
    required String operation,
    this.scheduledAt = const Value.absent(),
    this.attemptCount = const Value.absent(),
    this.lastError = const Value.absent(),
    required DateTime createdAt,
  }) : taskId = Value(taskId),
       operation = Value(operation),
       createdAt = Value(createdAt);
  static Insertable<NotificationJobRow> custom({
    Expression<int>? id,
    Expression<String>? taskId,
    Expression<String>? operation,
    Expression<DateTime>? scheduledAt,
    Expression<int>? attemptCount,
    Expression<String>? lastError,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (taskId != null) 'task_id': taskId,
      if (operation != null) 'operation': operation,
      if (scheduledAt != null) 'scheduled_at': scheduledAt,
      if (attemptCount != null) 'attempt_count': attemptCount,
      if (lastError != null) 'last_error': lastError,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  NotificationJobRowsCompanion copyWith({
    Value<int>? id,
    Value<String>? taskId,
    Value<String>? operation,
    Value<DateTime?>? scheduledAt,
    Value<int>? attemptCount,
    Value<String?>? lastError,
    Value<DateTime>? createdAt,
  }) {
    return NotificationJobRowsCompanion(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      operation: operation ?? this.operation,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      attemptCount: attemptCount ?? this.attemptCount,
      lastError: lastError ?? this.lastError,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (operation.present) {
      map['operation'] = Variable<String>(operation.value);
    }
    if (scheduledAt.present) {
      map['scheduled_at'] = Variable<DateTime>(scheduledAt.value);
    }
    if (attemptCount.present) {
      map['attempt_count'] = Variable<int>(attemptCount.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotificationJobRowsCompanion(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('operation: $operation, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('attemptCount: $attemptCount, ')
          ..write('lastError: $lastError, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ProfileRowsTable extends ProfileRows
    with TableInfo<$ProfileRowsTable, ProfileRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProfileRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('用户'),
  );
  static const VerificationMeta _avatarPathMeta = const VerificationMeta(
    'avatarPath',
  );
  @override
  late final GeneratedColumn<String> avatarPath = GeneratedColumn<String>(
    'avatar_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, displayName, avatarPath];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'profile_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProfileRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    }
    if (data.containsKey('avatar_path')) {
      context.handle(
        _avatarPathMeta,
        avatarPath.isAcceptableOrUnknown(data['avatar_path']!, _avatarPathMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProfileRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProfileRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      avatarPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar_path'],
      ),
    );
  }

  @override
  $ProfileRowsTable createAlias(String alias) {
    return $ProfileRowsTable(attachedDatabase, alias);
  }
}

class ProfileRow extends DataClass implements Insertable<ProfileRow> {
  final int id;
  final String displayName;
  final String? avatarPath;
  const ProfileRow({
    required this.id,
    required this.displayName,
    this.avatarPath,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['display_name'] = Variable<String>(displayName);
    if (!nullToAbsent || avatarPath != null) {
      map['avatar_path'] = Variable<String>(avatarPath);
    }
    return map;
  }

  ProfileRowsCompanion toCompanion(bool nullToAbsent) {
    return ProfileRowsCompanion(
      id: Value(id),
      displayName: Value(displayName),
      avatarPath: avatarPath == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarPath),
    );
  }

  factory ProfileRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProfileRow(
      id: serializer.fromJson<int>(json['id']),
      displayName: serializer.fromJson<String>(json['displayName']),
      avatarPath: serializer.fromJson<String?>(json['avatarPath']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'displayName': serializer.toJson<String>(displayName),
      'avatarPath': serializer.toJson<String?>(avatarPath),
    };
  }

  ProfileRow copyWith({
    int? id,
    String? displayName,
    Value<String?> avatarPath = const Value.absent(),
  }) => ProfileRow(
    id: id ?? this.id,
    displayName: displayName ?? this.displayName,
    avatarPath: avatarPath.present ? avatarPath.value : this.avatarPath,
  );
  ProfileRow copyWithCompanion(ProfileRowsCompanion data) {
    return ProfileRow(
      id: data.id.present ? data.id.value : this.id,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      avatarPath: data.avatarPath.present
          ? data.avatarPath.value
          : this.avatarPath,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProfileRow(')
          ..write('id: $id, ')
          ..write('displayName: $displayName, ')
          ..write('avatarPath: $avatarPath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, displayName, avatarPath);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProfileRow &&
          other.id == this.id &&
          other.displayName == this.displayName &&
          other.avatarPath == this.avatarPath);
}

class ProfileRowsCompanion extends UpdateCompanion<ProfileRow> {
  final Value<int> id;
  final Value<String> displayName;
  final Value<String?> avatarPath;
  const ProfileRowsCompanion({
    this.id = const Value.absent(),
    this.displayName = const Value.absent(),
    this.avatarPath = const Value.absent(),
  });
  ProfileRowsCompanion.insert({
    this.id = const Value.absent(),
    this.displayName = const Value.absent(),
    this.avatarPath = const Value.absent(),
  });
  static Insertable<ProfileRow> custom({
    Expression<int>? id,
    Expression<String>? displayName,
    Expression<String>? avatarPath,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (displayName != null) 'display_name': displayName,
      if (avatarPath != null) 'avatar_path': avatarPath,
    });
  }

  ProfileRowsCompanion copyWith({
    Value<int>? id,
    Value<String>? displayName,
    Value<String?>? avatarPath,
  }) {
    return ProfileRowsCompanion(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      avatarPath: avatarPath ?? this.avatarPath,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (avatarPath.present) {
      map['avatar_path'] = Variable<String>(avatarPath.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProfileRowsCompanion(')
          ..write('id: $id, ')
          ..write('displayName: $displayName, ')
          ..write('avatarPath: $avatarPath')
          ..write(')'))
        .toString();
  }
}

class $PreferenceRowsTable extends PreferenceRows
    with TableInfo<$PreferenceRowsTable, PreferenceRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PreferenceRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _defaultFilterMeta = const VerificationMeta(
    'defaultFilter',
  );
  @override
  late final GeneratedColumn<String> defaultFilter = GeneratedColumn<String>(
    'default_filter',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _animationsEnabledMeta = const VerificationMeta(
    'animationsEnabled',
  );
  @override
  late final GeneratedColumn<bool> animationsEnabled = GeneratedColumn<bool>(
    'animations_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("animations_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _notificationPermissionPromptedMeta =
      const VerificationMeta('notificationPermissionPrompted');
  @override
  late final GeneratedColumn<bool> notificationPermissionPrompted =
      GeneratedColumn<bool>(
        'notification_permission_prompted',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("notification_permission_prompted" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    defaultFilter,
    animationsEnabled,
    notificationPermissionPrompted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'preference_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<PreferenceRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('default_filter')) {
      context.handle(
        _defaultFilterMeta,
        defaultFilter.isAcceptableOrUnknown(
          data['default_filter']!,
          _defaultFilterMeta,
        ),
      );
    }
    if (data.containsKey('animations_enabled')) {
      context.handle(
        _animationsEnabledMeta,
        animationsEnabled.isAcceptableOrUnknown(
          data['animations_enabled']!,
          _animationsEnabledMeta,
        ),
      );
    }
    if (data.containsKey('notification_permission_prompted')) {
      context.handle(
        _notificationPermissionPromptedMeta,
        notificationPermissionPrompted.isAcceptableOrUnknown(
          data['notification_permission_prompted']!,
          _notificationPermissionPromptedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PreferenceRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PreferenceRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      defaultFilter: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}default_filter'],
      )!,
      animationsEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}animations_enabled'],
      )!,
      notificationPermissionPrompted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}notification_permission_prompted'],
      )!,
    );
  }

  @override
  $PreferenceRowsTable createAlias(String alias) {
    return $PreferenceRowsTable(attachedDatabase, alias);
  }
}

class PreferenceRow extends DataClass implements Insertable<PreferenceRow> {
  final int id;
  final String defaultFilter;
  final bool animationsEnabled;
  final bool notificationPermissionPrompted;
  const PreferenceRow({
    required this.id,
    required this.defaultFilter,
    required this.animationsEnabled,
    required this.notificationPermissionPrompted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['default_filter'] = Variable<String>(defaultFilter);
    map['animations_enabled'] = Variable<bool>(animationsEnabled);
    map['notification_permission_prompted'] = Variable<bool>(
      notificationPermissionPrompted,
    );
    return map;
  }

  PreferenceRowsCompanion toCompanion(bool nullToAbsent) {
    return PreferenceRowsCompanion(
      id: Value(id),
      defaultFilter: Value(defaultFilter),
      animationsEnabled: Value(animationsEnabled),
      notificationPermissionPrompted: Value(notificationPermissionPrompted),
    );
  }

  factory PreferenceRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PreferenceRow(
      id: serializer.fromJson<int>(json['id']),
      defaultFilter: serializer.fromJson<String>(json['defaultFilter']),
      animationsEnabled: serializer.fromJson<bool>(json['animationsEnabled']),
      notificationPermissionPrompted: serializer.fromJson<bool>(
        json['notificationPermissionPrompted'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'defaultFilter': serializer.toJson<String>(defaultFilter),
      'animationsEnabled': serializer.toJson<bool>(animationsEnabled),
      'notificationPermissionPrompted': serializer.toJson<bool>(
        notificationPermissionPrompted,
      ),
    };
  }

  PreferenceRow copyWith({
    int? id,
    String? defaultFilter,
    bool? animationsEnabled,
    bool? notificationPermissionPrompted,
  }) => PreferenceRow(
    id: id ?? this.id,
    defaultFilter: defaultFilter ?? this.defaultFilter,
    animationsEnabled: animationsEnabled ?? this.animationsEnabled,
    notificationPermissionPrompted:
        notificationPermissionPrompted ?? this.notificationPermissionPrompted,
  );
  PreferenceRow copyWithCompanion(PreferenceRowsCompanion data) {
    return PreferenceRow(
      id: data.id.present ? data.id.value : this.id,
      defaultFilter: data.defaultFilter.present
          ? data.defaultFilter.value
          : this.defaultFilter,
      animationsEnabled: data.animationsEnabled.present
          ? data.animationsEnabled.value
          : this.animationsEnabled,
      notificationPermissionPrompted:
          data.notificationPermissionPrompted.present
          ? data.notificationPermissionPrompted.value
          : this.notificationPermissionPrompted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PreferenceRow(')
          ..write('id: $id, ')
          ..write('defaultFilter: $defaultFilter, ')
          ..write('animationsEnabled: $animationsEnabled, ')
          ..write(
            'notificationPermissionPrompted: $notificationPermissionPrompted',
          )
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    defaultFilter,
    animationsEnabled,
    notificationPermissionPrompted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PreferenceRow &&
          other.id == this.id &&
          other.defaultFilter == this.defaultFilter &&
          other.animationsEnabled == this.animationsEnabled &&
          other.notificationPermissionPrompted ==
              this.notificationPermissionPrompted);
}

class PreferenceRowsCompanion extends UpdateCompanion<PreferenceRow> {
  final Value<int> id;
  final Value<String> defaultFilter;
  final Value<bool> animationsEnabled;
  final Value<bool> notificationPermissionPrompted;
  const PreferenceRowsCompanion({
    this.id = const Value.absent(),
    this.defaultFilter = const Value.absent(),
    this.animationsEnabled = const Value.absent(),
    this.notificationPermissionPrompted = const Value.absent(),
  });
  PreferenceRowsCompanion.insert({
    this.id = const Value.absent(),
    this.defaultFilter = const Value.absent(),
    this.animationsEnabled = const Value.absent(),
    this.notificationPermissionPrompted = const Value.absent(),
  });
  static Insertable<PreferenceRow> custom({
    Expression<int>? id,
    Expression<String>? defaultFilter,
    Expression<bool>? animationsEnabled,
    Expression<bool>? notificationPermissionPrompted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (defaultFilter != null) 'default_filter': defaultFilter,
      if (animationsEnabled != null) 'animations_enabled': animationsEnabled,
      if (notificationPermissionPrompted != null)
        'notification_permission_prompted': notificationPermissionPrompted,
    });
  }

  PreferenceRowsCompanion copyWith({
    Value<int>? id,
    Value<String>? defaultFilter,
    Value<bool>? animationsEnabled,
    Value<bool>? notificationPermissionPrompted,
  }) {
    return PreferenceRowsCompanion(
      id: id ?? this.id,
      defaultFilter: defaultFilter ?? this.defaultFilter,
      animationsEnabled: animationsEnabled ?? this.animationsEnabled,
      notificationPermissionPrompted:
          notificationPermissionPrompted ?? this.notificationPermissionPrompted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (defaultFilter.present) {
      map['default_filter'] = Variable<String>(defaultFilter.value);
    }
    if (animationsEnabled.present) {
      map['animations_enabled'] = Variable<bool>(animationsEnabled.value);
    }
    if (notificationPermissionPrompted.present) {
      map['notification_permission_prompted'] = Variable<bool>(
        notificationPermissionPrompted.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PreferenceRowsCompanion(')
          ..write('id: $id, ')
          ..write('defaultFilter: $defaultFilter, ')
          ..write('animationsEnabled: $animationsEnabled, ')
          ..write(
            'notificationPermissionPrompted: $notificationPermissionPrompted',
          )
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TaskRowsTable taskRows = $TaskRowsTable(this);
  late final $NotificationJobRowsTable notificationJobRows =
      $NotificationJobRowsTable(this);
  late final $ProfileRowsTable profileRows = $ProfileRowsTable(this);
  late final $PreferenceRowsTable preferenceRows = $PreferenceRowsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    taskRows,
    notificationJobRows,
    profileRows,
    preferenceRows,
  ];
}

typedef $$TaskRowsTableCreateCompanionBuilder =
    TaskRowsCompanion Function({
      required String id,
      required String title,
      Value<String> note,
      Value<DateTime?> dueDateTime,
      Value<bool> hasDueTime,
      required String priority,
      Value<bool> isCompleted,
      Value<DateTime?> completedAt,
      Value<bool> reminderEnabled,
      Value<String?> reminderOffset,
      required String reminderSyncStatus,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$TaskRowsTableUpdateCompanionBuilder =
    TaskRowsCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> note,
      Value<DateTime?> dueDateTime,
      Value<bool> hasDueTime,
      Value<String> priority,
      Value<bool> isCompleted,
      Value<DateTime?> completedAt,
      Value<bool> reminderEnabled,
      Value<String?> reminderOffset,
      Value<String> reminderSyncStatus,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$TaskRowsTableFilterComposer
    extends Composer<_$AppDatabase, $TaskRowsTable> {
  $$TaskRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueDateTime => $composableBuilder(
    column: $table.dueDateTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasDueTime => $composableBuilder(
    column: $table.hasDueTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get reminderEnabled => $composableBuilder(
    column: $table.reminderEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reminderOffset => $composableBuilder(
    column: $table.reminderOffset,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reminderSyncStatus => $composableBuilder(
    column: $table.reminderSyncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TaskRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $TaskRowsTable> {
  $$TaskRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueDateTime => $composableBuilder(
    column: $table.dueDateTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasDueTime => $composableBuilder(
    column: $table.hasDueTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get reminderEnabled => $composableBuilder(
    column: $table.reminderEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reminderOffset => $composableBuilder(
    column: $table.reminderOffset,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reminderSyncStatus => $composableBuilder(
    column: $table.reminderSyncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TaskRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TaskRowsTable> {
  $$TaskRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get dueDateTime => $composableBuilder(
    column: $table.dueDateTime,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get hasDueTime => $composableBuilder(
    column: $table.hasDueTime,
    builder: (column) => column,
  );

  GeneratedColumn<String> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get reminderEnabled => $composableBuilder(
    column: $table.reminderEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reminderOffset => $composableBuilder(
    column: $table.reminderOffset,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reminderSyncStatus => $composableBuilder(
    column: $table.reminderSyncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$TaskRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TaskRowsTable,
          TaskRow,
          $$TaskRowsTableFilterComposer,
          $$TaskRowsTableOrderingComposer,
          $$TaskRowsTableAnnotationComposer,
          $$TaskRowsTableCreateCompanionBuilder,
          $$TaskRowsTableUpdateCompanionBuilder,
          (TaskRow, BaseReferences<_$AppDatabase, $TaskRowsTable, TaskRow>),
          TaskRow,
          PrefetchHooks Function()
        > {
  $$TaskRowsTableTableManager(_$AppDatabase db, $TaskRowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaskRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaskRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TaskRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<DateTime?> dueDateTime = const Value.absent(),
                Value<bool> hasDueTime = const Value.absent(),
                Value<String> priority = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<bool> reminderEnabled = const Value.absent(),
                Value<String?> reminderOffset = const Value.absent(),
                Value<String> reminderSyncStatus = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TaskRowsCompanion(
                id: id,
                title: title,
                note: note,
                dueDateTime: dueDateTime,
                hasDueTime: hasDueTime,
                priority: priority,
                isCompleted: isCompleted,
                completedAt: completedAt,
                reminderEnabled: reminderEnabled,
                reminderOffset: reminderOffset,
                reminderSyncStatus: reminderSyncStatus,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                Value<String> note = const Value.absent(),
                Value<DateTime?> dueDateTime = const Value.absent(),
                Value<bool> hasDueTime = const Value.absent(),
                required String priority,
                Value<bool> isCompleted = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<bool> reminderEnabled = const Value.absent(),
                Value<String?> reminderOffset = const Value.absent(),
                required String reminderSyncStatus,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => TaskRowsCompanion.insert(
                id: id,
                title: title,
                note: note,
                dueDateTime: dueDateTime,
                hasDueTime: hasDueTime,
                priority: priority,
                isCompleted: isCompleted,
                completedAt: completedAt,
                reminderEnabled: reminderEnabled,
                reminderOffset: reminderOffset,
                reminderSyncStatus: reminderSyncStatus,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TaskRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TaskRowsTable,
      TaskRow,
      $$TaskRowsTableFilterComposer,
      $$TaskRowsTableOrderingComposer,
      $$TaskRowsTableAnnotationComposer,
      $$TaskRowsTableCreateCompanionBuilder,
      $$TaskRowsTableUpdateCompanionBuilder,
      (TaskRow, BaseReferences<_$AppDatabase, $TaskRowsTable, TaskRow>),
      TaskRow,
      PrefetchHooks Function()
    >;
typedef $$NotificationJobRowsTableCreateCompanionBuilder =
    NotificationJobRowsCompanion Function({
      Value<int> id,
      required String taskId,
      required String operation,
      Value<DateTime?> scheduledAt,
      Value<int> attemptCount,
      Value<String?> lastError,
      required DateTime createdAt,
    });
typedef $$NotificationJobRowsTableUpdateCompanionBuilder =
    NotificationJobRowsCompanion Function({
      Value<int> id,
      Value<String> taskId,
      Value<String> operation,
      Value<DateTime?> scheduledAt,
      Value<int> attemptCount,
      Value<String?> lastError,
      Value<DateTime> createdAt,
    });

class $$NotificationJobRowsTableFilterComposer
    extends Composer<_$AppDatabase, $NotificationJobRowsTable> {
  $$NotificationJobRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get taskId => $composableBuilder(
    column: $table.taskId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NotificationJobRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $NotificationJobRowsTable> {
  $$NotificationJobRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get taskId => $composableBuilder(
    column: $table.taskId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NotificationJobRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotificationJobRowsTable> {
  $$NotificationJobRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get taskId =>
      $composableBuilder(column: $table.taskId, builder: (column) => column);

  GeneratedColumn<String> get operation =>
      $composableBuilder(column: $table.operation, builder: (column) => column);

  GeneratedColumn<DateTime> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$NotificationJobRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NotificationJobRowsTable,
          NotificationJobRow,
          $$NotificationJobRowsTableFilterComposer,
          $$NotificationJobRowsTableOrderingComposer,
          $$NotificationJobRowsTableAnnotationComposer,
          $$NotificationJobRowsTableCreateCompanionBuilder,
          $$NotificationJobRowsTableUpdateCompanionBuilder,
          (
            NotificationJobRow,
            BaseReferences<
              _$AppDatabase,
              $NotificationJobRowsTable,
              NotificationJobRow
            >,
          ),
          NotificationJobRow,
          PrefetchHooks Function()
        > {
  $$NotificationJobRowsTableTableManager(
    _$AppDatabase db,
    $NotificationJobRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotificationJobRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotificationJobRowsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$NotificationJobRowsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> taskId = const Value.absent(),
                Value<String> operation = const Value.absent(),
                Value<DateTime?> scheduledAt = const Value.absent(),
                Value<int> attemptCount = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => NotificationJobRowsCompanion(
                id: id,
                taskId: taskId,
                operation: operation,
                scheduledAt: scheduledAt,
                attemptCount: attemptCount,
                lastError: lastError,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String taskId,
                required String operation,
                Value<DateTime?> scheduledAt = const Value.absent(),
                Value<int> attemptCount = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                required DateTime createdAt,
              }) => NotificationJobRowsCompanion.insert(
                id: id,
                taskId: taskId,
                operation: operation,
                scheduledAt: scheduledAt,
                attemptCount: attemptCount,
                lastError: lastError,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NotificationJobRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NotificationJobRowsTable,
      NotificationJobRow,
      $$NotificationJobRowsTableFilterComposer,
      $$NotificationJobRowsTableOrderingComposer,
      $$NotificationJobRowsTableAnnotationComposer,
      $$NotificationJobRowsTableCreateCompanionBuilder,
      $$NotificationJobRowsTableUpdateCompanionBuilder,
      (
        NotificationJobRow,
        BaseReferences<
          _$AppDatabase,
          $NotificationJobRowsTable,
          NotificationJobRow
        >,
      ),
      NotificationJobRow,
      PrefetchHooks Function()
    >;
typedef $$ProfileRowsTableCreateCompanionBuilder =
    ProfileRowsCompanion Function({
      Value<int> id,
      Value<String> displayName,
      Value<String?> avatarPath,
    });
typedef $$ProfileRowsTableUpdateCompanionBuilder =
    ProfileRowsCompanion Function({
      Value<int> id,
      Value<String> displayName,
      Value<String?> avatarPath,
    });

class $$ProfileRowsTableFilterComposer
    extends Composer<_$AppDatabase, $ProfileRowsTable> {
  $$ProfileRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get avatarPath => $composableBuilder(
    column: $table.avatarPath,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProfileRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProfileRowsTable> {
  $$ProfileRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avatarPath => $composableBuilder(
    column: $table.avatarPath,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProfileRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProfileRowsTable> {
  $$ProfileRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get avatarPath => $composableBuilder(
    column: $table.avatarPath,
    builder: (column) => column,
  );
}

class $$ProfileRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProfileRowsTable,
          ProfileRow,
          $$ProfileRowsTableFilterComposer,
          $$ProfileRowsTableOrderingComposer,
          $$ProfileRowsTableAnnotationComposer,
          $$ProfileRowsTableCreateCompanionBuilder,
          $$ProfileRowsTableUpdateCompanionBuilder,
          (
            ProfileRow,
            BaseReferences<_$AppDatabase, $ProfileRowsTable, ProfileRow>,
          ),
          ProfileRow,
          PrefetchHooks Function()
        > {
  $$ProfileRowsTableTableManager(_$AppDatabase db, $ProfileRowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProfileRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProfileRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProfileRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<String?> avatarPath = const Value.absent(),
              }) => ProfileRowsCompanion(
                id: id,
                displayName: displayName,
                avatarPath: avatarPath,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<String?> avatarPath = const Value.absent(),
              }) => ProfileRowsCompanion.insert(
                id: id,
                displayName: displayName,
                avatarPath: avatarPath,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProfileRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProfileRowsTable,
      ProfileRow,
      $$ProfileRowsTableFilterComposer,
      $$ProfileRowsTableOrderingComposer,
      $$ProfileRowsTableAnnotationComposer,
      $$ProfileRowsTableCreateCompanionBuilder,
      $$ProfileRowsTableUpdateCompanionBuilder,
      (
        ProfileRow,
        BaseReferences<_$AppDatabase, $ProfileRowsTable, ProfileRow>,
      ),
      ProfileRow,
      PrefetchHooks Function()
    >;
typedef $$PreferenceRowsTableCreateCompanionBuilder =
    PreferenceRowsCompanion Function({
      Value<int> id,
      Value<String> defaultFilter,
      Value<bool> animationsEnabled,
      Value<bool> notificationPermissionPrompted,
    });
typedef $$PreferenceRowsTableUpdateCompanionBuilder =
    PreferenceRowsCompanion Function({
      Value<int> id,
      Value<String> defaultFilter,
      Value<bool> animationsEnabled,
      Value<bool> notificationPermissionPrompted,
    });

class $$PreferenceRowsTableFilterComposer
    extends Composer<_$AppDatabase, $PreferenceRowsTable> {
  $$PreferenceRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get defaultFilter => $composableBuilder(
    column: $table.defaultFilter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get animationsEnabled => $composableBuilder(
    column: $table.animationsEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get notificationPermissionPrompted => $composableBuilder(
    column: $table.notificationPermissionPrompted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PreferenceRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $PreferenceRowsTable> {
  $$PreferenceRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get defaultFilter => $composableBuilder(
    column: $table.defaultFilter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get animationsEnabled => $composableBuilder(
    column: $table.animationsEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get notificationPermissionPrompted =>
      $composableBuilder(
        column: $table.notificationPermissionPrompted,
        builder: (column) => ColumnOrderings(column),
      );
}

class $$PreferenceRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PreferenceRowsTable> {
  $$PreferenceRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get defaultFilter => $composableBuilder(
    column: $table.defaultFilter,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get animationsEnabled => $composableBuilder(
    column: $table.animationsEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get notificationPermissionPrompted =>
      $composableBuilder(
        column: $table.notificationPermissionPrompted,
        builder: (column) => column,
      );
}

class $$PreferenceRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PreferenceRowsTable,
          PreferenceRow,
          $$PreferenceRowsTableFilterComposer,
          $$PreferenceRowsTableOrderingComposer,
          $$PreferenceRowsTableAnnotationComposer,
          $$PreferenceRowsTableCreateCompanionBuilder,
          $$PreferenceRowsTableUpdateCompanionBuilder,
          (
            PreferenceRow,
            BaseReferences<_$AppDatabase, $PreferenceRowsTable, PreferenceRow>,
          ),
          PreferenceRow,
          PrefetchHooks Function()
        > {
  $$PreferenceRowsTableTableManager(
    _$AppDatabase db,
    $PreferenceRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PreferenceRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PreferenceRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PreferenceRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> defaultFilter = const Value.absent(),
                Value<bool> animationsEnabled = const Value.absent(),
                Value<bool> notificationPermissionPrompted =
                    const Value.absent(),
              }) => PreferenceRowsCompanion(
                id: id,
                defaultFilter: defaultFilter,
                animationsEnabled: animationsEnabled,
                notificationPermissionPrompted: notificationPermissionPrompted,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> defaultFilter = const Value.absent(),
                Value<bool> animationsEnabled = const Value.absent(),
                Value<bool> notificationPermissionPrompted =
                    const Value.absent(),
              }) => PreferenceRowsCompanion.insert(
                id: id,
                defaultFilter: defaultFilter,
                animationsEnabled: animationsEnabled,
                notificationPermissionPrompted: notificationPermissionPrompted,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PreferenceRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PreferenceRowsTable,
      PreferenceRow,
      $$PreferenceRowsTableFilterComposer,
      $$PreferenceRowsTableOrderingComposer,
      $$PreferenceRowsTableAnnotationComposer,
      $$PreferenceRowsTableCreateCompanionBuilder,
      $$PreferenceRowsTableUpdateCompanionBuilder,
      (
        PreferenceRow,
        BaseReferences<_$AppDatabase, $PreferenceRowsTable, PreferenceRow>,
      ),
      PreferenceRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TaskRowsTableTableManager get taskRows =>
      $$TaskRowsTableTableManager(_db, _db.taskRows);
  $$NotificationJobRowsTableTableManager get notificationJobRows =>
      $$NotificationJobRowsTableTableManager(_db, _db.notificationJobRows);
  $$ProfileRowsTableTableManager get profileRows =>
      $$ProfileRowsTableTableManager(_db, _db.profileRows);
  $$PreferenceRowsTableTableManager get preferenceRows =>
      $$PreferenceRowsTableTableManager(_db, _db.preferenceRows);
}
