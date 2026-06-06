import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:item_list_flutter/features/tasks/domain/reminder_offset.dart';
import 'package:item_list_flutter/features/tasks/domain/task_priority.dart';
import 'package:item_list_flutter/features/tasks/presentation/task_form_screen.dart';

import '../test/helpers/test_app.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('offline task workflow survives an app rebuild', (tester) async {
    final repository = MemoryTaskRepository();
    addTearDown(repository.close);

    await tester.pumpWidget(buildOfflineTestApp(repository));
    await _pumpUntilFound(tester, find.text('还没有任务'));

    await tester.tap(find.byTooltip('新增任务'));
    await _pumpUntilFound(tester, find.text('任务标题'));

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), '准备周报');
    await tester.enterText(fields.at(1), '整理项目数据并确认最终数字');
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pump();

    await tester.tap(find.text('选择日期'));
    await _pumpUntilFound(tester, find.text('确定'));
    await tester.tap(find.text('7').last);
    await tester.pump(const Duration(milliseconds: 100));
    await tester.tap(find.text('确定'));
    await _pumpUntilFound(tester, find.text('当天 09:00'));

    await tester.tap(find.text('高'));
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('当天 09:00'), findsOneWidget);

    await tester.tap(find.text('保存任务'));
    await _pumpUntilFound(tester, find.text('准备周报'));
    await _pumpUntilGone(tester, find.byType(TaskFormScreen));

    expect(repository.tasks.single.priority, TaskPriority.high);
    expect(repository.tasks.single.note, '整理项目数据并确认最终数字');
    expect(repository.tasks.single.reminderEnabled, isTrue);
    expect(repository.tasks.single.reminderOffset, ReminderOffset.dateAtNine);
    expect(find.text('明天'), findsWidgets);
    expect(find.text('高优先级'), findsOneWidget);

    await tester.tap(find.text('统计'));
    await _pumpUntilFound(tester, find.text('已完成 0 / 1 项'));
    expect(find.text('已完成 0 / 1 项'), findsOneWidget);
    expect(find.text('1 项任务即将到期'), findsOneWidget);

    await tester.tap(find.text('任务'));
    await _pumpUntilFound(tester, find.text('准备周报'));
    await tester.tap(find.text('准备周报'));
    await _pumpUntilFound(tester, find.text('整理项目数据并确认最终数字'));
    expect(find.text('整理项目数据并确认最终数字'), findsOneWidget);

    await tester.tap(find.text('编辑'));
    await _pumpUntilFound(tester, find.text('编辑任务'));
    await tester.enterText(find.byType(TextFormField).first, '准备最终周报');
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.tap(find.text('保存任务'));
    await _pumpUntilFound(tester, find.text('准备最终周报'));
    await _pumpUntilGone(tester, find.byType(TaskFormScreen));
    expect(repository.tasks.single.title, '准备最终周报');

    await tester.tap(find.byTooltip('标记为已完成'));
    await _pumpUntil(tester, () => repository.tasks.single.completedAt != null);
    expect(repository.tasks.single.completedAt, isNotNull);

    await tester.tap(find.widgetWithText(ChoiceChip, '已完成'));
    await _pumpUntilFound(tester, find.text('准备最终周报'));
    expect(find.text('准备最终周报'), findsOneWidget);

    await tester.tap(find.byTooltip('恢复为未完成'));
    await _pumpUntil(tester, () => repository.tasks.single.completedAt == null);
    expect(repository.tasks.single.completedAt, isNull);

    await tester.tap(find.widgetWithText(ChoiceChip, '待处理'));
    await _pumpUntilFound(tester, find.text('准备最终周报'));
    await tester.tap(find.text('准备最终周报'));
    await _pumpUntilFound(tester, find.text('删除'));
    await tester.ensureVisible(find.text('删除'));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.text('删除'));
    await _pumpUntilFound(tester, find.text('确认删除'));
    await tester.tap(find.text('确认删除'));
    await _pumpUntil(tester, () => repository.tasks.isEmpty);
    expect(repository.tasks, isEmpty);

    await _pumpUntilFound(tester, find.text('任务已删除'));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(
      find.descendant(of: find.byType(SnackBar), matching: find.text('撤销')),
    );
    await _pumpUntil(tester, () => repository.tasks.length == 1);
    await _pumpUntilFound(tester, find.text('准备最终周报'));
    expect(repository.tasks, hasLength(1));

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();
    await tester.pumpWidget(buildOfflineTestApp(repository));
    await _pumpUntilFound(tester, find.text('准备最终周报'));

    expect(repository.tasks.single.completedAt, isNull);
    expect(find.text('准备最终周报'), findsOneWidget);
  });
}

Future<void> _pumpUntilFound(WidgetTester tester, Finder finder) async {
  for (var attempt = 0; attempt < 80; attempt++) {
    await tester.pump(const Duration(milliseconds: 50));
    if (finder.evaluate().isNotEmpty) {
      return;
    }
  }
  fail('Timed out waiting for $finder');
}

Future<void> _pumpUntil(WidgetTester tester, bool Function() condition) async {
  for (var attempt = 0; attempt < 80; attempt++) {
    await tester.pump(const Duration(milliseconds: 50));
    if (condition()) {
      return;
    }
  }
  fail('Timed out waiting for integration state');
}

Future<void> _pumpUntilGone(WidgetTester tester, Finder finder) async {
  for (var attempt = 0; attempt < 80; attempt++) {
    await tester.pump(const Duration(milliseconds: 50));
    if (finder.evaluate().isEmpty) {
      return;
    }
  }
  fail('Timed out waiting for $finder to disappear');
}
