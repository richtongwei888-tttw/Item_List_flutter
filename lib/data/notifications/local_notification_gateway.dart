import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:item_list_flutter/features/tasks/application/notification_gateway.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

enum NotificationPermissionStatus { granted, denied, unavailable }

abstract interface class NotificationInitializer {
  Future<void> initialize();
}

abstract interface class NotificationPermissionRequester {
  Future<NotificationPermissionStatus> requestPermission();
}

abstract interface class DeviceTimeZone {
  Future<String> localIdentifier();
}

final class PluginDeviceTimeZone implements DeviceTimeZone {
  const PluginDeviceTimeZone();

  @override
  Future<String> localIdentifier() async {
    final timezone = await FlutterTimezone.getLocalTimezone();
    return timezone.identifier;
  }
}

final class LocalNotificationRequest {
  const LocalNotificationRequest({
    required this.id,
    required this.title,
    required this.body,
    required this.scheduledAt,
    required this.payload,
  });

  final int id;
  final String title;
  final String body;
  final tz.TZDateTime scheduledAt;
  final String payload;
}

abstract interface class LocalNotificationClient {
  Future<void> initialize({
    required void Function(String taskId) onTaskSelected,
  });

  Future<bool?> requestPermission();

  Future<void> zonedSchedule(LocalNotificationRequest request);

  Future<void> cancel(int id);
}

final class PluginLocalNotificationClient implements LocalNotificationClient {
  PluginLocalNotificationClient([FlutterLocalNotificationsPlugin? plugin])
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;

  @override
  Future<void> initialize({
    required void Function(String taskId) onTaskSelected,
  }) async {
    const settings = InitializationSettings(
      android: AndroidInitializationSettings('ic_stat_clear_flow'),
      iOS: IOSInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
    );
    await _plugin.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: (response) {
        final payload = response.payload;
        if (payload != null && payload.isNotEmpty) {
          onTaskSelected(payload);
        }
      },
    );
  }

  @override
  Future<bool?> requestPermission() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
    }
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    }
    return null;
  }

  @override
  Future<void> zonedSchedule(LocalNotificationRequest request) {
    return _plugin.zonedSchedule(
      id: request.id,
      title: request.title,
      body: request.body,
      scheduledDate: request.scheduledAt,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'task_reminders',
          '任务提醒',
          channelDescription: '在任务到期前显示本地提醒',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: request.payload,
    );
  }

  @override
  Future<void> cancel(int id) => _plugin.cancel(id: id);
}

final class LocalNotificationGateway
    implements
        NotificationGateway,
        NotificationInitializer,
        NotificationPermissionRequester {
  LocalNotificationGateway({
    LocalNotificationClient? client,
    DeviceTimeZone? deviceTimeZone,
  }) : _client = client ?? PluginLocalNotificationClient(),
       _deviceTimeZone = deviceTimeZone ?? const PluginDeviceTimeZone();

  final LocalNotificationClient _client;
  final DeviceTimeZone _deviceTimeZone;
  final StreamController<String> _selectedTaskIds =
      StreamController<String>.broadcast();
  bool _initialized = false;

  Stream<String> get selectedTaskIds => _selectedTaskIds.stream;

  @override
  Future<void> initialize() async {
    if (_initialized) {
      return;
    }
    tz_data.initializeTimeZones();
    final identifier = await _deviceTimeZone.localIdentifier();
    tz.setLocalLocation(tz.getLocation(identifier));
    await _client.initialize(onTaskSelected: _selectedTaskIds.add);
    _initialized = true;
  }

  @override
  Future<NotificationPermissionStatus> requestPermission() async {
    final granted = await _client.requestPermission();
    return switch (granted) {
      true => NotificationPermissionStatus.granted,
      false => NotificationPermissionStatus.denied,
      null => NotificationPermissionStatus.unavailable,
    };
  }

  @override
  Future<void> schedule({
    required String taskId,
    required String title,
    required DateTime scheduledAt,
  }) async {
    await initialize();
    await _client.zonedSchedule(
      LocalNotificationRequest(
        id: notificationIdFor(taskId),
        title: '清序提醒',
        body: title,
        scheduledAt: tz.TZDateTime.from(scheduledAt, tz.local),
        payload: taskId,
      ),
    );
  }

  @override
  Future<void> cancel(String taskId) async {
    await initialize();
    await _client.cancel(notificationIdFor(taskId));
  }

  static int notificationIdFor(String taskId) {
    var hash = 0x811c9dc5;
    for (final codeUnit in taskId.codeUnits) {
      hash ^= codeUnit;
      hash = (hash * 0x01000193) & 0xffffffff;
    }
    return hash & 0x7fffffff;
  }
}
