import 'package:item_list_flutter/core/time/date_time_extensions.dart';
import 'package:item_list_flutter/features/tasks/domain/due_status.dart';
import 'package:item_list_flutter/features/tasks/domain/task.dart';

abstract final class TaskSorter {
  static List<Task> pending(Iterable<Task> tasks, DateTime now) {
    final result = tasks.where((task) => !task.isCompleted).toList();
    result.sort((left, right) => _comparePending(left, right, now));
    return result;
  }

  static List<Task> completed(Iterable<Task> tasks) {
    final result = tasks.where((task) => task.isCompleted).toList();
    result.sort((left, right) {
      final completionOrder = (right.completedAt ?? DateTime(0)).compareTo(
        left.completedAt ?? DateTime(0),
      );
      if (completionOrder != 0) {
        return completionOrder;
      }
      return right.createdAt.compareTo(left.createdAt);
    });
    return result;
  }

  static List<Task> all(Iterable<Task> tasks, DateTime now) => [
    ...pending(tasks, now),
    ...completed(tasks),
  ];

  static int _comparePending(Task left, Task right, DateTime now) {
    final statusOrder = _statusRank(
      DueStatus.from(left, now),
    ).compareTo(_statusRank(DueStatus.from(right, now)));
    if (statusOrder != 0) {
      return statusOrder;
    }

    final leftDue = left.dueDate;
    final rightDue = right.dueDate;
    if (leftDue != null && rightDue != null) {
      final dateOrder = leftDue.dateOnly.compareTo(rightDue.dateOnly);
      if (dateOrder != 0) {
        return dateOrder;
      }

      if (left.hasDueTime != right.hasDueTime) {
        return left.hasDueTime ? -1 : 1;
      }
      if (left.hasDueTime) {
        final timeOrder = leftDue.compareTo(rightDue);
        if (timeOrder != 0) {
          return timeOrder;
        }
      }
    }

    final priorityOrder = right.priority.sortWeight.compareTo(
      left.priority.sortWeight,
    );
    if (priorityOrder != 0) {
      return priorityOrder;
    }
    return right.createdAt.compareTo(left.createdAt);
  }

  static int _statusRank(DueStatus status) => switch (status) {
    DueStatus.overdue => 0,
    DueStatus.today => 1,
    DueStatus.tomorrow => 2,
    DueStatus.withinThreeDays => 3,
    DueStatus.later => 4,
    DueStatus.none => 5,
  };
}
