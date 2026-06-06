import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:item_list_flutter/app/app_theme.dart';
import 'package:item_list_flutter/features/tasks/application/task_repository.dart';
import 'package:item_list_flutter/features/tasks/domain/reminder_offset.dart';
import 'package:item_list_flutter/features/tasks/domain/reminder_sync_status.dart';
import 'package:item_list_flutter/features/tasks/domain/task.dart';
import 'package:item_list_flutter/features/tasks/domain/task_priority.dart';
import 'package:item_list_flutter/features/tasks/presentation/task_form_screen.dart';
import 'package:item_list_flutter/features/tasks/presentation/task_providers.dart';

void main() {
  testWidgets('requires a non-empty title', (tester) async {
    await tester.pumpWidget(_testApp(_FormTaskRepository()));

    await tester.tap(find.text('保存任务'));
    await tester.pump();

    expect(find.text('请输入任务标题'), findsOneWidget);
  });

  testWidgets('defaults to normal priority and disables time without date', (
    tester,
  ) async {
    await tester.pumpWidget(_testApp(_FormTaskRepository()));

    final priority = tester.widget<SegmentedButton<TaskPriority>>(
      find.byType(SegmentedButton<TaskPriority>),
    );
    expect(priority.selected, {TaskPriority.normal});

    final timeButton = tester.widget<OutlinedButton>(
      find.widgetWithText(OutlinedButton, '设置时间'),
    );
    expect(timeButton.onPressed, isNull);
  });

  testWidgets('date-only and timed tasks expose their default reminder', (
    tester,
  ) async {
    await tester.pumpWidget(
      _testApp(
        _FormTaskRepository(),
        task: Task.test(
          dueDate: DateTime(2026, 6, 7),
          hasDueTime: false,
          reminderEnabled: true,
          reminderOffset: ReminderOffset.dateAtNine,
          reminderSyncStatus: ReminderSyncStatus.pending,
        ),
      ),
    );

    expect(find.text('当天 09:00'), findsOneWidget);

    await tester.pumpWidget(
      _testApp(
        _FormTaskRepository(),
        task: Task.test(
          dueDate: DateTime(2026, 6, 7, 18),
          reminderEnabled: true,
          reminderOffset: ReminderOffset.twoHours,
          reminderSyncStatus: ReminderSyncStatus.pending,
        ),
      ),
    );
    await tester.pump();

    expect(find.text('提前 2 小时'), findsOneWidget);
  });

  testWidgets('repository failure keeps input and shows error', (tester) async {
    final repository = _FormTaskRepository()..shouldFail = true;
    await tester.pumpWidget(_testApp(repository));

    await tester.enterText(find.byType(TextFormField).first, '整理旅行清单');
    await tester.tap(find.text('保存任务'));
    await tester.pumpAndSettle();

    expect(find.text('整理旅行清单'), findsOneWidget);
    expect(find.text('未能保存更改，已恢复到操作前状态'), findsOneWidget);
  });

  testWidgets('successful save returns the created task', (tester) async {
    Task? saved;
    await tester.pumpWidget(
      _testApp(_FormTaskRepository(), onSaved: (task) => saved = task),
    );

    await tester.enterText(find.byType(TextFormField).first, '预约牙医');
    await tester.tap(find.text('保存任务'));
    await tester.pumpAndSettle();

    expect(saved?.title, '预约牙医');
    expect(saved?.priority, TaskPriority.normal);
  });

  testWidgets('past reminder offers immediate reminder or reminder off', (
    tester,
  ) async {
    await tester.pumpWidget(
      _testApp(
        _FormTaskRepository(),
        task: Task.test(
          dueDate: DateTime(2026, 6, 6, 11),
          reminderEnabled: true,
          reminderOffset: ReminderOffset.twoHours,
          reminderSyncStatus: ReminderSyncStatus.pending,
        ),
      ),
    );

    await tester.tap(find.text('保存任务'));
    await tester.pumpAndSettle();

    expect(find.text('提醒时间已过'), findsOneWidget);
    expect(find.text('立即提醒'), findsOneWidget);
    expect(find.text('关闭提醒'), findsOneWidget);
  });
}

Widget _testApp(
  _FormTaskRepository repository, {
  Task? task,
  ValueChanged<Task>? onSaved,
}) {
  return ProviderScope(
    overrides: [
      taskRepositoryProvider.overrideWithValue(repository),
      currentTimeProvider.overrideWithValue(DateTime(2026, 6, 6, 10)),
    ],
    child: MaterialApp(
      theme: ClearFlowTheme.light,
      home: TaskFormScreen(
        key: ValueKey(task?.dueDate),
        task: task,
        onSaved: onSaved,
      ),
    ),
  );
}

final class _FormTaskRepository implements TaskRepository {
  final tasks = <String, Task>{};
  bool shouldFail = false;

  @override
  Future<void> delete(String taskId, DateTime deletedAt) async {}

  @override
  Future<Task?> findById(String taskId) async => tasks[taskId];

  @override
  Future<List<Task>> getAll() async => tasks.values.toList();

  @override
  Future<void> restore(String taskId, DateTime restoredAt) async {}

  @override
  Future<void> save(Task task) async {
    if (shouldFail) {
      throw StateError('database unavailable');
    }
    tasks[task.id] = task;
  }

  @override
  Future<void> setCompleted(String taskId, DateTime completedAt) async {}

  @override
  Stream<List<Task>> watchAll() => const Stream.empty();
}
