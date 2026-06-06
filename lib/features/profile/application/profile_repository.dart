import 'package:item_list_flutter/data/database/app_database.dart';
import 'package:item_list_flutter/features/profile/domain/app_preferences.dart';
import 'package:item_list_flutter/features/profile/domain/user_profile.dart';
import 'package:item_list_flutter/features/tasks/domain/task_filter.dart';

abstract interface class ProfileRepository {
  Future<UserProfile> getProfile();

  Future<void> saveProfile(UserProfile value);

  Future<AppPreferences> getPreferences();

  Future<void> savePreferences(AppPreferences value);
}

final class DriftProfileRepository implements ProfileRepository {
  const DriftProfileRepository(this._database);

  final AppDatabase _database;

  @override
  Future<UserProfile> getProfile() async {
    final row = await _database.getProfileRow();
    return UserProfile(
      displayName: row.displayName,
      avatarPath: row.avatarPath,
    );
  }

  @override
  Future<void> saveProfile(UserProfile value) {
    return _database.saveProfileRow(
      displayName: value.displayName.trim(),
      avatarPath: value.avatarPath,
    );
  }

  @override
  Future<AppPreferences> getPreferences() async {
    final row = await _database.getPreferenceRow();
    return AppPreferences(
      defaultFilter: TaskFilter.values.byName(row.defaultFilter),
      animationsEnabled: row.animationsEnabled,
      notificationPermissionPrompted: row.notificationPermissionPrompted,
    );
  }

  @override
  Future<void> savePreferences(AppPreferences value) {
    return _database.savePreferenceRow(
      defaultFilter: value.defaultFilter.name,
      animationsEnabled: value.animationsEnabled,
      notificationPermissionPrompted: value.notificationPermissionPrompted,
    );
  }
}
