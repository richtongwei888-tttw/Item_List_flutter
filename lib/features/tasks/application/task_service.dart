import 'package:item_list_flutter/core/errors/app_failure.dart';
import 'package:item_list_flutter/features/tasks/application/task_repository.dart';
import 'package:item_list_flutter/features/tasks/domain/task.dart';

sealed class TaskActionResult {
  const TaskActionResult();
}

final class TaskActionSuccess extends TaskActionResult {
  const TaskActionSuccess();
}

final class TaskActionFailed extends TaskActionResult {
  const TaskActionFailed(this.failure);

  final AppFailure failure;
}

final class TaskService {
  const TaskService(this._repository);

  final TaskRepository _repository;

  Future<TaskActionResult> save(Task task) {
    return _run(() => _repository.save(task));
  }

  Future<TaskActionResult> complete(String taskId, DateTime completedAt) {
    return _run(() => _repository.setCompleted(taskId, completedAt));
  }

  Future<TaskActionResult> restore(String taskId, DateTime restoredAt) {
    return _run(() => _repository.restore(taskId, restoredAt));
  }

  Future<TaskActionResult> delete(String taskId, DateTime deletedAt) {
    return _run(() => _repository.delete(taskId, deletedAt));
  }

  Future<TaskActionResult> _run(Future<void> Function() operation) async {
    try {
      await operation();
      return const TaskActionSuccess();
    } on ArgumentError catch (error) {
      return TaskActionFailed(ValidationFailure(error.message.toString()));
    } on Object {
      return const TaskActionFailed(PersistenceFailure());
    }
  }
}
