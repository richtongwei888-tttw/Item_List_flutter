import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:item_list_flutter/app/app.dart';
import 'package:item_list_flutter/app/app_bootstrap.dart';
import 'package:item_list_flutter/app/app_lifecycle_observer.dart';
import 'package:item_list_flutter/data/notifications/notification_providers.dart';
import 'package:item_list_flutter/features/tasks/presentation/task_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dependencies = await ProductionDependencies.create();
  runApp(
    ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(dependencies.database),
        taskRepositoryProvider.overrideWithValue(dependencies.repository),
        taskServiceProvider.overrideWithValue(dependencies.taskService),
        notificationPermissionRequesterProvider.overrideWithValue(
          dependencies.notificationGateway,
        ),
      ],
      child: AppLifecycleHost(
        processor: dependencies.processor,
        child: const ClearFlowApp(),
      ),
    ),
  );
}
