import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:item_list_flutter/app/app_theme.dart';
import 'package:item_list_flutter/features/statistics/presentation/statistics_screen.dart';
import 'package:item_list_flutter/features/tasks/application/task_repository.dart';
import 'package:item_list_flutter/features/tasks/domain/task.dart';
import 'package:item_list_flutter/features/tasks/presentation/task_providers.dart';

void main() {
  testWidgets('shows four counts and completion rate', (tester) async {
    final tasks = [
      Task.test(
        id: 'pending',
        dueDate: DateTime(2026, 6, 7),
        hasDueTime: false,
      ),
      Task.test(
        id: 'completed',
        isCompleted: true,
        completedAt: DateTime(2026, 6, 6, 9),
      ),
    ];
    await tester.pumpWidget(_testApp(_StatisticsRepository(tasks)));
    await tester.pumpAndSettle();

    expect(find.text('50%'), findsOneWidget);
    expect(find.text('待处理'), findsOneWidget);
    expect(find.text('已完成'), findsOneWidget);
    expect(find.text('全部任务'), findsOneWidget);
    expect(find.text('近三天到期'), findsOneWidget);
    expect(find.text('1 项任务即将到期'), findsOneWidget);
  });

  testWidgets('empty task list displays zero percent', (tester) async {
    await tester.pumpWidget(_testApp(_StatisticsRepository(const [])));
    await tester.pumpAndSettle();

    expect(find.text('0%'), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
  });
}

Widget _testApp(TaskRepository repository) {
  return ProviderScope(
    overrides: [
      taskRepositoryProvider.overrideWithValue(repository),
      currentTimeProvider.overrideWithValue(DateTime(2026, 6, 6, 10)),
    ],
    child: MaterialApp(
      theme: ClearFlowTheme.light,
      home: const Scaffold(body: StatisticsScreen()),
    ),
  );
}

final class _StatisticsRepository implements TaskRepository {
  _StatisticsRepository(this.tasks);

  final List<Task> tasks;

  @override
  Future<void> delete(String taskId, DateTime deletedAt) async {}

  @override
  Future<Task?> findById(String taskId) async => null;

  @override
  Future<List<Task>> getAll() async => tasks;

  @override
  Future<void> restore(String taskId, DateTime restoredAt) async {}

  @override
  Future<void> save(Task task) async {}

  @override
  Future<void> setCompleted(String taskId, DateTime completedAt) async {}

  @override
  Stream<List<Task>> watchAll() => Stream.value(tasks);
}
