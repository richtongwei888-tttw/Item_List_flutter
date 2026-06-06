final class UserProfile {
  const UserProfile({required this.displayName, this.avatarPath});

  static const initial = UserProfile(displayName: '用户');

  final String displayName;
  final String? avatarPath;

  String get fallbackInitial {
    final normalized = displayName.trim();
    return normalized.isEmpty
        ? '用'
        : String.fromCharCode(normalized.runes.first);
  }

  UserProfile copyWith({String? displayName, Object? avatarPath = _sentinel}) {
    return UserProfile(
      displayName: displayName ?? this.displayName,
      avatarPath: identical(avatarPath, _sentinel)
          ? this.avatarPath
          : avatarPath as String?,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is UserProfile &&
        other.displayName == displayName &&
        other.avatarPath == avatarPath;
  }

  @override
  int get hashCode => Object.hash(displayName, avatarPath);
}

const _sentinel = Object();
