import 'package:flutter/material.dart';

abstract final class ClearFlowColors {
  static const background = Color(0xFFF7F5EF);
  static const text = Color(0xFF282C23);
  static const sage = Color(0xFF607A63);
  static const sageSurface = Color(0xFFE7EEE2);
  static const coral = Color(0xFFE7674C);
  static const amber = Color(0xFFD2A847);
  static const outline = Color(0xFFD8DCD2);
}

abstract final class ClearFlowTheme {
  static ThemeData get light {
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: ClearFlowColors.sage,
          brightness: Brightness.light,
          surface: ClearFlowColors.background,
          error: ClearFlowColors.coral,
        ).copyWith(
          primary: ClearFlowColors.sage,
          onPrimary: Colors.white,
          secondary: ClearFlowColors.coral,
          onSecondary: Colors.white,
          surface: ClearFlowColors.background,
          onSurface: ClearFlowColors.text,
          outline: ClearFlowColors.outline,
        );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: ClearFlowColors.background,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          color: ClearFlowColors.text,
          fontSize: 30,
          height: 1.15,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.8,
        ),
        titleLarge: TextStyle(
          color: ClearFlowColors.text,
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
        bodyLarge: TextStyle(
          color: ClearFlowColors.text,
          fontSize: 16,
          height: 1.45,
        ),
      ),
      cardTheme: const CardThemeData(
        color: Colors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18)),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(color: ClearFlowColors.sage, width: 1.5),
        ),
      ),
      navigationBarTheme: const NavigationBarThemeData(
        height: 68,
        backgroundColor: Colors.white,
        indicatorColor: ClearFlowColors.sageSurface,
        labelTextStyle: WidgetStatePropertyAll(
          TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: ClearFlowColors.coral,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18)),
        ),
      ),
    );
  }
}
