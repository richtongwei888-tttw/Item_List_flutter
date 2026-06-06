abstract interface class NotificationGateway {
  Future<void> schedule({
    required String taskId,
    required String title,
    required DateTime scheduledAt,
  });

  Future<void> cancel(String taskId);
}
