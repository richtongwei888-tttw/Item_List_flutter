import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:item_list_flutter/app/app.dart';
import 'package:item_list_flutter/data/version/package_version_reader.dart';
import 'package:item_list_flutter/features/profile/application/profile_repository.dart';
import 'package:item_list_flutter/features/profile/domain/app_preferences.dart';
import 'package:item_list_flutter/features/profile/domain/user_profile.dart';
import 'package:item_list_flutter/features/profile/presentation/profile_providers.dart';
import 'package:item_list_flutter/features/tasks/application/task_repository.dart';
import 'package:item_list_flutter/features/tasks/domain/task.dart';
import 'package:item_list_flutter/features/tasks/presentation/task_providers.dart';

void main() {
  testWidgets('shows the task dashboard and opens the task form', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          taskRepositoryProvider.overrideWithValue(_FakeTaskRepository()),
          profileRepositoryProvider.overrideWithValue(_FakeProfileRepository()),
          packageVersionReaderProvider.overrideWithValue(
            const _FakeVersionReader(),
          ),
        ],
        child: const ClearFlowApp(),
      ),
    );
    await _pumpUntilFound(tester, find.text('把今天理清楚'));

    expect(find.text('任务'), findsOneWidget);
    expect(find.text('统计'), findsOneWidget);
    expect(find.text('我的'), findsOneWidget);
    expect(find.text('把今天理清楚'), findsOneWidget);

    await tester.tap(find.byTooltip('新增任务'));
    await _pumpUntilFound(tester, find.text('任务标题'));

    expect(find.text('新增任务'), findsWidgets);
    expect(find.text('任务标题'), findsOneWidget);
  });
}

Future<void> _pumpUntilFound(WidgetTester tester, Finder finder) async {
  for (var attempt = 0; attempt < 40; attempt++) {
    await tester.pump(const Duration(milliseconds: 50));
    if (finder.evaluate().isNotEmpty) {
      return;
    }
  }
  fail('Timed out waiting for the target widget');
}

final class _FakeTaskRepository implements TaskRepository {
  @override
  Future<void> delete(String taskId, DateTime deletedAt) async {}

  @override
  Future<Task?> findById(String taskId) async => null;

  @override
  Future<List<Task>> getAll() async => const [];

  @override
  Future<void> restore(String taskId, DateTime restoredAt) async {}

  @override
  Future<void> save(Task task) async {}

  @override
  Future<void> setCompleted(String taskId, DateTime completedAt) async {}

  @override
  Stream<List<Task>> watchAll() => Stream.value(const []);
}

final class _FakeProfileRepository implements ProfileRepository {
  @override
  Future<AppPreferences> getPreferences() async => AppPreferences.defaults;

  @override
  Future<UserProfile> getProfile() async => UserProfile.initial;

  @override
  Future<void> savePreferences(AppPreferences value) async {}

  @override
  Future<void> saveProfile(UserProfile value) async {}
}

final class _FakeVersionReader implements PackageVersionReader {
  const _FakeVersionReader();

  @override
  Future<String> readableVersion() async => '0.1.0 (1)';
}
