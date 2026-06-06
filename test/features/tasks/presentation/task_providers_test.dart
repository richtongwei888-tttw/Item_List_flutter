import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:item_list_flutter/features/tasks/application/task_repository.dart';
import 'package:item_list_flutter/features/tasks/domain/task.dart';
import 'package:item_list_flutter/features/tasks/domain/task_filter.dart';
import 'package:item_list_flutter/features/tasks/presentation/task_providers.dart';

void main() {
  late _StreamTaskRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = _StreamTaskRepository();
    container = ProviderContainer(
      overrides: [taskRepositoryProvider.overrideWithValue(repository)],
    );
    container.listen<AsyncValue<List<Task>>>(
      filteredTasksProvider,
      (_, _) {},
      fireImmediately: true,
    );
  });

  tearDown(() async {
    container.dispose();
    await repository.close();
  });

  test('filters pending completed and all tasks', () async {
    final pending = Task.test(id: 'pending');
    final completed = Task.test(
      id: 'completed',
      isCompleted: true,
      completedAt: DateTime(2026, 6, 6),
    );
    repository.emit([completed, pending]);
    await Future<void>.delayed(Duration.zero);

    expect(
      container.read(filteredTasksProvider).requireValue.map((task) => task.id),
      ['pending'],
    );

    container.read(taskFilterProvider.notifier).setFilter(TaskFilter.completed);
    expect(
      container.read(filteredTasksProvider).requireValue.map((task) => task.id),
      ['completed'],
    );

    container.read(taskFilterProvider.notifier).setFilter(TaskFilter.all);
    expect(
      container.read(filteredTasksProvider).requireValue.map((task) => task.id),
      ['pending', 'completed'],
    );
  });

  test('refreshes when repository emits new tasks', () async {
    repository.emit([Task.test(id: 'first')]);
    await Future<void>.delayed(Duration.zero);
    expect(container.read(filteredTasksProvider).requireValue, hasLength(1));

    repository.emit([Task.test(id: 'first'), Task.test(id: 'second')]);
    await Future<void>.delayed(Duration.zero);

    expect(container.read(filteredTasksProvider).requireValue, hasLength(2));
  });
}

final class _StreamTaskRepository implements TaskRepository {
  final _controller = StreamController<List<Task>>.broadcast(sync: true);
  List<Task> _tasks = const [];

  void emit(List<Task> tasks) {
    _tasks = tasks;
    _controller.add(tasks);
  }

  Future<void> close() => _controller.close();

  @override
  Future<void> delete(String taskId, DateTime deletedAt) async {}

  @override
  Future<Task?> findById(String taskId) async {
    return _tasks.where((task) => task.id == taskId).firstOrNull;
  }

  @override
  Future<List<Task>> getAll() async => _tasks;

  @override
  Future<void> restore(String taskId, DateTime restoredAt) async {}

  @override
  Future<void> save(Task task) async {}

  @override
  Future<void> setCompleted(String taskId, DateTime completedAt) async {}

  @override
  Stream<List<Task>> watchAll() => _controller.stream;
}
