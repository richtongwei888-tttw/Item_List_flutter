import 'package:item_list_flutter/data/database/app_database.dart';
import 'package:item_list_flutter/data/notifications/local_notification_gateway.dart';
import 'package:item_list_flutter/features/tasks/application/notification_outbox_processor.dart';
import 'package:item_list_flutter/features/tasks/application/task_repository.dart';
import 'package:item_list_flutter/features/tasks/application/task_service.dart';

final class AppBootstrap {
  const AppBootstrap({
    required this.notificationInitializer,
    required this.processor,
  });

  final NotificationInitializer notificationInitializer;
  final PendingNotificationProcessor processor;

  Future<void> initialize() async {
    await notificationInitializer.initialize();
    await processor.processPending();
  }
}

final class ProductionDependencies {
  const ProductionDependencies({
    required this.database,
    required this.repository,
    required this.notificationGateway,
    required this.processor,
    required this.taskService,
  });

  final AppDatabase database;
  final DriftTaskRepository repository;
  final LocalNotificationGateway notificationGateway;
  final NotificationOutboxProcessor processor;
  final TaskService taskService;

  static Future<ProductionDependencies> create() async {
    final database = AppDatabase.defaults();
    final repository = DriftTaskRepository(database);
    final notificationGateway = LocalNotificationGateway();
    final processor = NotificationOutboxProcessor(
      database,
      notificationGateway,
    );
    final taskService = TaskService(
      repository,
      afterMutation: () async {
        await processor.processPending();
      },
    );
    try {
      await AppBootstrap(
        notificationInitializer: notificationGateway,
        processor: processor,
      ).initialize();
    } on Object {
      // Offline task storage must remain available when notifications fail.
    }
    return ProductionDependencies(
      database: database,
      repository: repository,
      notificationGateway: notificationGateway,
      processor: processor,
      taskService: taskService,
    );
  }
}
