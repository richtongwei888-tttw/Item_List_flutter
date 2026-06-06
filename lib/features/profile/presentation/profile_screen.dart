import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:item_list_flutter/app/app_theme.dart';
import 'package:item_list_flutter/features/profile/domain/app_preferences.dart';
import 'package:item_list_flutter/features/profile/domain/user_profile.dart';
import 'package:item_list_flutter/features/profile/presentation/profile_providers.dart';
import 'package:item_list_flutter/features/tasks/domain/task_filter.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileValue = ref.watch(profileProvider);
    final preferencesValue = ref.watch(preferencesProvider);
    final versionValue = ref.watch(appVersionProvider);

    if (profileValue.isLoading || preferencesValue.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (profileValue.hasError || preferencesValue.hasError) {
      return _LoadError(
        onRetry: () {
          ref
            ..invalidate(profileProvider)
            ..invalidate(preferencesProvider);
        },
      );
    }

    final profile = profileValue.requireValue;
    final preferences = preferencesValue.requireValue;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 110),
      children: [
        Text(
          '个人资料与偏好',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: const Color(0xFF7C8174)),
        ),
        const SizedBox(height: 4),
        Text('我的清序', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 22),
        _ProfileHero(
          profile: profile,
          onEditName: () => _editName(context, ref, profile),
          onPickAvatar: () => _pickAvatar(context, ref, profile),
        ),
        const SizedBox(height: 14),
        _SectionCard(
          title: '使用偏好',
          children: [
            _PreferenceRow(
              icon: Icons.filter_list_rounded,
              label: '默认任务筛选',
              trailing: DropdownButton<TaskFilter>(
                value: preferences.defaultFilter,
                underline: const SizedBox.shrink(),
                items: const [
                  DropdownMenuItem(
                    value: TaskFilter.pending,
                    child: Text('待处理'),
                  ),
                  DropdownMenuItem(
                    value: TaskFilter.completed,
                    child: Text('已完成'),
                  ),
                  DropdownMenuItem(value: TaskFilter.all, child: Text('全部')),
                ],
                onChanged: (filter) {
                  if (filter != null) {
                    _savePreferences(
                      context,
                      ref,
                      preferences.copyWith(defaultFilter: filter),
                    );
                  }
                },
              ),
            ),
            const Divider(height: 1),
            _PreferenceRow(
              icon: Icons.animation_rounded,
              label: '完成任务动画',
              trailing: Switch(
                value: preferences.animationsEnabled,
                onChanged: (enabled) {
                  _savePreferences(
                    context,
                    ref,
                    preferences.copyWith(animationsEnabled: enabled),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        _SectionCard(
          title: '本地数据',
          children: const [
            _InfoRow(
              icon: Icons.cloud_off_rounded,
              label: '离线存储',
              value: '已保存',
              valueColor: ClearFlowColors.sage,
            ),
            Divider(height: 1),
            _InfoRow(
              icon: Icons.lock_outline_rounded,
              label: '数据位置',
              value: '仅保存在此设备',
            ),
          ],
        ),
        const SizedBox(height: 14),
        _SectionCard(
          title: '应用信息',
          children: [
            _InfoRow(
              icon: Icons.info_outline_rounded,
              label: '版本',
              value: versionValue.value ?? '读取中…',
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _editName(
    BuildContext context,
    WidgetRef ref,
    UserProfile profile,
  ) async {
    var name = profile.displayName;
    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('修改用户名'),
        content: TextFormField(
          initialValue: profile.displayName,
          autofocus: true,
          maxLength: 24,
          onChanged: (value) => name = value,
          decoration: const InputDecoration(labelText: '用户名'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () {
              final trimmedName = name.trim();
              if (trimmedName.isNotEmpty) {
                Navigator.pop(dialogContext, trimmedName);
              }
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
    if (result == null || !context.mounted) {
      return;
    }
    await _saveProfile(context, ref, profile.copyWith(displayName: result));
  }

  Future<void> _pickAvatar(
    BuildContext context,
    WidgetRef ref,
    UserProfile profile,
  ) async {
    try {
      final selected = await ref.read(avatarPickerProvider).pick();
      if (selected == null) {
        return;
      }
      final path = await ref
          .read(avatarFileStoreProvider)
          .copySelected(selected, previousManagedPath: profile.avatarPath);
      if (!context.mounted) {
        return;
      }
      await _saveProfile(context, ref, profile.copyWith(avatarPath: path));
    } on Object {
      if (context.mounted) {
        _showMessage(context, '头像保存失败，请重试');
      }
    }
  }

  Future<void> _saveProfile(
    BuildContext context,
    WidgetRef ref,
    UserProfile profile,
  ) async {
    try {
      await ref.read(profileRepositoryProvider).saveProfile(profile);
      ref.invalidate(profileProvider);
      if (context.mounted) {
        _showMessage(context, '个人资料已保存');
      }
    } on Object {
      if (context.mounted) {
        _showMessage(context, '未能保存个人资料');
      }
    }
  }

  Future<void> _savePreferences(
    BuildContext context,
    WidgetRef ref,
    AppPreferences preferences,
  ) async {
    try {
      await ref.read(profileRepositoryProvider).savePreferences(preferences);
      ref.invalidate(preferencesProvider);
      if (context.mounted) {
        _showMessage(context, '偏好设置已保存');
      }
    } on Object {
      if (context.mounted) {
        _showMessage(context, '未能保存偏好设置');
      }
    }
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}

class _ProfileHero extends StatelessWidget {
  const _ProfileHero({
    required this.profile,
    required this.onEditName,
    required this.onPickAvatar,
  });

  final UserProfile profile;
  final VoidCallback onEditName;
  final VoidCallback onPickAvatar;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ClearFlowColors.sageSurface,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Semantics(
            button: true,
            label: '修改头像',
            child: InkWell(
              onTap: onPickAvatar,
              borderRadius: BorderRadius.circular(22),
              child: _Avatar(profile: profile),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.displayName,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  '所有数据都留在这台设备上',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF63705E),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: '修改用户名',
            onPressed: onEditName,
            icon: const Icon(Icons.edit_outlined),
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    final path = profile.avatarPath;
    final avatarExists = path != null && File(path).existsSync();
    return Container(
      width: 64,
      height: 64,
      clipBehavior: Clip.antiAlias,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(22),
      ),
      child: avatarExists
          ? Image.file(File(path), fit: BoxFit.cover, width: 64, height: 64)
          : Text(
              profile.fallbackInitial,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: ClearFlowColors.sage,
                fontSize: 26,
              ),
            ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 15, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 7),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _PreferenceRow extends StatelessWidget {
  const _PreferenceRow({
    required this.icon,
    required this.label,
    required this.trailing,
  });

  final IconData icon;
  final String label;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 21, color: ClearFlowColors.sage),
        const SizedBox(width: 11),
        Expanded(child: Text(label)),
        trailing,
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Icon(icon, size: 21, color: ClearFlowColors.sage),
          const SizedBox(width: 11),
          Expanded(child: Text(label)),
          Text(
            value,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: valueColor ?? const Color(0xFF72786D),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadError extends StatelessWidget {
  const _LoadError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('未能读取本地资料'),
          const SizedBox(height: 10),
          OutlinedButton(onPressed: onRetry, child: const Text('重试')),
        ],
      ),
    );
  }
}
