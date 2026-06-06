import 'package:flutter_test/flutter_test.dart';
import 'package:item_list_flutter/core/errors/app_failure.dart';
import 'package:item_list_flutter/features/tasks/application/task_repository.dart';
import 'package:item_list_flutter/features/tasks/application/task_service.dart';
import 'package:item_list_flutter/features/tasks/domain/task.dart';

void main() {
  late _FakeTaskRepository repository;
  late TaskService service;

  setUp(() {
    repository = _FakeTaskRepository();
    service = TaskService(repository);
  });

  test('repository failure returns persistence failure', () async {
    repository.shouldFail = true;

    final result = await service.save(Task.test());

    expect(result, isA<TaskActionFailed>());
    expect((result as TaskActionFailed).failure, isA<PersistenceFailure>());
  });

  test('complete stores completion time', () async {
    repository.tasks['task'] = Task.test();
    final completedAt = DateTime(2026, 6, 6, 10);

    final result = await service.complete('task', completedAt);

    expect(result, isA<TaskActionSuccess>());
    expect(repository.tasks['task']?.isCompleted, isTrue);
    expect(repository.tasks['task']?.completedAt, completedAt);
  });

  test('restore clears completion time', () async {
    repository.tasks['task'] = Task.test(
      isCompleted: true,
      completedAt: DateTime(2026, 6, 6, 9),
    );

    final result = await service.restore('task', DateTime(2026, 6, 6, 10));

    expect(result, isA<TaskActionSuccess>());
    expect(repository.tasks['task']?.isCompleted, isFalse);
    expect(repository.tasks['task']?.completedAt, isNull);
  });

  test('successful persistence triggers the post-mutation handler', () async {
    var handled = 0;
    service = TaskService(
      repository,
      afterMutation: () async {
        handled++;
      },
    );

    final result = await service.save(Task.test());

    expect(result, isA<TaskActionSuccess>());
    expect(handled, 1);
  });

  test(
    'post-mutation failure does not turn a saved task into failure',
    () async {
      service = TaskService(
        repository,
        afterMutation: () async {
          throw StateError('notification unavailable');
        },
      );

      final result = await service.save(Task.test());

      expect(result, isA<TaskActionSuccess>());
      expect(repository.tasks, contains('task'));
    },
  );
}

final class _FakeTaskRepository implements TaskRepository {
  final tasks = <String, Task>{};
  bool shouldFail = false;

  @override
  Future<void> delete(String taskId, DateTime deletedAt) async {
    _throwWhenRequested();
    tasks.remove(taskId);
  }

  @override
  Future<Task?> findById(String taskId) async => tasks[taskId];

  @override
  Future<List<Task>> getAll() async => tasks.values.toList();

  @override
  Future<void> restore(String taskId, DateTime restoredAt) async {
    _throwWhenRequested();
    tasks[taskId] = tasks[taskId]!.copyWith(
      isCompleted: false,
      completedAt: null,
      updatedAt: restoredAt,
    );
  }

  @override
  Future<void> save(Task task) async {
    _throwWhenRequested();
    tasks[task.id] = task;
  }

  @override
  Future<void> setCompleted(String taskId, DateTime completedAt) async {
    _throwWhenRequested();
    tasks[taskId] = tasks[taskId]!.copyWith(
      isCompleted: true,
      completedAt: completedAt,
      updatedAt: completedAt,
    );
  }

  @override
  Stream<List<Task>> watchAll() => Stream.value(tasks.values.toList());

  void _throwWhenRequested() {
    if (shouldFail) {
      throw StateError('database unavailable');
    }
  }
}
