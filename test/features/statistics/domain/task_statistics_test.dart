import 'package:flutter_test/flutter_test.dart';
import 'package:item_list_flutter/features/statistics/domain/task_statistics.dart';
import 'package:item_list_flutter/features/tasks/domain/task.dart';

void main() {
  final now = DateTime(2026, 6, 6, 10);

  test('empty list has zero completion rate', () {
    final statistics = TaskStatistics.fromTasks(const [], now);

    expect(statistics.total, 0);
    expect(statistics.completionRate, 0);
  });

  test('derives counts and completion rate', () {
    final tasks = [
      Task.test(id: 'pending'),
      Task.test(
        id: 'completed',
        isCompleted: true,
        completedAt: DateTime(2026, 6, 6, 9),
      ),
    ];

    final statistics = TaskStatistics.fromTasks(tasks, now);

    expect(statistics.pending, 1);
    expect(statistics.completed, 1);
    expect(statistics.total, 2);
    expect(statistics.completionRate, 0.5);
  });

  test('near-term count includes today tomorrow and day after tomorrow', () {
    final tasks = [
      Task.test(id: 'today', dueDate: DateTime(2026, 6, 6), hasDueTime: false),
      Task.test(
        id: 'tomorrow',
        dueDate: DateTime(2026, 6, 7),
        hasDueTime: false,
      ),
      Task.test(
        id: 'day-after',
        dueDate: DateTime(2026, 6, 8),
        hasDueTime: false,
      ),
      Task.test(id: 'later', dueDate: DateTime(2026, 6, 9), hasDueTime: false),
    ];

    expect(TaskStatistics.fromTasks(tasks, now).dueWithinThreeDays, 3);
  });
}
