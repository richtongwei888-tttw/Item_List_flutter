import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:item_list_flutter/app/app_theme.dart';
import 'package:item_list_flutter/features/shell/presentation/app_shell.dart';

class ClearFlowApp extends StatelessWidget {
  const ClearFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '清序',
      debugShowCheckedModeBanner: false,
      theme: ClearFlowTheme.light,
      locale: const Locale('zh', 'CN'),
      supportedLocales: const [Locale('zh', 'CN')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      home: const AppShell(),
    );
  }
}
