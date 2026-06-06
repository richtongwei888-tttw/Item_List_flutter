import 'package:drift/drift.dart';
import 'package:item_list_flutter/data/database/app_database.dart';
import 'package:item_list_flutter/features/tasks/domain/reminder_offset.dart';
import 'package:item_list_flutter/features/tasks/domain/reminder_policy.dart';
import 'package:item_list_flutter/features/tasks/domain/reminder_sync_status.dart';
import 'package:item_list_flutter/features/tasks/domain/task.dart';
import 'package:item_list_flutter/features/tasks/domain/task_priority.dart';

abstract interface class TaskRepository {
  Stream<List<Task>> watchAll();

  Future<List<Task>> getAll();

  Future<Task?> findById(String taskId);

  Future<void> save(Task task);

  Future<void> setCompleted(String taskId, DateTime completedAt);

  Future<void> restore(String taskId, DateTime restoredAt);

  Future<void> delete(String taskId, DateTime deletedAt);
}

final class DriftTaskRepository implements TaskRepository {
  DriftTaskRepository(this._database);

  final AppDatabase _database;

  @override
  Stream<List<Task>> watchAll() {
    return _database.watchTaskRows().map(
      (rows) => rows.map(_taskFromRow).toList(growable: false),
    );
  }

  @override
  Future<List<Task>> getAll() async {
    final rows = await _database.allTaskRows();
    return rows.map(_taskFromRow).toList(growable: false);
  }

  @override
  Future<Task?> findById(String taskId) async {
    final row = await _database.findTaskRow(taskId);
    return row == null ? null : _taskFromRow(row);
  }

  @override
  Future<void> save(Task task) {
    return _database.transaction(() => _writeTaskAndJob(task));
  }

  @override
  Future<void> setCompleted(String taskId, DateTime completedAt) {
    return _database.transaction(() async {
      final existing = await _requireTask(taskId);
      await _writeTaskAndJob(
        existing.copyWith(
          isCompleted: true,
          completedAt: completedAt,
          reminderSyncStatus: ReminderSyncStatus.pending,
          updatedAt: completedAt,
        ),
      );
    });
  }

  @override
  Future<void> restore(String taskId, DateTime restoredAt) {
    return _database.transaction(() async {
      final existing = await _requireTask(taskId);
      await _writeTaskAndJob(
        existing.copyWith(
          isCompleted: false,
          completedAt: null,
          reminderSyncStatus: ReminderSyncStatus.pending,
          updatedAt: restoredAt,
        ),
      );
    });
  }

  @override
  Future<void> delete(String taskId, DateTime deletedAt) {
    return _database.transaction(() async {
      await (_database.delete(
        _database.taskRows,
      )..where((row) => row.id.equals(taskId))).go();
      await _replaceNotificationJob(
        taskId: taskId,
        operation: 'cancel',
        createdAt: deletedAt,
      );
    });
  }

  Future<Task> _requireTask(String taskId) async {
    final task = await findById(taskId);
    if (task == null) {
      throw StateError('Task $taskId does not exist');
    }
    return task;
  }

  Future<void> _writeTaskAndJob(Task task) async {
    await _database
        .into(_database.taskRows)
        .insertOnConflictUpdate(
          TaskRowsCompanion.insert(
            id: task.id,
            title: task.title,
            note: Value(task.note),
            dueDateTime: Value(task.dueDate),
            hasDueTime: Value(task.hasDueTime),
            priority: task.priority.name,
            isCompleted: Value(task.isCompleted),
            completedAt: Value(task.completedAt),
            reminderEnabled: Value(task.reminderEnabled),
            reminderOffset: Value(task.reminderOffset?.name),
            reminderSyncStatus: task.reminderSyncStatus.name,
            createdAt: task.createdAt,
            updatedAt: task.updatedAt,
          ),
        );

    final scheduledAt =
        task.reminderEnabled && !task.isCompleted && task.reminderOffset != null
        ? ReminderPolicy.calculate(task, task.reminderOffset!, task.updatedAt)
        : null;
    await _replaceNotificationJob(
      taskId: task.id,
      operation: scheduledAt == null ? 'cancel' : 'schedule',
      scheduledAt: scheduledAt,
      createdAt: task.updatedAt,
    );
  }

  Future<void> _replaceNotificationJob({
    required String taskId,
    required String operation,
    DateTime? scheduledAt,
    required DateTime createdAt,
  }) async {
    await (_database.delete(
      _database.notificationJobRows,
    )..where((row) => row.taskId.equals(taskId))).go();
    await _database
        .into(_database.notificationJobRows)
        .insert(
          NotificationJobRowsCompanion.insert(
            taskId: taskId,
            operation: operation,
            scheduledAt: Value(scheduledAt),
            createdAt: createdAt,
          ),
        );
  }

  Task _taskFromRow(TaskRow row) {
    return Task.create(
      id: row.id,
      title: row.title,
      note: row.note,
      dueDate: row.dueDateTime,
      hasDueTime: row.hasDueTime,
      priority: TaskPriority.values.byName(row.priority),
      isCompleted: row.isCompleted,
      completedAt: row.completedAt,
      reminderEnabled: row.reminderEnabled,
      reminderOffset: row.reminderOffset == null
          ? null
          : ReminderOffset.values.byName(row.reminderOffset!),
      reminderSyncStatus: ReminderSyncStatus.values.byName(
        row.reminderSyncStatus,
      ),
      createdAt: row.createdAt,
      now: row.updatedAt,
    );
  }
}
