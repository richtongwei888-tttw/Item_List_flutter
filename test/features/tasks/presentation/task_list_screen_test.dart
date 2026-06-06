import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:item_list_flutter/app/app_theme.dart';
import 'package:item_list_flutter/features/tasks/application/task_repository.dart';
import 'package:item_list_flutter/features/tasks/domain/task.dart';
import 'package:item_list_flutter/features/tasks/presentation/task_list_screen.dart';
import 'package:item_list_flutter/features/tasks/presentation/task_providers.dart';

void main() {
  testWidgets('shows empty state and add action', (tester) async {
    final repository = _WidgetTaskRepository(const []);
    await tester.pumpWidget(_testApp(repository));
    await tester.pumpAndSettle();

    expect(find.text('还没有任务'), findsOneWidget);
    expect(find.text('从一件小事开始吧'), findsOneWidget);
    expect(find.text('新增任务'), findsOneWidget);
  });

  testWidgets('shows smart summary and filters completed tasks', (
    tester,
  ) async {
    final repository = _WidgetTaskRepository([
      Task.test(
        id: 'overdue',
        title: '逾期任务',
        dueDate: DateTime(2026, 6, 5),
        hasDueTime: false,
      ),
      Task.test(
        id: 'today',
        title: '今日任务',
        dueDate: DateTime(2026, 6, 6),
        hasDueTime: false,
      ),
      Task.test(
        id: 'done',
        title: '完成任务',
        isCompleted: true,
        completedAt: DateTime(2026, 6, 6, 9),
      ),
    ]);
    await tester.pumpWidget(_testApp(repository));
    await tester.pumpAndSettle();

    expect(find.text('今天，先完成这 2 件事'), findsOneWidget);
    expect(find.text('1 项已逾期，1 项今天截止'), findsOneWidget);
    expect(find.text('逾期任务'), findsOneWidget);
    expect(find.text('完成任务'), findsNothing);

    await tester.tap(find.text('已完成'));
    await tester.pumpAndSettle();

    expect(find.text('完成任务'), findsOneWidget);
    expect(find.text('逾期任务'), findsNothing);
  });

  testWidgets('completion shows undo snackbar', (tester) async {
    final repository = _WidgetTaskRepository([Task.test(id: 'task-1')]);
    await tester.pumpWidget(_testApp(repository));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('标记为已完成'));
    await tester.pumpAndSettle();

    expect(find.text('任务已完成'), findsOneWidget);
    expect(find.text('撤销'), findsOneWidget);
  });
}

Widget _testApp(_WidgetTaskRepository repository) {
  return ProviderScope(
    overrides: [
      taskRepositoryProvider.overrideWithValue(repository),
      currentTimeProvider.overrideWithValue(DateTime(2026, 6, 6, 10)),
    ],
    child: MaterialApp(
      theme: ClearFlowTheme.light,
      home: const Scaffold(body: TaskListScreen()),
    ),
  );
}

final class _WidgetTaskRepository implements TaskRepository {
  _WidgetTaskRepository(List<Task> tasks) : _tasks = [...tasks];

  final _controller = StreamController<List<Task>>.broadcast(sync: true);
  final List<Task> _tasks;

  void _emit() => _controller.add(List.unmodifiable(_tasks));

  @override
  Future<void> delete(String taskId, DateTime deletedAt) async {
    _tasks.removeWhere((task) => task.id == taskId);
    _emit();
  }

  @override
  Future<Task?> findById(String taskId) async {
    return _tasks.where((task) => task.id == taskId).firstOrNull;
  }

  @override
  Future<List<Task>> getAll() async => List.unmodifiable(_tasks);

  @override
  Future<void> restore(String taskId, DateTime restoredAt) async {
    final index = _tasks.indexWhere((task) => task.id == taskId);
    _tasks[index] = _tasks[index].copyWith(
      isCompleted: false,
      completedAt: null,
      updatedAt: restoredAt,
    );
    _emit();
  }

  @override
  Future<void> save(Task task) async {
    final index = _tasks.indexWhere((item) => item.id == task.id);
    if (index == -1) {
      _tasks.add(task);
    } else {
      _tasks[index] = task;
    }
    _emit();
  }

  @override
  Future<void> setCompleted(String taskId, DateTime completedAt) async {
    final index = _tasks.indexWhere((task) => task.id == taskId);
    _tasks[index] = _tasks[index].copyWith(
      isCompleted: true,
      completedAt: completedAt,
      updatedAt: completedAt,
    );
    _emit();
  }

  @override
  Stream<List<Task>> watchAll() async* {
    yield List.unmodifiable(_tasks);
    yield* _controller.stream;
  }
}
