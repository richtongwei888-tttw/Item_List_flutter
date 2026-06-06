import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:item_list_flutter/data/database/app_database.dart';
import 'package:item_list_flutter/data/profile/avatar_file_store.dart';
import 'package:item_list_flutter/features/profile/application/profile_repository.dart';
import 'package:item_list_flutter/features/profile/domain/app_preferences.dart';
import 'package:item_list_flutter/features/profile/domain/user_profile.dart';
import 'package:item_list_flutter/features/tasks/domain/task_filter.dart';

void main() {
  test('default profile uses 用户 and fallback initial 用', () {
    expect(UserProfile.initial.displayName, '用户');
    expect(UserProfile.initial.fallbackInitial, '用');
    expect(const UserProfile(displayName: '  林安  ').fallbackInitial, '林');
    expect(const UserProfile(displayName: '   ').fallbackInitial, '用');
  });

  test('profile and preferences persist in Drift', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final repository = DriftProfileRepository(database);
    addTearDown(database.close);

    expect((await repository.getProfile()).displayName, '用户');
    await repository.saveProfile(
      const UserProfile(displayName: '林安', avatarPath: 'avatar.jpg'),
    );
    await repository.savePreferences(
      const AppPreferences(
        defaultFilter: TaskFilter.all,
        animationsEnabled: false,
        notificationPermissionPrompted: true,
      ),
    );

    expect(
      await repository.getProfile(),
      const UserProfile(displayName: '林安', avatarPath: 'avatar.jpg'),
    );
    expect(
      await repository.getPreferences(),
      const AppPreferences(
        defaultFilter: TaskFilter.all,
        animationsEnabled: false,
        notificationPermissionPrompted: true,
      ),
    );
  });

  test(
    'avatar store copies selected file and deletes replaced avatar',
    () async {
      final temp = await Directory.systemTemp.createTemp('clear-flow-avatar');
      addTearDown(() => temp.delete(recursive: true));
      final sourceOne = File('${temp.path}/source-one.jpg')
        ..writeAsBytesSync([1, 2, 3]);
      final sourceTwo = File('${temp.path}/source-two.png')
        ..writeAsBytesSync([4, 5, 6]);
      final support = Directory('${temp.path}/support');
      final store = AvatarFileStore(() async => support);

      final firstPath = await store.copySelected(sourceOne);
      final secondPath = await store.copySelected(
        sourceTwo,
        previousManagedPath: firstPath,
      );

      expect(File(firstPath).existsSync(), isFalse);
      expect(File(secondPath).readAsBytesSync(), [4, 5, 6]);
      expect(secondPath, endsWith('.png'));
    },
  );
}
