import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:item_list_flutter/features/tasks/application/notification_outbox_processor.dart';
import 'package:item_list_flutter/features/tasks/presentation/task_providers.dart';

final class AppLifecycleObserver extends WidgetsBindingObserver {
  AppLifecycleObserver({
    required this.processor,
    required this.refreshDateSensitiveState,
  });

  final PendingNotificationProcessor processor;
  final VoidCallback refreshDateSensitiveState;

  Future<void> handleResumed() async {
    refreshDateSensitiveState();
    await processor.processPending();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(handleResumed());
    }
  }
}

final class AppLifecycleHost extends ConsumerStatefulWidget {
  const AppLifecycleHost({
    required this.processor,
    required this.child,
    super.key,
  });

  final PendingNotificationProcessor processor;
  final Widget child;

  @override
  ConsumerState<AppLifecycleHost> createState() => _AppLifecycleHostState();
}

final class _AppLifecycleHostState extends ConsumerState<AppLifecycleHost> {
  late final AppLifecycleObserver _observer;

  @override
  void initState() {
    super.initState();
    _observer = AppLifecycleObserver(
      processor: widget.processor,
      refreshDateSensitiveState: () {
        ref.invalidate(currentTimeProvider);
      },
    );
    WidgetsBinding.instance.addObserver(_observer);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(_observer);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
