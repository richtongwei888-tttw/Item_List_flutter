import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:item_list_flutter/features/shell/presentation/app_shell.dart';

void main() {
  testWidgets('switches tabs and shows add action only on tasks', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AppShell(
          taskPage: Text('任务页面'),
          statisticsPage: Text('统计页面'),
          profilePage: Text('我的页面'),
        ),
      ),
    );

    expect(find.text('任务页面'), findsOneWidget);
    expect(find.byTooltip('新增任务'), findsOneWidget);

    await tester.tap(find.text('统计'));
    await tester.pumpAndSettle();

    expect(find.text('统计页面'), findsOneWidget);
    expect(find.byTooltip('新增任务'), findsNothing);

    await tester.tap(find.text('我的'));
    await tester.pumpAndSettle();

    expect(find.text('我的页面'), findsOneWidget);
  });

  testWidgets('keeps task page state while switching tabs', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AppShell(
          taskPage: _CounterPage(),
          statisticsPage: Text('统计页面'),
          profilePage: Text('我的页面'),
        ),
      ),
    );

    await tester.tap(find.text('增加'));
    await tester.pump();
    expect(find.text('1'), findsOneWidget);

    await tester.tap(find.text('统计'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('任务'));
    await tester.pumpAndSettle();

    expect(find.text('1'), findsOneWidget);
  });
}

class _CounterPage extends StatefulWidget {
  const _CounterPage();

  @override
  State<_CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<_CounterPage> {
  var count = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('$count'),
        TextButton(
          onPressed: () => setState(() => count++),
          child: const Text('增加'),
        ),
      ],
    );
  }
}
