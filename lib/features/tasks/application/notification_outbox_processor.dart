import 'package:item_list_flutter/data/database/app_database.dart';
import 'package:item_list_flutter/features/tasks/application/notification_gateway.dart';
import 'package:item_list_flutter/features/tasks/domain/reminder_sync_status.dart';

final class NotificationProcessResult {
  const NotificationProcessResult({
    required this.succeeded,
    required this.failed,
  });

  final int succeeded;
  final int failed;
}

final class NotificationOutboxProcessor {
  const NotificationOutboxProcessor(this._database, this._gateway);

  final AppDatabase _database;
  final NotificationGateway _gateway;

  Future<NotificationProcessResult> processPending() async {
    final jobs = await _database.pendingNotificationJobs();
    var succeeded = 0;
    var failed = 0;

    for (final job in jobs) {
      try {
        if (job.operation == 'schedule') {
          final task = await _database.findTaskRow(job.taskId);
          if (task == null || job.scheduledAt == null) {
            await _gateway.cancel(job.taskId);
          } else {
            await _gateway.schedule(
              taskId: job.taskId,
              title: task.title,
              scheduledAt: job.scheduledAt!,
            );
          }
        } else {
          await _gateway.cancel(job.taskId);
        }
        await _database.completeNotificationJob(
          job.id,
          job.taskId,
          ReminderSyncStatus.synced.name,
        );
        succeeded++;
      } on Object catch (error) {
        await _database.failNotificationJob(
          job.id,
          job.taskId,
          error.toString(),
          ReminderSyncStatus.failed.name,
        );
        failed++;
      }
    }

    return NotificationProcessResult(succeeded: succeeded, failed: failed);
  }
}
