
import 'package:flutter/material.dart';

/// Colours taken from the web prototype (orange primary on warm background).
class AppColors {
  static const bg = Color(0xFFFFF7ED);
  static const card = Color(0xFFFFFFFF);
  static const primary = Color(0xFFF97316);
  static const primarySoft = Color(0xFFFFEDD5);
  static const ink = Color(0xFF1E293B);
  static const inkSoft = Color(0xFF64748B);
  static const line = Color(0xFFE2E8F0);
  static const strong = Color(0xFF16A34A);
  static const developing = Color(0xFFD97706);
  static const weak = Color(0xFFDC2626);
}

/// Minimum tap target for child-facing controls (NFR1.1).
const double kMinTap = 96;

Color levelColor(int accuracyPercent) {
  if (accuracyPercent >= 80) return AppColors.strong;
  if (accuracyPercent >= 50) return AppColors.developing;
  return AppColors.weak;
}

/// Uses the locally bundled Noto Sans Sinhala font (NFR1.2).
TextStyle sinhalaText(
  double size, {
  FontWeight weight = FontWeight.w600,
  Color color = AppColors.ink,
}) =>
    TextStyle(
      fontFamily: 'NotoSansSinhala',
      fontSize: size,
      fontWeight: weight,
      color: color,
    );

ThemeData buildTheme() {
  final base = ThemeData(
    useMaterial3: true,
    fontFamily: 'NotoSansSinhala',
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
    scaffoldBackgroundColor: AppColors.bg,
  );

  return base.copyWith(
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: AppColors.ink,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        minimumSize: const Size(64, 52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 15,
        ),
      ),
    ),
  );
}
