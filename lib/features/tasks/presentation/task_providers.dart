import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:item_list_flutter/data/database/app_database.dart';
import 'package:item_list_flutter/features/statistics/domain/task_statistics.dart';
import 'package:item_list_flutter/features/tasks/application/task_repository.dart';
import 'package:item_list_flutter/features/tasks/application/task_service.dart';
import 'package:item_list_flutter/features/tasks/domain/task.dart';
import 'package:item_list_flutter/features/tasks/domain/task_filter.dart';
import 'package:item_list_flutter/features/tasks/domain/task_sorter.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase.defaults();
  ref.onDispose(database.close);
  return database;
});

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return DriftTaskRepository(ref.watch(appDatabaseProvider));
});

final taskServiceProvider = Provider<TaskService>((ref) {
  return TaskService(ref.watch(taskRepositoryProvider));
});

final currentTimeProvider = Provider<DateTime>((ref) => DateTime.now());

final taskStreamProvider = StreamProvider<List<Task>>((ref) {
  return ref.watch(taskRepositoryProvider).watchAll();
});

final taskFilterProvider = NotifierProvider<TaskFilterController, TaskFilter>(
  TaskFilterController.new,
);

final filteredTasksProvider = Provider<AsyncValue<List<Task>>>((ref) {
  final filter = ref.watch(taskFilterProvider);
  final now = ref.watch(currentTimeProvider);
  return ref.watch(taskStreamProvider).whenData((tasks) {
    return switch (filter) {
      TaskFilter.pending => TaskSorter.pending(tasks, now),
      TaskFilter.completed => TaskSorter.completed(tasks),
      TaskFilter.all => TaskSorter.all(tasks, now),
    };
  });
});

final taskStatisticsProvider = Provider<AsyncValue<TaskStatistics>>((ref) {
  final now = ref.watch(currentTimeProvider);
  return ref
      .watch(taskStreamProvider)
      .whenData((tasks) => TaskStatistics.fromTasks(tasks, now));
});

final class TaskFilterController extends Notifier<TaskFilter> {
  @override
  TaskFilter build() => TaskFilter.pending;

  void setFilter(TaskFilter filter) {
    state = filter;
  }
}
