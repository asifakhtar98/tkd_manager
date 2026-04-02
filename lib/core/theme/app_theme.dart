import 'package:flutter/material.dart';

/// Centralized Material 3 token system for the TKD Tournament Manager.
///
/// Light theme only — use [AppTheme.light] everywhere.
abstract final class AppTheme {
  /// Core brand color used as the primary seed.
  static const Color _brandPrimaryBlack = Color(0xFF000000);

  /// Accent / highlight color.
  static const Color _brandSecondaryGrey = Color(0xFF757575);

  /// Light surface used for chip backgrounds.
  static const Color _chipBackgroundGrey = Color(0xFFEEEEEE);

  /// Neutral divider grey.
  static const Color _dividerGrey = Color(0xFFE0E0E0);

  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _brandPrimaryBlack,
      primary: _brandPrimaryBlack,
      secondary: _brandSecondaryGrey,
      surface: Colors.white,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: _brandPrimaryBlack,
      error: const Color(0xFF424242),
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFFF7F7F7),
      colorScheme: colorScheme,

      iconTheme: const IconThemeData(color: _brandPrimaryBlack, size: 24),
      primaryIconTheme: const IconThemeData(color: Colors.white),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: _brandPrimaryBlack,
        selectionColor: Color(0xFFE0E0E0),
        selectionHandleColor: _brandPrimaryBlack,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: _brandPrimaryBlack,
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
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: _brandPrimaryBlack,
        unselectedItemColor: _brandSecondaryGrey,
        selectedIconTheme: IconThemeData(size: 26),
        elevation: 8,
      ),
      navigationRailTheme: const NavigationRailThemeData(
        backgroundColor: Colors.white,
        selectedIconTheme: IconThemeData(color: _brandPrimaryBlack),
        unselectedIconTheme: IconThemeData(color: _brandSecondaryGrey),
        selectedLabelTextStyle: TextStyle(
          color: _brandPrimaryBlack,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelTextStyle: TextStyle(color: _brandSecondaryGrey),
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: Colors.white,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _brandPrimaryBlack,
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color(0xFFE0E0E0),
          disabledForegroundColor: _brandSecondaryGrey,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _brandPrimaryBlack,
          disabledForegroundColor: Colors.grey.shade500,
          side: const BorderSide(color: _dividerGrey, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _brandPrimaryBlack,
          disabledForegroundColor: Colors.grey.shade500,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _brandPrimaryBlack,
        foregroundColor: Colors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return Colors.grey.shade200;
            }
            if (states.contains(WidgetState.selected)) {
              return _chipBackgroundGrey;
            }
            return Colors.transparent;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return Colors.grey.shade500;
            }
            if (states.contains(WidgetState.selected)) {
              return _brandPrimaryBlack;
            }
            return _brandSecondaryGrey;
          }),
          side: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return BorderSide(color: Colors.grey.shade300);
            }
            return const BorderSide(color: _dividerGrey);
          }),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ),

      cardTheme: const CardThemeData(
        elevation: 1,
        color: Colors.white,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          side: BorderSide(color: _dividerGrey, width: 0.5),
        ),
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        titleTextStyle: TextStyle(
          color: _brandPrimaryBlack,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        contentTextStyle: TextStyle(color: Color(0xFF424242), fontSize: 16),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
      ),
      popupMenuTheme: const PopupMenuThemeData(
        color: Colors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          side: BorderSide(color: _dividerGrey),
        ),
        textStyle: TextStyle(color: _brandPrimaryBlack, fontSize: 14),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: _brandPrimaryBlack.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(6),
        ),
        textStyle: const TextStyle(color: Colors.white, fontSize: 12),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return const Color(0xFFF5F5F5);
          }
          return Colors.white;
        }),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: _dividerGrey),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: _dividerGrey),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: _brandPrimaryBlack, width: 1.5),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        labelStyle: const TextStyle(color: _brandSecondaryGrey),
        hintStyle: const TextStyle(color: Color(0xFFBDBDBD)),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return Colors.grey.shade300;
          }
          if (states.contains(WidgetState.selected)) {
            return _brandPrimaryBlack;
          }
          return Colors.transparent;
        }),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return Colors.grey.shade300;
          }
          if (states.contains(WidgetState.selected)) {
            return _brandPrimaryBlack;
          }
          return _brandSecondaryGrey;
        }),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return Colors.grey.shade400;
          }
          if (states.contains(WidgetState.selected)) {
            return Colors.white;
          }
          return _brandSecondaryGrey;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return Colors.grey.shade200;
          }
          if (states.contains(WidgetState.selected)) {
            return _brandPrimaryBlack;
          }
          return _chipBackgroundGrey;
        }),
      ),
      sliderTheme: const SliderThemeData(
        activeTrackColor: _brandPrimaryBlack,
        inactiveTrackColor: _chipBackgroundGrey,
        thumbColor: _brandPrimaryBlack,
        overlayColor: Color(0x1A000000),
        valueIndicatorColor: _brandPrimaryBlack,
        valueIndicatorTextStyle: TextStyle(color: Colors.white),
      ),
      dataTableTheme: const DataTableThemeData(
        headingRowColor: WidgetStatePropertyAll(_chipBackgroundGrey),
        dataRowColor: WidgetStatePropertyAll(Colors.white),
        dividerThickness: 1,
        headingTextStyle: TextStyle(
          color: _brandPrimaryBlack,
          fontWeight: FontWeight.bold,
        ),
        dataTextStyle: TextStyle(color: Color(0xFF424242)),
      ),

      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: _brandPrimaryBlack,
        linearTrackColor: _chipBackgroundGrey,
      ),
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStatePropertyAll(
          _brandSecondaryGrey.withValues(alpha: 0.5),
        ),
        thickness: const WidgetStatePropertyAll(6),
        radius: const Radius.circular(10),
        interactive: true,
      ),
      tabBarTheme: const TabBarThemeData(
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white70,
        indicatorColor: _brandSecondaryGrey,
        labelStyle: TextStyle(fontWeight: FontWeight.bold),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: _chipBackgroundGrey,
        labelStyle: const TextStyle(
          color: _brandPrimaryBlack,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: BorderSide.none,
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: _brandPrimaryBlack,
        contentTextStyle: TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: _brandSecondaryGrey,
        textColor: _brandPrimaryBlack,
        selectedTileColor: Color(0xFFE0E0E0),
      ),
      dividerTheme: const DividerThemeData(
        thickness: 1,
        space: 24,
        color: _dividerGrey,
      ),
      badgeTheme: const BadgeThemeData(
        backgroundColor: _brandPrimaryBlack,
        textColor: Colors.white,
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}
