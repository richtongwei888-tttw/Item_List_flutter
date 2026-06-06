enum ReminderOffset {
  immediate,
  atTime,
  tenMinutes,
  thirtyMinutes,
  oneHour,
  twoHours,
  oneDay,
  dateAtNine;

  Duration? get duration => switch (this) {
    ReminderOffset.immediate => Duration.zero,
    ReminderOffset.atTime => Duration.zero,
    ReminderOffset.tenMinutes => const Duration(minutes: 10),
    ReminderOffset.thirtyMinutes => const Duration(minutes: 30),
    ReminderOffset.oneHour => const Duration(hours: 1),
    ReminderOffset.twoHours => const Duration(hours: 2),
    ReminderOffset.oneDay => const Duration(days: 1),
    ReminderOffset.dateAtNine => null,
  };
}
