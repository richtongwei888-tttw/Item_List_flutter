sealed class AppFailure {
  const AppFailure(this.message);

  final String message;
}

final class ValidationFailure extends AppFailure {
  const ValidationFailure(super.message);
}

final class PersistenceFailure extends AppFailure {
  const PersistenceFailure() : super('未能保存更改，已恢复到操作前状态');
}

final class ReminderFailure extends AppFailure {
  const ReminderFailure() : super('任务已保存，但提醒设置失败');
}
