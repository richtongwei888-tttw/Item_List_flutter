import 'package:item_list_flutter/features/tasks/domain/task_filter.dart';

final class AppPreferences {
  const AppPreferences({
    required this.defaultFilter,
    required this.animationsEnabled,
    required this.notificationPermissionPrompted,
  });

  static const defaults = AppPreferences(
    defaultFilter: TaskFilter.pending,
    animationsEnabled: true,
    notificationPermissionPrompted: false,
  );

  final TaskFilter defaultFilter;
  final bool animationsEnabled;
  final bool notificationPermissionPrompted;

  AppPreferences copyWith({
    TaskFilter? defaultFilter,
    bool? animationsEnabled,
    bool? notificationPermissionPrompted,
  }) {
    return AppPreferences(
      defaultFilter: defaultFilter ?? this.defaultFilter,
      animationsEnabled: animationsEnabled ?? this.animationsEnabled,
      notificationPermissionPrompted:
          notificationPermissionPrompted ?? this.notificationPermissionPrompted,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AppPreferences &&
        other.defaultFilter == defaultFilter &&
        other.animationsEnabled == animationsEnabled &&
        other.notificationPermissionPrompted == notificationPermissionPrompted;
  }

  @override
  int get hashCode => Object.hash(
    defaultFilter,
    animationsEnabled,
    notificationPermissionPrompted,
  );
}
