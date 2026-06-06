import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:item_list_flutter/app/app_theme.dart';
import 'package:item_list_flutter/features/profile/presentation/profile_providers.dart';
import 'package:item_list_flutter/features/profile/presentation/profile_screen.dart';
import 'package:item_list_flutter/features/shell/presentation/app_shell.dart';
import 'package:item_list_flutter/features/statistics/presentation/statistics_screen.dart';
import 'package:item_list_flutter/features/tasks/domain/task.dart';
import 'package:item_list_flutter/features/tasks/presentation/task_form_screen.dart';
import 'package:item_list_flutter/features/tasks/presentation/task_list_screen.dart';
import 'package:item_list_flutter/features/tasks/presentation/task_providers.dart';

class ClearFlowApp extends StatelessWidget {
  const ClearFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '清序',
      debugShowCheckedModeBanner: false,
      theme: ClearFlowTheme.light,
      locale: const Locale('zh', 'CN'),
      supportedLocales: const [Locale('zh', 'CN')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      home: const _ClearFlowHome(),
    );
  }
}

class _ClearFlowHome extends ConsumerStatefulWidget {
  const _ClearFlowHome();

  @override
  ConsumerState<_ClearFlowHome> createState() => _ClearFlowHomeState();
}

class _ClearFlowHomeState extends ConsumerState<_ClearFlowHome> {
  @override
  void initState() {
    super.initState();
    Future<void>.microtask(_applyDefaultFilter);
  }

  Future<void> _applyDefaultFilter() async {
    try {
      final preferences = await ref
          .read(profileRepositoryProvider)
          .getPreferences();
      if (mounted) {
        ref
            .read(taskFilterProvider.notifier)
            .setFilter(preferences.defaultFilter);
      }
    } on Object {
      // The task list remains usable with its pending-filter fallback.
    }
  }

  @override
  Widget build(BuildContext context) {
    final preferences = ref.watch(preferencesProvider).value;
    final mediaQuery = MediaQuery.of(context);
    return MediaQuery(
      data: mediaQuery.copyWith(
        disableAnimations:
            mediaQuery.disableAnimations ||
            preferences?.animationsEnabled == false,
      ),
      child: AppShell(
        taskPage: TaskListScreen(
          onAddTask: () => _openTaskForm(),
          onEditTask: _openTaskForm,
        ),
        statisticsPage: const StatisticsScreen(),
        profilePage: const ProfileScreen(),
        onAddTask: () => _openTaskForm(),
      ),
    );
  }

  Future<void> _openTaskForm([Task? task]) async {
    final saved = await Navigator.of(context).push<Task>(
      MaterialPageRoute(builder: (context) => TaskFormScreen(task: task)),
    );
    if (saved == null || !mounted) {
      return;
    }
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(task == null ? '任务已添加' : '任务已更新')));
  }
}
