import 'package:flutter/material.dart';

class ClearFlowApp extends StatelessWidget {
  const ClearFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: const SizedBox.shrink(),
        bottomNavigationBar: NavigationBar(
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.check_circle_outline),
              label: '任务',
            ),
            NavigationDestination(icon: Icon(Icons.donut_large), label: '统计'),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              label: '我的',
            ),
          ],
        ),
      ),
    );
  }
}
