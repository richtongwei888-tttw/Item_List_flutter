import 'package:item_list_flutter/features/tasks/domain/reminder_offset.dart';
import 'package:item_list_flutter/features/tasks/domain/task.dart';

abstract final class ReminderPolicy {
  static DateTime? calculate(Task task, ReminderOffset offset, DateTime now) {
    final dueDate = task.dueDate;
    if (!task.reminderEnabled || dueDate == null || task.isCompleted) {
      return null;
    }

    final dueMoment = task.hasDueTime
        ? dueDate
        : DateTime(dueDate.year, dueDate.month, dueDate.day, 23, 59, 59);
    if (!dueMoment.isAfter(now)) {
      return null;
    }

    if (offset == ReminderOffset.immediate) {
      return now.add(const Duration(seconds: 1));
    }

    final scheduledAt = task.hasDueTime
        ? dueDate.subtract(offset.duration ?? Duration.zero)
        : DateTime(dueDate.year, dueDate.month, dueDate.day, 9);
    return scheduledAt.isAfter(now) ? scheduledAt : null;
  }
}
