import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:item_list_flutter/features/tasks/domain/task.dart';
import 'package:item_list_flutter/features/tasks/domain/task_priority.dart';
import 'package:item_list_flutter/features/tasks/presentation/widgets/task_card.dart';

void main() {
  final now = DateTime(2026, 6, 6, 10);

  testWidgets('shows due state note indicator and priority text', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TaskCard(
            task: Task.test(
              title: '提交项目周报',
              note: '整理进展和风险',
              dueDate: DateTime(2026, 6, 6, 18),
              priority: TaskPriority.high,
            ),
            now: now,
            onToggle: () async {},
            onEdit: () {},
            onDelete: () async {},
          ),
        ),
      ),
    );

    expect(find.text('提交项目周报'), findsOneWidget);
    expect(find.text('今天 18:00'), findsOneWidget);
    expect(find.text('高优先级'), findsOneWidget);
    expect(find.byIcon(Icons.notes_rounded), findsOneWidget);
  });

  testWidgets('expands note and exposes edit and delete actions', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TaskCard(
            task: Task.test(note: '记得带资料'),
            now: now,
            onToggle: () async {},
            onEdit: () {},
            onDelete: () async {},
          ),
        ),
      ),
    );

    expect(find.text('记得带资料'), findsNothing);

    await tester.tap(find.text('Test task'));
    await tester.pumpAndSettle();

    expect(find.text('记得带资料'), findsOneWidget);
    expect(find.text('编辑'), findsOneWidget);
    expect(find.text('删除'), findsOneWidget);
  });

  testWidgets('no-note task still exposes edit and delete actions', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TaskCard(
            task: Task.test(),
            now: now,
            onToggle: () async {},
            onEdit: () {},
            onDelete: () async {},
          ),
        ),
      ),
    );

    await tester.tap(find.text('Test task'));
    await tester.pumpAndSettle();

    expect(find.text('编辑'), findsOneWidget);
    expect(find.text('删除'), findsOneWidget);
  });

  testWidgets('tapping completion control calls toggle', (tester) async {
    var toggles = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TaskCard(
            task: Task.test(),
            now: now,
            onToggle: () async => toggles++,
            onEdit: () {},
            onDelete: () async {},
          ),
        ),
      ),
    );

    await tester.tap(find.byTooltip('标记为已完成'));
    await tester.pump();

    expect(toggles, 1);
  });
}
