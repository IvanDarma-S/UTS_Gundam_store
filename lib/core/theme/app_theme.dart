import 'package:flutter/material.dart';
// Sesuaikan path import dengan struktur project kamu
import 'package:apps_marketplace_integration_backend/core/constants/api_colors.dart';

class AppTheme {
  // ── LIGHT MODE ───────────────────────────────────────────
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary, // ← WAJIB diisi
        brightness: Brightness.light,
        primary: AppColors.primary,
        surface: AppColors.surface,
        error: AppColors.error,
        onSurface: AppColors.textPrimary,
      ),
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      dividerColor: AppColors.divider,
    );
  }

  // ── DARK MODE ────────────────────────────────────────────
  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor:
            AppColors.accent, // ← Menggunakan accent sebagai benih warna dark
        brightness: Brightness.dark,
        primary: AppColors.accent,
        surface: AppColors.darkSurface,
        onSurface: AppColors.darkTextPrimary,
      ),
      scaffoldBackgroundColor: AppColors.darkBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkSurface,
        foregroundColor: AppColors.darkTextPrimary,
        elevation: 0,
      ),
      dividerColor: AppColors.darkDivider,
      cardColor: AppColors.darkSurfaceCard,
    );
  }
}
