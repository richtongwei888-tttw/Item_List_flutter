import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:item_list_flutter/app/app_theme.dart';
import 'package:item_list_flutter/data/version/package_version_reader.dart';
import 'package:item_list_flutter/features/profile/application/profile_repository.dart';
import 'package:item_list_flutter/features/profile/domain/app_preferences.dart';
import 'package:item_list_flutter/features/profile/domain/user_profile.dart';
import 'package:item_list_flutter/features/profile/presentation/profile_providers.dart';
import 'package:item_list_flutter/features/profile/presentation/profile_screen.dart';

void main() {
  testWidgets('shows fallback avatar preferences and app version', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          profileRepositoryProvider.overrideWithValue(_FakeProfileRepository()),
          packageVersionReaderProvider.overrideWithValue(
            const _FakeVersionReader(),
          ),
        ],
        child: MaterialApp(
          theme: ClearFlowTheme.light,
          home: const Scaffold(body: ProfileScreen()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('用户'), findsWidgets);
    expect(find.text('用'), findsOneWidget);
    expect(find.text('默认任务筛选'), findsOneWidget);
    expect(find.text('完成任务动画'), findsOneWidget);
    expect(find.text('0.1.0 (1)'), findsOneWidget);
    expect(find.text('已保存'), findsOneWidget);
  });

  testWidgets('saves a username after the edit dialog fully closes', (
    tester,
  ) async {
    final repository = _FakeProfileRepository();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          profileRepositoryProvider.overrideWithValue(repository),
          packageVersionReaderProvider.overrideWithValue(
            const _FakeVersionReader(),
          ),
        ],
        child: MaterialApp(
          theme: ClearFlowTheme.light,
          home: const Scaffold(body: ProfileScreen()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('修改用户名'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(EditableText), 'TWX');
    await tester.tap(find.widgetWithText(FilledButton, '保存'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(repository.profile.displayName, 'TWX');
    expect(find.text('TWX'), findsOneWidget);
  });
}

final class _FakeProfileRepository implements ProfileRepository {
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

final class _FakeVersionReader implements PackageVersionReader {
  const _FakeVersionReader();

  @override
  Future<String> readableVersion() async => '0.1.0 (1)';
}
