import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:item_list_flutter/data/database/tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [TaskRows, NotificationJobRows, ProfileRows, PreferenceRows],
)
final class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  AppDatabase.defaults() : super(driftDatabase(name: 'clear_flow'));

  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;

  Stream<List<TaskRow>> watchTaskRows() => select(taskRows).watch();

  Future<List<TaskRow>> allTaskRows() => select(taskRows).get();

  Future<TaskRow?> findTaskRow(String taskId) {
    return (select(
      taskRows,
    )..where((row) => row.id.equals(taskId))).getSingleOrNull();
  }

  Future<List<NotificationJobRow>> pendingNotificationJobs() {
    return (select(
      notificationJobRows,
    )..orderBy([(row) => OrderingTerm.asc(row.createdAt)])).get();
  }

  Future<ProfileRow> getProfileRow() async {
    final row = await (select(
      profileRows,
    )..where((row) => row.id.equals(1))).getSingleOrNull();
    if (row != null) {
      return row;
    }
    await into(profileRows).insert(
      const ProfileRowsCompanion(id: Value(1)),
      mode: InsertMode.insertOrIgnore,
    );
    return (select(profileRows)..where((row) => row.id.equals(1))).getSingle();
  }

  Future<void> saveProfileRow({
    required String displayName,
    required String? avatarPath,
  }) {
    return into(profileRows).insertOnConflictUpdate(
      ProfileRowsCompanion(
        id: const Value(1),
        displayName: Value(displayName),
        avatarPath: Value(avatarPath),
      ),
    );
  }

  Future<PreferenceRow> getPreferenceRow() async {
    final row = await (select(
      preferenceRows,
    )..where((row) => row.id.equals(1))).getSingleOrNull();
    if (row != null) {
      return row;
    }
    await into(preferenceRows).insert(
      const PreferenceRowsCompanion(id: Value(1)),
      mode: InsertMode.insertOrIgnore,
    );
    return (select(
      preferenceRows,
    )..where((row) => row.id.equals(1))).getSingle();
  }

  Future<void> savePreferenceRow({
    required String defaultFilter,
    required bool animationsEnabled,
    required bool notificationPermissionPrompted,
  }) {
    return into(preferenceRows).insertOnConflictUpdate(
      PreferenceRowsCompanion(
        id: const Value(1),
        defaultFilter: Value(defaultFilter),
        animationsEnabled: Value(animationsEnabled),
        notificationPermissionPrompted: Value(notificationPermissionPrompted),
      ),
    );
  }

  Future<void> completeNotificationJob(
    int jobId,
    String taskId,
    String syncStatus,
  ) {
    return transaction(() async {
      await (delete(
        notificationJobRows,
      )..where((row) => row.id.equals(jobId))).go();
      await (update(taskRows)..where((row) => row.id.equals(taskId))).write(
        TaskRowsCompanion(reminderSyncStatus: Value(syncStatus)),
      );
    });
  }

  Future<void> failNotificationJob(
    int jobId,
    String taskId,
    String error,
    String syncStatus,
  ) {
    return transaction(() async {
      final job = await (select(
        notificationJobRows,
      )..where((row) => row.id.equals(jobId))).getSingleOrNull();
      if (job == null) {
        return;
      }
      await (update(
        notificationJobRows,
      )..where((row) => row.id.equals(jobId))).write(
        NotificationJobRowsCompanion(
          attemptCount: Value(job.attemptCount + 1),
          lastError: Value(error),
        ),
      );
      await (update(taskRows)..where((row) => row.id.equals(taskId))).write(
        TaskRowsCompanion(reminderSyncStatus: Value(syncStatus)),
      );
    });
  }
}
