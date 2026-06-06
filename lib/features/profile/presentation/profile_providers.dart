import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:item_list_flutter/data/profile/avatar_file_store.dart';
import 'package:item_list_flutter/data/version/package_version_reader.dart';
import 'package:item_list_flutter/features/profile/application/profile_repository.dart';
import 'package:item_list_flutter/features/profile/domain/app_preferences.dart';
import 'package:item_list_flutter/features/profile/domain/user_profile.dart';
import 'package:item_list_flutter/features/tasks/presentation/task_providers.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return DriftProfileRepository(ref.watch(appDatabaseProvider));
});

final avatarFileStoreProvider = Provider<AvatarFileStore>((ref) {
  return AvatarFileStore();
});

final avatarPickerProvider = Provider<AvatarPicker>((ref) {
  return ImagePickerAvatarPicker();
});

final packageVersionReaderProvider = Provider<PackageVersionReader>((ref) {
  return const PluginPackageVersionReader();
});

final profileProvider = FutureProvider<UserProfile>((ref) {
  return ref.watch(profileRepositoryProvider).getProfile();
});

final preferencesProvider = FutureProvider<AppPreferences>((ref) {
  return ref.watch(profileRepositoryProvider).getPreferences();
});

final appVersionProvider = FutureProvider<String>((ref) {
  return ref.watch(packageVersionReaderProvider).readableVersion();
});
