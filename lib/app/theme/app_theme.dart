import 'package:flutter/material.dart';

class AppColors {
  static const blue = Color(0xFF1D4ED8);
  static const blueDeep = Color(0xFF1E3A8A);
  static const blueSoft = Color(0xFFEEF2FF);
  static const orange = Color(0xFFF97316);
  static const orangeSoft = Color(0xFFFFF1E6);
  static const bg = Color(0xFFFAFAF7);
  static const surface = Color(0xFFFFFFFF);
  static const ink = Color(0xFF0B1220);
  static const muted = Color(0xFF6B7280);
  static const mutedSoft = Color(0xFF9AA0AA);
  static const line = Color(0x140B1220);
  static const lineStrong = Color(0x1F0B1220);
}

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.blue,
        surface: AppColors.surface,
      ),
      scaffoldBackgroundColor: AppColors.bg,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.bg,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
    );
  }
}
