extension LocalDateTime on DateTime {
  DateTime get dateOnly => DateTime(year, month, day);

  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999, 999);
}
