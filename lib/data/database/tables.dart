import 'package:drift/drift.dart';

@DataClassName('TaskRow')
class TaskRows extends Table {
  TextColumn get id => text()();
  TextColumn get title => text().withLength(min: 1, max: 100)();
  TextColumn get note => text().withDefault(const Constant(''))();
  DateTimeColumn get dueDateTime => dateTime().nullable()();
  BoolColumn get hasDueTime => boolean().withDefault(const Constant(false))();
  TextColumn get priority => text()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get completedAt => dateTime().nullable()();
  BoolColumn get reminderEnabled =>
      boolean().withDefault(const Constant(false))();
  TextColumn get reminderOffset => text().nullable()();
  TextColumn get reminderSyncStatus => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('NotificationJobRow')
class NotificationJobRows extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get taskId => text()();
  TextColumn get operation => text()();
  DateTimeColumn get scheduledAt => dateTime().nullable()();
  IntColumn get attemptCount => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}

@DataClassName('ProfileRow')
class ProfileRows extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  TextColumn get displayName => text().withDefault(const Constant('用户'))();
  TextColumn get avatarPath => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('PreferenceRow')
class PreferenceRows extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  TextColumn get defaultFilter =>
      text().withDefault(const Constant('pending'))();
  BoolColumn get animationsEnabled =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get notificationPermissionPrompted =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
