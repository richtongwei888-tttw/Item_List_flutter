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
}
