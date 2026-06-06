import 'package:flutter_test/flutter_test.dart';
import 'package:item_list_flutter/app/app.dart';

void main() {
  testWidgets('shows the Clear Flow task shell', (tester) async {
    await tester.pumpWidget(const ClearFlowApp());

    expect(find.text('任务'), findsOneWidget);
    expect(find.text('统计'), findsOneWidget);
    expect(find.text('我的'), findsOneWidget);
  });
}
