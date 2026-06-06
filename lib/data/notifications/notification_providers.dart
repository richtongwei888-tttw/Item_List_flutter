import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:item_list_flutter/data/notifications/local_notification_gateway.dart';

final notificationPermissionRequesterProvider =
    Provider<NotificationPermissionRequester>((ref) {
      return const UnavailableNotificationPermissionRequester();
    });

final class UnavailableNotificationPermissionRequester
    implements NotificationPermissionRequester {
  const UnavailableNotificationPermissionRequester();

  @override
  Future<NotificationPermissionStatus> requestPermission() async {
    return NotificationPermissionStatus.unavailable;
  }
}
