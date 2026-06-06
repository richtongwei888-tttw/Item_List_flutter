import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:item_list_flutter/app/app_theme.dart';
import 'package:item_list_flutter/core/errors/app_failure.dart';
import 'package:item_list_flutter/features/statistics/domain/task_statistics.dart';
import 'package:item_list_flutter/features/tasks/application/task_service.dart';
import 'package:item_list_flutter/features/tasks/domain/due_status.dart';
import 'package:item_list_flutter/features/tasks/domain/task.dart';
import 'package:item_list_flutter/features/tasks/domain/task_filter.dart';
import 'package:item_list_flutter/features/tasks/presentation/task_providers.dart';
import 'package:item_list_flutter/features/tasks/presentation/widgets/smart_summary_card.dart';
import 'package:item_list_flutter/features/tasks/presentation/widgets/task_card.dart';

class TaskListScreen extends ConsumerWidget {
  const TaskListScreen({super.key, this.onAddTask, this.onEditTask});

  final VoidCallback? onAddTask;
  final ValueChanged<Task>? onEditTask;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksValue = ref.watch(filteredTasksProvider);
    final allTasksValue = ref.watch(taskStreamProvider);
    final statisticsValue = ref.watch(taskStatisticsProvider);
    final now = ref.watch(currentTimeProvider);
    final filter = ref.watch(taskFilterProvider);
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;

    return tasksValue.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => _ErrorState(
        onRetry: () {
          ref.invalidate(taskStreamProvider);
        },
      ),
      data: (tasks) {
        final allTasks = allTasksValue.value ?? const <Task>[];
        final statistics =
            statisticsValue.value ?? TaskStatistics.fromTasks(allTasks, now);
        final overdueCount = allTasks
            .where((task) => DueStatus.from(task, now) == DueStatus.overdue)
            .length;
        final dueTodayCount = allTasks
            .where((task) => DueStatus.from(task, now) == DueStatus.today)
            .length;

        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
              sliver: SliverList.list(
                children: [
                  _Header(),
                  const SizedBox(height: 20),
                  SmartSummaryCard(
                    statistics: statistics,
                    overdueCount: overdueCount,
                    dueTodayCount: dueTodayCount,
                  ),
                  const SizedBox(height: 17),
                  _FilterRow(
                    selected: filter,
                    onSelected: (selected) {
                      ref.read(taskFilterProvider.notifier).setFilter(selected);
                    },
                  ),
                  const SizedBox(height: 13),
                ],
              ),
            ),
            if (tasks.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: _EmptyState(onAdd: onAddTask),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 110),
                sliver: SliverToBoxAdapter(
                  child: AnimatedSwitcher(
                    duration: reduceMotion
                        ? Duration.zero
                        : const Duration(milliseconds: 200),
                    switchInCurve: Curves.easeOutCubic,
                    child: Column(
                      key: ValueKey(filter),
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: _buildGroupedCards(context, ref, tasks, now),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  List<Widget> _buildGroupedCards(
    BuildContext context,
    WidgetRef ref,
    List<Task> tasks,
    DateTime now,
  ) {
    final groups = <String, List<Task>>{};
    for (final task in tasks) {
      final label = task.isCompleted
          ? '最近完成'
          : _groupLabel(DueStatus.from(task, now));
      groups.putIfAbsent(label, () => []).add(task);
    }

    return [
      for (final entry in groups.entries) ...[
        _SectionHeader(label: entry.key, count: entry.value.length),
        for (final task in entry.value) ...[
          TaskCard(
            task: task,
            now: now,
            onToggle: () => _toggleTask(context, ref, task, now),
            onEdit: () => onEditTask?.call(task),
            onDelete: () => _deleteTask(context, ref, task, now),
          ),
          const SizedBox(height: 9),
        ],
        const SizedBox(height: 5),
      ],
    ];
  }

  Future<void> _toggleTask(
    BuildContext context,
    WidgetRef ref,
    Task task,
    DateTime now,
  ) async {
    final service = ref.read(taskServiceProvider);
    final result = task.isCompleted
        ? await service.restore(task.id, now)
        : await service.complete(task.id, now);
    if (!context.mounted) {
      return;
    }
    if (result case TaskActionFailed(:final failure)) {
      _showFailure(context, failure);
      return;
    }
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(task.isCompleted ? '任务已恢复' : '任务已完成'),
          action: task.isCompleted
              ? null
              : SnackBarAction(
                  label: '撤销',
                  onPressed: () {
                    service.restore(task.id, DateTime.now());
                  },
                ),
        ),
      );
  }

  Future<void> _deleteTask(
    BuildContext context,
    WidgetRef ref,
    Task task,
    DateTime now,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('删除任务？'),
        content: Text('“${task.title}”将从本地任务中移除。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: FilledButton.styleFrom(
              backgroundColor: ClearFlowColors.coral,
            ),
            child: const Text('确认删除'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) {
      return;
    }
    final service = ref.read(taskServiceProvider);
    final result = await service.delete(task.id, now);
    if (!context.mounted) {
      return;
    }
    if (result case TaskActionFailed(:final failure)) {
      _showFailure(context, failure);
      return;
    }
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: const Text('任务已删除'),
          action: SnackBarAction(
            label: '撤销',
            onPressed: () {
              service.save(task.copyWith(updatedAt: DateTime.now()));
            },
          ),
        ),
      );
  }

  void _showFailure(BuildContext context, AppFailure failure) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(failure.message)));
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '早上好，用户',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: const Color(0xFF7C8174)),
              ),
              const SizedBox(height: 3),
              Text('把今天理清楚', style: Theme.of(context).textTheme.headlineMedium),
            ],
          ),
        ),
        Container(
          width: 42,
          height: 42,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: ClearFlowColors.sageSurface,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Text(
            '用',
            style: TextStyle(
              color: ClearFlowColors.sage,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}

class _FilterRow extends StatelessWidget {
  const _FilterRow({required this.selected, required this.onSelected});

  final TaskFilter selected;
  final ValueChanged<TaskFilter> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: [
        for (final option in const [
          (TaskFilter.pending, '待处理'),
          (TaskFilter.completed, '已完成'),
          (TaskFilter.all, '全部'),
        ])
          ChoiceChip(
            label: Text(option.$2),
            selected: selected == option.$1,
            onSelected: (_) => onSelected(option.$1),
            showCheckmark: false,
          ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label, required this.count});

  final String label;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 8, 2, 9),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
          Text('$count', style: Theme.of(context).textTheme.labelMedium),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({this.onAdd});

  final VoidCallback? onAdd;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 12, 28, 120),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 78,
            height: 78,
            decoration: const BoxDecoration(
              color: ClearFlowColors.sageSurface,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.checklist_rounded,
              size: 38,
              color: ClearFlowColors.sage,
            ),
          ),
          const SizedBox(height: 18),
          Text('还没有任务', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 7),
          Text(
            '从一件小事开始吧',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: const Color(0xFF73796E)),
          ),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: onAdd ?? () {},
            icon: const Icon(Icons.add_rounded),
            label: const Text('新增任务'),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('未能读取本地任务'),
          const SizedBox(height: 10),
          OutlinedButton(onPressed: onRetry, child: const Text('重试')),
        ],
      ),
    );
  }
}

String _groupLabel(DueStatus status) => switch (status) {
  DueStatus.overdue => '已逾期',
  DueStatus.today => '今天',
  DueStatus.tomorrow => '明天',
  DueStatus.withinThreeDays => '三天内',
  DueStatus.later => '以后',
  DueStatus.none => '无截止日期',
};
