import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:item_list_flutter/app/app_theme.dart';
import 'package:item_list_flutter/core/time/date_time_extensions.dart';
import 'package:item_list_flutter/features/tasks/domain/due_status.dart';
import 'package:item_list_flutter/features/tasks/domain/task.dart';
import 'package:item_list_flutter/features/tasks/domain/task_priority.dart';

class TaskCard extends StatefulWidget {
  const TaskCard({
    super.key,
    required this.task,
    required this.now,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  final Task task;
  final DateTime now;
  final Future<void> Function() onToggle;
  final VoidCallback onEdit;
  final Future<void> Function() onDelete;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    final task = widget.task;
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final animationDuration = reduceMotion
        ? Duration.zero
        : const Duration(milliseconds: 220);
    final priority = _priorityPresentation(task.priority);

    return Card(
      key: ValueKey(task.id),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => setState(() => _expanded = !_expanded),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 13, 12, 13),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(
                button: true,
                label: task.isCompleted ? '恢复为未完成' : '标记为已完成',
                child: IconButton(
                  tooltip: task.isCompleted ? '恢复为未完成' : '标记为已完成',
                  visualDensity: VisualDensity.compact,
                  onPressed: widget.onToggle,
                  icon: AnimatedSwitcher(
                    duration: reduceMotion
                        ? Duration.zero
                        : const Duration(milliseconds: 180),
                    child: Icon(
                      task.isCompleted
                          ? Icons.check_circle_rounded
                          : Icons.radio_button_unchecked_rounded,
                      key: ValueKey(task.isCompleted),
                      color: task.isCompleted
                          ? ClearFlowColors.sage
                          : const Color(0xFF8A937F),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedDefaultTextStyle(
                      duration: animationDuration,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w700,
                        color: task.isCompleted
                            ? const Color(0xFF8A9086)
                            : ClearFlowColors.text,
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                      child: Text(
                        task.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Wrap(
                      spacing: 8,
                      runSpacing: 5,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          _dueLabel(task, widget.now),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: _dueColor(task, widget.now),
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        _MetaPill(
                          icon: priority.icon,
                          label: priority.label,
                          color: priority.color,
                        ),
                        if (task.hasNote)
                          const _MetaPill(
                            icon: Icons.notes_rounded,
                            label: '有备注',
                            color: Color(0xFF737A6D),
                          ),
                      ],
                    ),
                    AnimatedSize(
                      duration: animationDuration,
                      curve: Curves.easeOutCubic,
                      child: _expanded
                          ? Padding(
                              padding: const EdgeInsets.only(top: 13),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  if (task.hasNote) ...[
                                    const Divider(height: 1),
                                    const SizedBox(height: 12),
                                    Text(
                                      task.note,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: const Color(0xFF62695D),
                                            height: 1.55,
                                          ),
                                    ),
                                  ],
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton.icon(
                                        onPressed: widget.onEdit,
                                        icon: const Icon(Icons.edit_outlined),
                                        label: const Text('编辑'),
                                      ),
                                      TextButton.icon(
                                        onPressed: widget.onDelete,
                                        style: TextButton.styleFrom(
                                          foregroundColor:
                                              ClearFlowColors.coral,
                                        ),
                                        icon: const Icon(
                                          Icons.delete_outline_rounded,
                                        ),
                                        label: const Text('删除'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
              Container(
                width: 5,
                height: 28,
                margin: const EdgeInsets.only(left: 8, top: 4),
                decoration: BoxDecoration(
                  color: priority.color,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetaPill extends StatelessWidget {
  const _MetaPill({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 3),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(color: color),
        ),
      ],
    );
  }
}

({String label, IconData icon, Color color}) _priorityPresentation(
  TaskPriority priority,
) {
  return switch (priority) {
    TaskPriority.low => (
      label: '低优先级',
      icon: Icons.keyboard_arrow_down_rounded,
      color: const Color(0xFF758274),
    ),
    TaskPriority.normal => (
      label: '普通',
      icon: Icons.remove_rounded,
      color: ClearFlowColors.amber,
    ),
    TaskPriority.high => (
      label: '高优先级',
      icon: Icons.keyboard_arrow_up_rounded,
      color: ClearFlowColors.coral,
    ),
  };
}

String _dueLabel(Task task, DateTime now) {
  if (task.isCompleted) {
    final completedAt = task.completedAt;
    return completedAt == null
        ? '已完成'
        : '完成于 ${DateFormat('MM-dd HH:mm').format(completedAt)}';
  }
  final due = task.dueDate;
  if (due == null) {
    return '无截止日期';
  }
  final status = DueStatus.from(task, now);
  final time = task.hasDueTime ? ' ${DateFormat('HH:mm').format(due)}' : '';
  return switch (status) {
    DueStatus.overdue =>
      task.hasDueTime
          ? '已逾期 · ${DateFormat('MM-dd HH:mm').format(due)}'
          : '已逾期 ${now.dateOnly.difference(due.dateOnly).inDays} 天',
    DueStatus.today => '今天$time',
    DueStatus.tomorrow => '明天$time',
    DueStatus.withinThreeDays =>
      '${due.dateOnly.difference(now.dateOnly).inDays} 天后$time',
    DueStatus.later =>
      '${DateFormat('MM-dd').format(due)} · ${due.dateOnly.difference(now.dateOnly).inDays} 天后',
    DueStatus.none => '无截止日期',
  };
}

Color _dueColor(Task task, DateTime now) {
  return DueStatus.from(task, now) == DueStatus.overdue
      ? ClearFlowColors.coral
      : const Color(0xFF71786B);
}
