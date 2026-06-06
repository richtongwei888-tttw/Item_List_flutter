import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:item_list_flutter/data/database/app_database.dart';
import 'package:item_list_flutter/features/tasks/application/task_repository.dart';
import 'package:item_list_flutter/features/tasks/domain/reminder_sync_status.dart';
import 'package:item_list_flutter/features/tasks/domain/task.dart';

void main() {
  late AppDatabase database;
  late DriftTaskRepository repository;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    repository = DriftTaskRepository(database);
  });

  tearDown(() => database.close());

  test(
    'saving a reminder task writes task and schedule job atomically',
    () async {
      final task = Task.test(
        id: 'task-1',
        dueDate: DateTime(2026, 6, 7, 12),
        reminderEnabled: true,
        reminderSyncStatus: ReminderSyncStatus.pending,
      );

      await repository.save(task);

      expect(await repository.findById('task-1'), task);
      final jobs = await database.pendingNotificationJobs();
      expect(jobs, hasLength(1));
      expect(jobs.single.taskId, 'task-1');
      expect(jobs.single.operation, 'schedule');
      expect(jobs.single.scheduledAt, DateTime(2026, 6, 7, 10));
    },
  );

  test('saving an edited task replaces its previous pending job', () async {
    final original = Task.test(
      id: 'task-1',
      dueDate: DateTime(2026, 6, 7, 12),
      reminderEnabled: true,
      reminderSyncStatus: ReminderSyncStatus.pending,
    );
    final edited = original.copyWith(
      dueDate: DateTime(2026, 6, 8, 18),
      updatedAt: DateTime(2026, 6, 1, 10),
    );

    await repository.save(original);
    await repository.save(edited);

    final jobs = await database.pendingNotificationJobs();
    expect(jobs, hasLength(1));
    expect(jobs.single.scheduledAt, DateTime(2026, 6, 8, 16));
  });

  test(
    'completing and restoring updates completion fields and outbox',
    () async {
      final task = Task.test(
        id: 'task-1',
        dueDate: DateTime(2026, 6, 7, 12),
        reminderEnabled: true,
        reminderSyncStatus: ReminderSyncStatus.pending,
      );
      await repository.save(task);

      final completedAt = DateTime(2026, 6, 6, 10);
      await repository.setCompleted('task-1', completedAt);

      final completed = await repository.findById('task-1');
      expect(completed?.isCompleted, isTrue);
      expect(completed?.completedAt, completedAt);
      expect(
        (await database.pendingNotificationJobs()).single.operation,
        'cancel',
      );

      final restoredAt = DateTime(2026, 6, 6, 10, 5);
      await repository.restore('task-1', restoredAt);

      final restored = await repository.findById('task-1');
      expect(restored?.isCompleted, isFalse);
      expect(restored?.completedAt, isNull);
      expect(
        (await database.pendingNotificationJobs()).single.operation,
        'schedule',
      );
    },
  );

  test('deleting removes the task and leaves a cancel job', () async {
    await repository.save(Task.test(id: 'task-1'));

    await repository.delete('task-1', DateTime(2026, 6, 6, 10));

    expect(await repository.findById('task-1'), isNull);
    final jobs = await database.pendingNotificationJobs();
    expect(jobs, hasLength(1));
    expect(jobs.single.taskId, 'task-1');
    expect(jobs.single.operation, 'cancel');
  });
}
