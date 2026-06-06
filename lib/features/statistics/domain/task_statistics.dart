import 'package:item_list_flutter/core/time/date_time_extensions.dart';
import 'package:item_list_flutter/features/tasks/domain/task.dart';

final class TaskStatistics {
  const TaskStatistics({
    required this.pending,
    required this.completed,
    required this.total,
    required this.dueWithinThreeDays,
    required this.completionRate,
  });

  factory TaskStatistics.fromTasks(List<Task> tasks, DateTime now) {
    final completed = tasks.where((task) => task.isCompleted).length;
    final pendingTasks = tasks.where((task) => !task.isCompleted).toList();
    final today = now.dateOnly;
    final dueWithinThreeDays = pendingTasks.where((task) {
      final dueDate = task.dueDate;
      if (dueDate == null) {
        return false;
      }
      final days = dueDate.dateOnly.difference(today).inDays;
      return days >= 0 && days <= 2;
    }).length;

    return TaskStatistics(
      pending: pendingTasks.length,
      completed: completed,
      total: tasks.length,
      dueWithinThreeDays: dueWithinThreeDays,
      completionRate: tasks.isEmpty ? 0 : completed / tasks.length,
    );
  }

  final int pending;
  final int completed;
  final int total;
  final int dueWithinThreeDays;
  final double completionRate;
}
