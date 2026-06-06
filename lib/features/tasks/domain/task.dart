import 'package:item_list_flutter/features/tasks/domain/reminder_offset.dart';
import 'package:item_list_flutter/features/tasks/domain/reminder_sync_status.dart';
import 'package:item_list_flutter/features/tasks/domain/task_priority.dart';

const _unset = Object();

final class Task {
  const Task._({
    required this.id,
    required this.title,
    required this.note,
    required this.dueDate,
    required this.hasDueTime,
    required this.priority,
    required this.isCompleted,
    required this.completedAt,
    required this.reminderEnabled,
    required this.reminderOffset,
    required this.reminderSyncStatus,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Task.create({
    required String id,
    required String title,
    String note = '',
    DateTime? dueDate,
    bool? hasDueTime,
    TaskPriority priority = TaskPriority.normal,
    bool isCompleted = false,
    DateTime? completedAt,
    bool reminderEnabled = false,
    ReminderOffset? reminderOffset,
    ReminderSyncStatus reminderSyncStatus = ReminderSyncStatus.synced,
    required DateTime now,
    DateTime? createdAt,
  }) {
    final normalizedTitle = title.trim();
    final normalizedNote = note.trim();
    final effectiveHasDueTime =
        dueDate != null && (hasDueTime ?? _containsTime(dueDate));

    if (normalizedTitle.isEmpty || normalizedTitle.length > 100) {
      throw ArgumentError.value(
        title,
        'title',
        'Must contain 1-100 characters',
      );
    }
    if (normalizedNote.length > 2000) {
      throw ArgumentError.value(
        note,
        'note',
        'Must not exceed 2000 characters',
      );
    }
    if (dueDate == null && effectiveHasDueTime) {
      throw ArgumentError('A due time requires a due date');
    }
    if (reminderEnabled && dueDate == null) {
      throw ArgumentError('A reminder requires a due date');
    }
    if (isCompleted != (completedAt != null)) {
      throw ArgumentError('Completion status and completion time must agree');
    }

    return Task._(
      id: id,
      title: normalizedTitle,
      note: normalizedNote,
      dueDate: dueDate,
      hasDueTime: effectiveHasDueTime,
      priority: priority,
      isCompleted: isCompleted,
      completedAt: completedAt,
      reminderEnabled: reminderEnabled,
      reminderOffset: reminderEnabled
          ? (reminderOffset ??
                (effectiveHasDueTime
                    ? ReminderOffset.twoHours
                    : ReminderOffset.dateAtNine))
          : null,
      reminderSyncStatus: reminderEnabled
          ? reminderSyncStatus
          : ReminderSyncStatus.synced,
      createdAt: createdAt ?? now,
      updatedAt: now,
    );
  }

  factory Task.test({
    String id = 'task',
    String title = 'Test task',
    String note = '',
    DateTime? dueDate,
    bool? hasDueTime,
    TaskPriority priority = TaskPriority.normal,
    bool isCompleted = false,
    DateTime? completedAt,
    bool reminderEnabled = false,
    ReminderOffset? reminderOffset,
    ReminderSyncStatus reminderSyncStatus = ReminderSyncStatus.synced,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    final testNow = updatedAt ?? DateTime(2026, 6, 1, 9);
    return Task.create(
      id: id,
      title: title,
      note: note,
      dueDate: dueDate,
      hasDueTime: hasDueTime,
      priority: priority,
      isCompleted: isCompleted,
      completedAt: completedAt,
      reminderEnabled: reminderEnabled,
      reminderOffset: reminderOffset,
      reminderSyncStatus: reminderSyncStatus,
      createdAt: createdAt ?? DateTime(2026, 6, 1, 8),
      now: testNow,
    );
  }

  final String id;
  final String title;
  final String note;
  final DateTime? dueDate;
  final bool hasDueTime;
  final TaskPriority priority;
  final bool isCompleted;
  final DateTime? completedAt;
  final bool reminderEnabled;
  final ReminderOffset? reminderOffset;
  final ReminderSyncStatus reminderSyncStatus;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool get hasNote => note.isNotEmpty;

  Task copyWith({
    String? id,
    String? title,
    String? note,
    Object? dueDate = _unset,
    bool? hasDueTime,
    TaskPriority? priority,
    bool? isCompleted,
    Object? completedAt = _unset,
    bool? reminderEnabled,
    Object? reminderOffset = _unset,
    ReminderSyncStatus? reminderSyncStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Task.create(
      id: id ?? this.id,
      title: title ?? this.title,
      note: note ?? this.note,
      dueDate: identical(dueDate, _unset) ? this.dueDate : dueDate as DateTime?,
      hasDueTime: hasDueTime ?? this.hasDueTime,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: identical(completedAt, _unset)
          ? this.completedAt
          : completedAt as DateTime?,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      reminderOffset: identical(reminderOffset, _unset)
          ? this.reminderOffset
          : reminderOffset as ReminderOffset?,
      reminderSyncStatus: reminderSyncStatus ?? this.reminderSyncStatus,
      createdAt: createdAt ?? this.createdAt,
      now: updatedAt ?? this.updatedAt,
    );
  }

  static bool _containsTime(DateTime value) =>
      value.hour != 0 ||
      value.minute != 0 ||
      value.second != 0 ||
      value.millisecond != 0 ||
      value.microsecond != 0;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Task &&
            id == other.id &&
            title == other.title &&
            note == other.note &&
            dueDate == other.dueDate &&
            hasDueTime == other.hasDueTime &&
            priority == other.priority &&
            isCompleted == other.isCompleted &&
            completedAt == other.completedAt &&
            reminderEnabled == other.reminderEnabled &&
            reminderOffset == other.reminderOffset &&
            reminderSyncStatus == other.reminderSyncStatus &&
            createdAt == other.createdAt &&
            updatedAt == other.updatedAt;
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    note,
    dueDate,
    hasDueTime,
    priority,
    isCompleted,
    completedAt,
    reminderEnabled,
    reminderOffset,
    reminderSyncStatus,
    createdAt,
    updatedAt,
  );
}
