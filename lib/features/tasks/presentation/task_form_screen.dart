import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:item_list_flutter/app/app_theme.dart';
import 'package:item_list_flutter/data/notifications/local_notification_gateway.dart';
import 'package:item_list_flutter/data/notifications/notification_providers.dart';
import 'package:item_list_flutter/features/tasks/application/task_service.dart';
import 'package:item_list_flutter/features/tasks/domain/reminder_offset.dart';
import 'package:item_list_flutter/features/tasks/domain/reminder_policy.dart';
import 'package:item_list_flutter/features/tasks/domain/reminder_sync_status.dart';
import 'package:item_list_flutter/features/tasks/domain/task.dart';
import 'package:item_list_flutter/features/tasks/domain/task_priority.dart';
import 'package:item_list_flutter/features/tasks/presentation/task_providers.dart';
import 'package:uuid/uuid.dart';

class TaskFormScreen extends ConsumerStatefulWidget {
  const TaskFormScreen({super.key, this.task, this.onSaved});

  final Task? task;
  final ValueChanged<Task>? onSaved;

  @override
  ConsumerState<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends ConsumerState<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _noteController;
  late DateTime? _dueDate;
  late TimeOfDay? _dueTime;
  late TaskPriority _priority;
  late bool _reminderEnabled;
  late ReminderOffset _reminderOffset;
  var _saving = false;

  @override
  void initState() {
    super.initState();
    final task = widget.task;
    _titleController = TextEditingController(text: task?.title);
    _noteController = TextEditingController(text: task?.note);
    _dueDate = task?.dueDate == null
        ? null
        : DateTime(task!.dueDate!.year, task.dueDate!.month, task.dueDate!.day);
    _dueTime = task?.dueDate != null && task!.hasDueTime
        ? TimeOfDay.fromDateTime(task.dueDate!)
        : null;
    _priority = task?.priority ?? TaskPriority.normal;
    _reminderEnabled = task?.reminderEnabled ?? false;
    _reminderOffset =
        task?.reminderOffset ??
        (task?.hasDueTime == true
            ? ReminderOffset.twoHours
            : ReminderOffset.dateAtNine);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.task != null;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ClearFlowColors.background,
        title: Text(isEditing ? '编辑任务' : '新增任务'),
        leading: IconButton(
          tooltip: '取消',
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
          icon: const Icon(Icons.close_rounded),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 110),
            children: [
              TextFormField(
                controller: _titleController,
                autofocus: !isEditing,
                maxLength: 100,
                inputFormatters: [LengthLimitingTextInputFormatter(100)],
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: '任务标题',
                  hintText: '例如：整理本周计划',
                  counterText: '',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '请输入任务标题';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              _FormSection(
                title: '截止日期',
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _selectDate,
                        icon: const Icon(Icons.calendar_today_outlined),
                        label: Text(
                          _dueDate == null
                              ? '选择日期'
                              : DateFormat('yyyy年MM月dd日').format(_dueDate!),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    OutlinedButton(
                      onPressed: _dueDate == null ? null : _selectTime,
                      child: Text(
                        _dueTime == null ? '设置时间' : _dueTime!.format(context),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _FormSection(
                title: '优先级',
                child: SegmentedButton<TaskPriority>(
                  showSelectedIcon: false,
                  segments: const [
                    ButtonSegment(
                      value: TaskPriority.low,
                      label: Text('低'),
                      icon: Icon(Icons.keyboard_arrow_down_rounded),
                    ),
                    ButtonSegment(
                      value: TaskPriority.normal,
                      label: Text('普通'),
                      icon: Icon(Icons.remove_rounded),
                    ),
                    ButtonSegment(
                      value: TaskPriority.high,
                      label: Text('高'),
                      icon: Icon(Icons.keyboard_arrow_up_rounded),
                    ),
                  ],
                  selected: {_priority},
                  onSelectionChanged: (selected) {
                    setState(() => _priority = selected.single);
                  },
                ),
              ),
              const SizedBox(height: 12),
              _FormSection(
                title: '提醒',
                child: Column(
                  children: [
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('到期提醒'),
                      subtitle: Text(
                        _dueDate == null ? '选择截止日期后可用' : '通过设备本地通知提醒',
                      ),
                      value: _reminderEnabled && _dueDate != null,
                      onChanged: _dueDate == null
                          ? null
                          : (enabled) {
                              setState(() => _reminderEnabled = enabled);
                            },
                    ),
                    if (_reminderEnabled && _dueDate != null)
                      DropdownButtonFormField<ReminderOffset>(
                        key: ValueKey(_reminderOffset),
                        initialValue: _reminderOffset,
                        decoration: const InputDecoration(labelText: '提醒时间'),
                        items: _availableOffsets
                            .map(
                              (offset) => DropdownMenuItem(
                                value: offset,
                                child: Text(_offsetLabel(offset)),
                              ),
                            )
                            .toList(),
                        onChanged: (offset) {
                          if (offset != null) {
                            setState(() => _reminderOffset = offset);
                          }
                        },
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _noteController,
                minLines: 4,
                maxLines: 7,
                maxLength: 2000,
                inputFormatters: [LengthLimitingTextInputFormatter(2000)],
                decoration: const InputDecoration(
                  labelText: '备注',
                  hintText: '补充任务细节、地址或需要准备的内容……',
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(20, 10, 20, 14),
        child: FilledButton(
          onPressed: _saving ? null : _save,
          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
          child: Text(_saving ? '正在保存…' : '保存任务'),
        ),
      ),
    );
  }

  List<ReminderOffset> get _availableOffsets {
    if (_dueTime == null) {
      return const [ReminderOffset.dateAtNine];
    }
    return const [
      ReminderOffset.atTime,
      ReminderOffset.tenMinutes,
      ReminderOffset.thirtyMinutes,
      ReminderOffset.oneHour,
      ReminderOffset.twoHours,
      ReminderOffset.oneDay,
    ];
  }

  Future<void> _selectDate() async {
    final now = ref.read(currentTimeProvider);
    final selected = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 20),
    );
    if (selected == null) {
      return;
    }
    setState(() {
      _dueDate = selected;
      _reminderEnabled = true;
      _reminderOffset = _dueTime == null
          ? ReminderOffset.dateAtNine
          : ReminderOffset.twoHours;
    });
  }

  Future<void> _selectTime() async {
    final selected = await showTimePicker(
      context: context,
      initialTime: _dueTime ?? const TimeOfDay(hour: 18, minute: 0),
    );
    if (selected == null) {
      return;
    }
    setState(() {
      _dueTime = selected;
      _reminderEnabled = true;
      _reminderOffset = ReminderOffset.twoHours;
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final now = ref.read(currentTimeProvider);
    var reminderEnabled = _reminderEnabled && _dueDate != null;
    var reminderOffset = _reminderOffset;
    final dueAt = _composeDueAt();

    if (reminderEnabled && dueAt != null) {
      final preview = Task.create(
        id: widget.task?.id ?? 'preview',
        title: _titleController.text,
        note: _noteController.text,
        dueDate: dueAt,
        hasDueTime: _dueTime != null,
        priority: _priority,
        reminderEnabled: true,
        reminderOffset: reminderOffset,
        reminderSyncStatus: ReminderSyncStatus.pending,
        createdAt: widget.task?.createdAt,
        now: now,
      );
      if (ReminderPolicy.calculate(preview, reminderOffset, now) == null &&
          dueAt.isAfter(now)) {
        final resolution = await _showPastReminderDialog();
        if (resolution == null) {
          return;
        }
        reminderEnabled = resolution;
        reminderOffset = resolution
            ? ReminderOffset.immediate
            : ReminderOffset.dateAtNine;
      }
    }

    if (reminderEnabled) {
      final permission = await ref
          .read(notificationPermissionRequesterProvider)
          .requestPermission();
      if (!mounted) {
        return;
      }
      if (permission != NotificationPermissionStatus.granted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('通知权限未开启，无法设置提醒')));
        return;
      }
    }

    final existing = widget.task;
    final task = Task.create(
      id: existing?.id ?? const Uuid().v4(),
      title: _titleController.text,
      note: _noteController.text,
      dueDate: dueAt,
      hasDueTime: _dueTime != null,
      priority: _priority,
      isCompleted: existing?.isCompleted ?? false,
      completedAt: existing?.completedAt,
      reminderEnabled: reminderEnabled,
      reminderOffset: reminderEnabled ? reminderOffset : null,
      reminderSyncStatus: reminderEnabled
          ? ReminderSyncStatus.pending
          : ReminderSyncStatus.synced,
      createdAt: existing?.createdAt,
      now: now,
    );

    setState(() => _saving = true);
    final result = await ref.read(taskServiceProvider).save(task);
    if (!mounted) {
      return;
    }
    setState(() => _saving = false);

    if (result case TaskActionFailed(:final failure)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(failure.message)));
      return;
    }
    if (widget.onSaved case final callback?) {
      callback(task);
      return;
    }
    Navigator.pop(context, task);
  }

  DateTime? _composeDueAt() {
    final date = _dueDate;
    if (date == null) {
      return null;
    }
    final time = _dueTime;
    return DateTime(
      date.year,
      date.month,
      date.day,
      time?.hour ?? 0,
      time?.minute ?? 0,
    );
  }

  Future<bool?> _showPastReminderDialog() {
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('提醒时间已过'),
        content: const Text('默认提醒时刻已经过去，可以立即提醒或关闭本任务提醒。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('关闭提醒'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('立即提醒'),
          ),
        ],
      ),
    );
  }
}

class _FormSection extends StatelessWidget {
  const _FormSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

String _offsetLabel(ReminderOffset offset) => switch (offset) {
  ReminderOffset.immediate => '立即提醒',
  ReminderOffset.atTime => '准时',
  ReminderOffset.tenMinutes => '提前 10 分钟',
  ReminderOffset.thirtyMinutes => '提前 30 分钟',
  ReminderOffset.oneHour => '提前 1 小时',
  ReminderOffset.twoHours => '提前 2 小时',
  ReminderOffset.oneDay => '提前 1 天',
  ReminderOffset.dateAtNine => '当天 09:00',
};
