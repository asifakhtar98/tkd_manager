import 'package:flutter/material.dart';

/// Centralized Material 3 token system for the TKD Tournament Manager.
///
/// Light theme only — use [AppTheme.light] everywhere.
abstract final class AppTheme {
  // ─────────────────────────────────────────
  // Brand Colors
  // ─────────────────────────────────────────

  /// Deep navy — core brand color used as the primary seed.
  static const Color _brandPrimaryNavy = Color(0xFF1A237E);

  /// Arena gold — accent / highlight color.
  static const Color _brandSecondaryGold = Color(0xFFFBC02D);

  /// Light indigo surface used for chip backgrounds.
  static const Color _chipBackgroundIndigo = Color(0xFFE8EAF6);

  /// Neutral divider grey.
  static const Color _dividerGrey = Color(0xFFE0E0E0);

  // ─────────────────────────────────────────
  // Theme Data
  // ─────────────────────────────────────────

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _brandPrimaryNavy,
          secondary: _brandSecondaryGold,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: _brandPrimaryNavy,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.15,
          ),
          iconTheme: IconThemeData(color: Colors.white),
          actionsIconTheme: IconThemeData(color: Colors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: _brandPrimaryNavy,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
        cardTheme: const CardThemeData(
          elevation: 2,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        tabBarTheme: const TabBarThemeData(
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: _brandSecondaryGold,
        ),
        chipTheme: ChipThemeData(
          backgroundColor: _chipBackgroundIndigo,
          labelStyle: const TextStyle(color: _brandPrimaryNavy),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        snackBarTheme: const SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
        dividerTheme: const DividerThemeData(
          thickness: 1,
          color: _dividerGrey,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      );
}
