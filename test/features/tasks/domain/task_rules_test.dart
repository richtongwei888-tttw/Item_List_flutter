import 'package:flutter_test/flutter_test.dart';
import 'package:item_list_flutter/features/tasks/domain/due_status.dart';
import 'package:item_list_flutter/features/tasks/domain/reminder_offset.dart';
import 'package:item_list_flutter/features/tasks/domain/reminder_policy.dart';
import 'package:item_list_flutter/features/tasks/domain/task.dart';
import 'package:item_list_flutter/features/tasks/domain/task_priority.dart';
import 'package:item_list_flutter/features/tasks/domain/task_sorter.dart';

void main() {
  final now = DateTime(2026, 6, 6, 10);

  group('Task validation', () {
    test('rejects a blank title', () {
      expect(
        () => Task.create(id: 'task', title: '   ', now: now),
        throwsArgumentError,
      );
    });

    test('rejects notes longer than 2000 characters', () {
      expect(
        () =>
            Task.create(id: 'task', title: 'Title', note: 'x' * 2001, now: now),
        throwsArgumentError,
      );
    });

    test('completed task requires a completion time', () {
      expect(
        () => Task.create(
          id: 'task',
          title: 'Title',
          isCompleted: true,
          now: now,
        ),
        throwsArgumentError,
      );
    });
  });

  group('DueStatus', () {
    test('date-only task becomes overdue after its local day ends', () {
      final task = Task.test(dueDate: DateTime(2026, 6, 5), hasDueTime: false);

      expect(DueStatus.from(task, now), DueStatus.overdue);
    });

    test('date-only task remains due today before midnight', () {
      final task = Task.test(dueDate: DateTime(2026, 6, 6), hasDueTime: false);

      expect(DueStatus.from(task, now), DueStatus.today);
    });

    test('timed task becomes overdue immediately after its time', () {
      final task = Task.test(dueDate: DateTime(2026, 6, 6, 9));

      expect(DueStatus.from(task, now), DueStatus.overdue);
    });

    test('classifies tomorrow and the following two days', () {
      expect(
        DueStatus.from(
          Task.test(dueDate: DateTime(2026, 6, 7), hasDueTime: false),
          now,
        ),
        DueStatus.tomorrow,
      );
      expect(
        DueStatus.from(
          Task.test(dueDate: DateTime(2026, 6, 8), hasDueTime: false),
          now,
        ),
        DueStatus.withinThreeDays,
      );
      expect(
        DueStatus.from(
          Task.test(dueDate: DateTime(2026, 6, 9), hasDueTime: false),
          now,
        ),
        DueStatus.withinThreeDays,
      );
    });
  });

  group('TaskSorter', () {
    test('same due moment sorts high priority before normal priority', () {
      final due = DateTime(2026, 6, 7, 12);
      final high = Task.test(
        id: 'high',
        dueDate: due,
        priority: TaskPriority.high,
      );
      final normal = Task.test(id: 'normal', dueDate: due);

      expect(TaskSorter.pending([normal, high], now).map((task) => task.id), [
        'high',
        'normal',
      ]);
    });

    test('sorts overdue before today and undated tasks last', () {
      final overdue = Task.test(
        id: 'overdue',
        dueDate: DateTime(2026, 6, 5),
        hasDueTime: false,
      );
      final today = Task.test(
        id: 'today',
        dueDate: DateTime(2026, 6, 6),
        hasDueTime: false,
      );
      final undated = Task.test(id: 'undated');

      expect(
        TaskSorter.pending([
          undated,
          today,
          overdue,
        ], now).map((task) => task.id),
        ['overdue', 'today', 'undated'],
      );
    });

    test('completed tasks sort by most recent completion first', () {
      final older = Task.test(
        id: 'older',
        isCompleted: true,
        completedAt: DateTime(2026, 6, 5),
      );
      final newer = Task.test(
        id: 'newer',
        isCompleted: true,
        completedAt: DateTime(2026, 6, 6),
      );

      expect(TaskSorter.completed([older, newer]).map((task) => task.id), [
        'newer',
        'older',
      ]);
    });
  });

  group('ReminderPolicy', () {
    test('timed reminder defaults to two hours before due time', () {
      final task = Task.test(
        dueDate: DateTime(2026, 6, 6, 18),
        reminderEnabled: true,
      );

      expect(
        ReminderPolicy.calculate(task, ReminderOffset.twoHours, now),
        DateTime(2026, 6, 6, 16),
      );
    });

    test('date-only reminder defaults to 09:00 on due date', () {
      final task = Task.test(
        dueDate: DateTime(2026, 6, 7),
        hasDueTime: false,
        reminderEnabled: true,
      );

      expect(
        ReminderPolicy.calculate(task, ReminderOffset.dateAtNine, now),
        DateTime(2026, 6, 7, 9),
      );
    });

    test('does not schedule reminders in the past', () {
      final task = Task.test(
        dueDate: DateTime(2026, 6, 6, 11),
        reminderEnabled: true,
      );

      expect(
        ReminderPolicy.calculate(task, ReminderOffset.twoHours, now),
        isNull,
      );
    });

    test('immediate reminder schedules one second after now', () {
      final task = Task.test(
        dueDate: DateTime(2026, 6, 6, 11),
        reminderEnabled: true,
        reminderOffset: ReminderOffset.immediate,
      );

      expect(
        ReminderPolicy.calculate(task, ReminderOffset.immediate, now),
        now.add(const Duration(seconds: 1)),
      );
    });
  });
}
