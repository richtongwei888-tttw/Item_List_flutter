import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

typedef SupportDirectoryProvider = Future<Directory> Function();

final class AvatarFileStore {
  AvatarFileStore([
    SupportDirectoryProvider supportDirectoryProvider =
        getApplicationSupportDirectory,
  ]) : _supportDirectoryProvider = supportDirectoryProvider;

  final SupportDirectoryProvider _supportDirectoryProvider;

  Future<String> copySelected(
    File source, {
    String? previousManagedPath,
  }) async {
    final supportDirectory = await _supportDirectoryProvider();
    final avatarDirectory = Directory(
      '${supportDirectory.path}${Platform.pathSeparator}avatars',
    );
    await avatarDirectory.create(recursive: true);

    final extension = _extensionOf(source.path);
    final destination = File(
      '${avatarDirectory.path}${Platform.pathSeparator}'
      'avatar-${DateTime.now().microsecondsSinceEpoch}$extension',
    );
    await source.copy(destination.path);

    if (previousManagedPath != null &&
        previousManagedPath != destination.path) {
      final previous = File(previousManagedPath);
      if (await previous.exists()) {
        await previous.delete();
      }
    }
    return destination.path;
  }

  String _extensionOf(String path) {
    final separator = path.lastIndexOf(Platform.pathSeparator);
    final dot = path.lastIndexOf('.');
    return dot > separator ? path.substring(dot) : '';
  }
}

abstract interface class AvatarPicker {
  Future<File?> pick();
}

final class ImagePickerAvatarPicker implements AvatarPicker {
  ImagePickerAvatarPicker([ImagePicker? picker])
    : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  @override
  Future<File?> pick() async {
    final selected = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
      maxWidth: 1600,
    );
    return selected == null ? null : File(selected.path);
  }
}
