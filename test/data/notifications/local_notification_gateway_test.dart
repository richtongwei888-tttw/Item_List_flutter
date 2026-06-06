import 'package:flutter_test/flutter_test.dart';
import 'package:item_list_flutter/app/app_bootstrap.dart';
import 'package:item_list_flutter/app/app_lifecycle_observer.dart';
import 'package:item_list_flutter/data/notifications/local_notification_gateway.dart';
import 'package:item_list_flutter/features/tasks/application/notification_outbox_processor.dart';
import 'package:timezone/timezone.dart' as tz;

void main() {
  test('initializes the device IANA timezone before notifications', () async {
    final client = _FakeNotificationClient();
    final gateway = LocalNotificationGateway(
      client: client,
      deviceTimeZone: const _FakeDeviceTimeZone('Asia/Shanghai'),
    );

    await gateway.initialize();

    expect(tz.local.name, 'Asia/Shanghai');
    expect(client.initialized, isTrue);
  });

  test('normalizes the Android GMT timezone alias', () async {
    final gateway = LocalNotificationGateway(
      client: _FakeNotificationClient(),
      deviceTimeZone: const _FakeDeviceTimeZone('GMT'),
    );

    await gateway.initialize();

    expect(tz.local.name, 'Etc/UTC');
  });

  test('schedules and cancels with the same stable task id', () async {
    final client = _FakeNotificationClient();
    final gateway = LocalNotificationGateway(
      client: client,
      deviceTimeZone: const _FakeDeviceTimeZone('Asia/Shanghai'),
    );
    await gateway.initialize();

    await gateway.schedule(
      taskId: 'task-42',
      title: '提交周报',
      scheduledAt: DateTime(2026, 6, 8, 16),
    );
    await gateway.cancel('task-42');

    final expectedId = LocalNotificationGateway.notificationIdFor('task-42');
    expect(client.scheduled.single.id, expectedId);
    expect(client.scheduled.single.payload, 'task-42');
    expect(client.scheduled.single.scheduledAt.location.name, 'Asia/Shanghai');
    expect(client.cancelled, [expectedId]);
  });

  test('permission denial is returned as a typed result', () async {
    final client = _FakeNotificationClient()..permissionResult = false;
    final gateway = LocalNotificationGateway(
      client: client,
      deviceTimeZone: const _FakeDeviceTimeZone('Asia/Shanghai'),
    );

    expect(
      await gateway.requestPermission(),
      NotificationPermissionStatus.denied,
    );
  });

  test(
    'bootstrap initializes notifications then retries pending jobs',
    () async {
      final events = <String>[];
      final bootstrap = AppBootstrap(
        notificationInitializer: _FakeInitializer(events),
        processor: _FakeProcessor(events),
      );

      await bootstrap.initialize();

      expect(events, ['initialize', 'process']);
    },
  );

  test(
    'resume retries pending jobs and refreshes date-sensitive state',
    () async {
      final events = <String>[];
      final observer = AppLifecycleObserver(
        processor: _FakeProcessor(events),
        refreshDateSensitiveState: () => events.add('refresh'),
      );

      await observer.handleResumed();

      expect(events, ['refresh', 'process']);
    },
  );
}

final class _FakeNotificationClient implements LocalNotificationClient {
  bool initialized = false;
  bool? permissionResult = true;
  final scheduled = <LocalNotificationRequest>[];
  final cancelled = <int>[];

  @override
  Future<void> cancel(int id) async {
    cancelled.add(id);
  }

  @override
  Future<void> initialize({
    required void Function(String taskId) onTaskSelected,
  }) async {
    initialized = true;
  }

  @override
  Future<bool?> requestPermission() async => permissionResult;

  @override
  Future<void> zonedSchedule(LocalNotificationRequest request) async {
    scheduled.add(request);
  }
}

final class _FakeDeviceTimeZone implements DeviceTimeZone {
  const _FakeDeviceTimeZone(this.identifier);

  final String identifier;

  @override
  Future<String> localIdentifier() async => identifier;
}

final class _FakeInitializer implements NotificationInitializer {
  const _FakeInitializer(this.events);

  final List<String> events;

  @override
  Future<void> initialize() async {
    events.add('initialize');
  }
}

final class _FakeProcessor implements PendingNotificationProcessor {
  const _FakeProcessor(this.events);

  final List<String> events;

  @override
  Future<NotificationProcessResult> processPending() async {
    events.add('process');
    return const NotificationProcessResult(succeeded: 0, failed: 0);
  }
}
