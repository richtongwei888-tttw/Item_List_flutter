import 'package:item_list_flutter/core/time/date_time_extensions.dart';
import 'package:item_list_flutter/features/tasks/domain/task.dart';

enum DueStatus {
  overdue,
  today,
  tomorrow,
  withinThreeDays,
  later,
  none;

  static DueStatus from(Task task, DateTime now) {
    final dueDate = task.dueDate;
    if (task.isCompleted || dueDate == null) {
      return DueStatus.none;
    }

    final effectiveDue = task.hasDueTime ? dueDate : dueDate.endOfDay;
    if (effectiveDue.isBefore(now)) {
      return DueStatus.overdue;
    }

    final days = dueDate.dateOnly.difference(now.dateOnly).inDays;
    return switch (days) {
      0 => DueStatus.today,
      1 => DueStatus.tomorrow,
      2 || 3 => DueStatus.withinThreeDays,
      _ => DueStatus.later,
    };
  }
}
