import 'package:clock/clock.dart';

abstract interface class AppClock {
  DateTime now();
}

final class SystemAppClock implements AppClock {
  const SystemAppClock();

  @override
  DateTime now() => clock.now();
}
