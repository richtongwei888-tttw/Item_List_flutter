import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:item_list_flutter/app/app.dart';
import 'package:item_list_flutter/data/notifications/local_notification_gateway.dart';
import 'package:item_list_flutter/data/notifications/notification_providers.dart';
import 'package:item_list_flutter/data/version/package_version_reader.dart';
import 'package:item_list_flutter/features/profile/application/profile_repository.dart';
import 'package:item_list_flutter/features/profile/domain/app_preferences.dart';
import 'package:item_list_flutter/features/profile/domain/user_profile.dart';
import 'package:item_list_flutter/features/profile/presentation/profile_providers.dart';
import 'package:item_list_flutter/features/tasks/application/task_repository.dart';
import 'package:item_list_flutter/features/tasks/application/task_service.dart';
import 'package:item_list_flutter/features/tasks/domain/task.dart';
import 'package:item_list_flutter/features/tasks/presentation/task_providers.dart';

final class MemoryTaskRepository implements TaskRepository {
  final _controller = StreamController<List<Task>>.broadcast(sync: true);
  final List<Task> _tasks = [];

  List<Task> get tasks => List.unmodifiable(_tasks);

  Future<void> close() => _controller.close();

  void _emit() {
    _controller.add(List.unmodifiable(_tasks));
  }

  @override
  Future<void> delete(String taskId, DateTime deletedAt) async {
    _tasks.removeWhere((task) => task.id == taskId);
    _emit();
  }

  @override
  Future<Task?> findById(String taskId) async {
    return _tasks.where((task) => task.id == taskId).firstOrNull;
  }

  @override
  Future<List<Task>> getAll() async => tasks;

  @override
  Future<void> restore(String taskId, DateTime restoredAt) async {
    final index = _tasks.indexWhere((task) => task.id == taskId);
    _tasks[index] = _tasks[index].copyWith(
      isCompleted: false,
      completedAt: null,
      updatedAt: restoredAt,
    );
    _emit();
  }

  @override
  Future<void> save(Task task) async {
    final index = _tasks.indexWhere((item) => item.id == task.id);
    if (index == -1) {
      _tasks.add(task);
    } else {
      _tasks[index] = task;
    }
    _emit();
  }

  @override
  Future<void> setCompleted(String taskId, DateTime completedAt) async {
    final index = _tasks.indexWhere((task) => task.id == taskId);
    _tasks[index] = _tasks[index].copyWith(
      isCompleted: true,
      completedAt: completedAt,
      updatedAt: completedAt,
    );
    _emit();
  }

  @override
  Stream<List<Task>> watchAll() async* {
    yield tasks;
    yield* _controller.stream;
  }
}

Widget buildOfflineTestApp(MemoryTaskRepository repository, {DateTime? now}) {
  final profileRepository = MemoryProfileRepository();
  return ProviderScope(
    overrides: [
      taskRepositoryProvider.overrideWithValue(repository),
      taskServiceProvider.overrideWithValue(TaskService(repository)),
      currentTimeProvider.overrideWithValue(now ?? DateTime(2026, 6, 6, 10)),
      profileRepositoryProvider.overrideWithValue(profileRepository),
      packageVersionReaderProvider.overrideWithValue(
        const StaticVersionReader(),
      ),
      notificationPermissionRequesterProvider.overrideWithValue(
        const GrantedNotificationPermissionRequester(),
      ),
    ],
    child: const ClearFlowApp(),
  );
}

final class MemoryProfileRepository implements ProfileRepository {
  UserProfile profile = UserProfile.initial;
  AppPreferences preferences = AppPreferences.defaults;

  @override
  Future<AppPreferences> getPreferences() async => preferences;

  @override
  Future<UserProfile> getProfile() async => profile;

  @override
  Future<void> savePreferences(AppPreferences value) async {
    preferences = value;
  }

  @override
  Future<void> saveProfile(UserProfile value) async {
    profile = value;
  }
}

final class StaticVersionReader implements PackageVersionReader {
  const StaticVersionReader();

  @override
  Future<String> readableVersion() async => '0.1.0 (1)';
}

final class GrantedNotificationPermissionRequester
    implements NotificationPermissionRequester {
  const GrantedNotificationPermissionRequester();

  @override
  Future<NotificationPermissionStatus> requestPermission() async {
    return NotificationPermissionStatus.granted;
  }
}
