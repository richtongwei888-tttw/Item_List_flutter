enum TaskPriority {
  low,
  normal,
  high;

  int get sortWeight => switch (this) {
    TaskPriority.low => 0,
    TaskPriority.normal => 1,
    TaskPriority.high => 2,
  };
}
