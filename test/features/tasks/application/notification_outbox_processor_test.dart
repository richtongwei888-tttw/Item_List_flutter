import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:item_list_flutter/data/database/app_database.dart';
import 'package:item_list_flutter/features/tasks/application/notification_gateway.dart';
import 'package:item_list_flutter/features/tasks/application/notification_outbox_processor.dart';
import 'package:item_list_flutter/features/tasks/application/task_repository.dart';
import 'package:item_list_flutter/features/tasks/domain/reminder_sync_status.dart';
import 'package:item_list_flutter/features/tasks/domain/task.dart';

void main() {
  late AppDatabase database;
  late DriftTaskRepository repository;
  late _FakeNotificationGateway gateway;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    repository = DriftTaskRepository(database);
    gateway = _FakeNotificationGateway();
  });

  tearDown(() => database.close());

  test('successful scheduling removes job and marks task synced', () async {
    await repository.save(
      Task.test(
        id: 'task-1',
        title: 'Dentist',
        dueDate: DateTime(2026, 6, 7, 12),
        reminderEnabled: true,
        reminderSyncStatus: ReminderSyncStatus.pending,
      ),
    );

    final result = await NotificationOutboxProcessor(
      database,
      gateway,
    ).processPending();

    expect(result.succeeded, 1);
    expect(await database.pendingNotificationJobs(), isEmpty);
    expect(
      (await repository.findById('task-1'))?.reminderSyncStatus,
      ReminderSyncStatus.synced,
    );
    expect(gateway.scheduledTaskIds, ['task-1']);
  });

  test('gateway failure preserves job and marks task failed', () async {
    gateway.shouldFail = true;
    await repository.save(
      Task.test(
        id: 'task-1',
        dueDate: DateTime(2026, 6, 7, 12),
        reminderEnabled: true,
        reminderSyncStatus: ReminderSyncStatus.pending,
      ),
    );

    final result = await NotificationOutboxProcessor(
      database,
      gateway,
    ).processPending();

    expect(result.failed, 1);
    final jobs = await database.pendingNotificationJobs();
    expect(jobs.single.attemptCount, 1);
    expect(jobs.single.lastError, contains('notification unavailable'));
    expect(
      (await repository.findById('task-1'))?.reminderSyncStatus,
      ReminderSyncStatus.failed,
    );
  });
}

final class _FakeNotificationGateway implements NotificationGateway {
  final scheduledTaskIds = <String>[];
  bool shouldFail = false;

  @override
  Future<void> cancel(String taskId) async {
    if (shouldFail) {
      throw StateError('notification unavailable');
    }
  }

  @override
  Future<void> schedule({
    required String taskId,
    required String title,
    required DateTime scheduledAt,
  }) async {
    if (shouldFail) {
      throw StateError('notification unavailable');
    }
    scheduledTaskIds.add(taskId);
  }
}
