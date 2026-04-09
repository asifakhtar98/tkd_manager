import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:tkd_saas/features/bracket/presentation/widgets/tie_sheet_theme_config.dart';

void main() {
  group('TieSheetThemeMode', () {
    test('has correct labels', () {
      expect(TieSheetThemeMode.colourful.label, 'Colourful');
      expect(TieSheetThemeMode.highContrast.label, 'High Contrast');
      expect(TieSheetThemeMode.customMode.label, 'Custom');
    });

    test('values list has exactly three entries', () {
      expect(TieSheetThemeMode.values, hasLength(3));
    });
  });

  group('TieSheetThemeConfig', () {
    group('computed properties', () {
      test('logoRowHeight is derived from logoMaxHeight + logoPadding * 2', () {
        const config = TieSheetThemeConfig.colourfulPreset;
        // logoMaxHeight=60, logoPadding=12 → 60+24=84
        expect(config.logoRowHeight, 84.0);
        expect(
          config.logoRowHeight,
          config.logoMaxHeight + config.logoPadding * 2,
        );
      });

      test('logoRowHeight formula holds for highContrast preset', () {
        const config = TieSheetThemeConfig.highContrastPreset;
        expect(
          config.logoRowHeight,
          config.logoMaxHeight + config.logoPadding * 2,
        );
      });
    });

    group('fromMode factory', () {
      test('colourful returns colourful preset', () {
        final config = TieSheetThemeConfig.fromMode(
          TieSheetThemeMode.colourful,
        );
        expect(config, TieSheetThemeConfig.colourfulPreset);
      });

      test('highContrast returns highContrast preset', () {
        final config = TieSheetThemeConfig.fromMode(
          TieSheetThemeMode.highContrast,
        );
        expect(config, TieSheetThemeConfig.highContrastPreset);
      });

      test('customMode returns colourful as starting base', () {
        final config = TieSheetThemeConfig.fromMode(
          TieSheetThemeMode.customMode,
        );
        expect(config, TieSheetThemeConfig.colourfulPreset);
      });
    });

    group('equality', () {
      test('identical presets are equal', () {
        const configA = TieSheetThemeConfig.colourfulPreset;
        const configB = TieSheetThemeConfig.colourfulPreset;
        expect(configA, equals(configB));
        expect(configA.hashCode, configB.hashCode);
      });

      test('different presets are not equal', () {
        const colourfulConfig = TieSheetThemeConfig.colourfulPreset;
        const highContrastConfig = TieSheetThemeConfig.highContrastPreset;
        expect(colourfulConfig, isNot(equals(highContrastConfig)));
        expect(colourfulConfig.hashCode, isNot(equals(highContrastConfig.hashCode)));
      });
    });

    group('copyWith', () {
      const baseConfig = TieSheetThemeConfig.colourfulPreset;

      test('returns identical config when no arguments are provided', () {
        final copied = baseConfig.copyWith();
        expect(copied, equals(baseConfig));
        expect(copied.hashCode, baseConfig.hashCode);
      });

      test('overrides only the specified colour field', () {
        const overrideColor = Color(0xFFFF0000);
        final copied = baseConfig.copyWith(primaryTextColor: overrideColor);
        expect(copied.primaryTextColor, overrideColor);
        // All other fields remain unchanged.
        expect(copied.mutedColor, baseConfig.mutedColor);
        expect(copied.fontFamily, baseConfig.fontFamily);
      });

      test('overrides only the specified double field', () {
        final copied = baseConfig.copyWith(badgeMinHalfSize: 20.0);
        expect(copied.badgeMinHalfSize, 20.0);
        expect(copied.primaryTextColor, baseConfig.primaryTextColor);
      });

      test('overrides only the specified boolean field', () {
        final copied = baseConfig.copyWith(isTextForceBold: true);
        expect(copied.isTextForceBold, isTrue);
        expect(copied.fontSizeDelta, baseConfig.fontSizeDelta);
      });

      test('overrides only the specified string field', () {
        final copied = baseConfig.copyWith(fontFamily: 'Inter');
        expect(copied.fontFamily, 'Inter');
        expect(copied.headerLetterSpacing, baseConfig.headerLetterSpacing);
      });

      test('multiple fields can be overridden simultaneously', () {
        const newColor = Color(0xFF00FF00);
        final copied = baseConfig.copyWith(
          canvasBackgroundColor: newColor,
          isInteractivityDisabled: true,
          fontFamily: 'Montserrat',
        );
        expect(copied.canvasBackgroundColor, newColor);
        expect(copied.isInteractivityDisabled, isTrue);
        expect(copied.fontFamily, 'Montserrat');
        // Untouched fields.
        expect(copied.mutedColor, baseConfig.mutedColor);
      });

      test('chained copyWith calls accumulate overrides', () {
        final step1 = baseConfig.copyWith(borderStrokeWidth: 5.0);
        final step2 = step1.copyWith(subtleStrokeWidth: 2.0);
        expect(step2.borderStrokeWidth, 5.0);
        expect(step2.subtleStrokeWidth, 2.0);
        expect(step2.mutedColor, baseConfig.mutedColor);
      });

      test('every field in copyWith is correctly wired', () {
        // Use a unique sentinel value for every field so we can verify
        // that each copyWith parameter maps to its correct property.
        const c1 = Color(0xFF010101);
        const c2 = Color(0xFF020202);
        const c5 = Color(0xFF050505);
        const c6 = Color(0xFF060606);
        const c7 = Color(0xFF070707);
        const c8 = Color(0xFF080808);
        const c9 = Color(0xFF090909);
        const c10 = Color(0xFF0A0A0A);
        const c11 = Color(0xFF0B0B0B);
        const c12 = Color(0xFF0C0C0C);
        const c13 = Color(0xFF0D0D0D);
        const c14 = Color(0xFF0E0E0E);
        const c15 = Color(0xFF0F0F0F);
        const c16 = Color(0xFF101010);
        const c17 = Color(0xFF111111);
        const c18 = Color(0xFF121212);
        const c19 = Color(0xFF131313);
        const c20 = Color(0xFF141414);
        const c21 = Color(0xFF151515);
        const c22 = Color(0xFF161616);
        const c23 = Color(0xFF171717);
        const c24 = Color(0xFF181818);
        const c25 = Color(0xFF191919);
        const c26 = Color(0xFF1A1A1A);
        const c27 = Color(0xFF1B1B1B);
        const c28 = Color(0xFF1C1C1C);
        const c29 = Color(0xFF1D1D1D);

        final overridden = baseConfig.copyWith(
          mutedColor: c1,
          connectorWonColor: c2,
          canvasBackgroundColor: c5,
          borderColor: c6,
          connectorStrokeWidth: 7.7,
          isInteractivityDisabled: true,
          primaryTextColor: c7,
          secondaryTextColor: c8,
          isTextForceBold: true,
          fontSizeDelta: 12.0,
          rowFillColor: c9,
          headerFillColor: c10,
          tbdFillColor: c11,
          headerBannerBackgroundColor: c12,
          headerBannerTextColor: c13,
          participantAccentStripColor: c14,
          blueCornerColor: c15,
          redCornerColor: c16,
          winnersLabelColor: c17,
          losersLabelColor: c18,
          medalGoldFillColor: c19,
          medalSilverFillColor: c20,
          medalBronzeFillColor: c21,
          medalGoldTextColor: c22,
          medalSilverTextColor: c23,
          medalBronzeTextColor: c24,
          medalGoldAccentColor: c25,
          medalSilverAccentColor: c26,
          medalBronzeAccentColor: c27,
          borderStrokeWidth: 95.0,
          subtleStrokeWidth: 94.0,
          wonConnectorStrokeWidth: 93.0,
          canvasMargin: 91.0,
          sectionGapHeight: 90.0,
          accentStripWidth: 89.0,
          badgeMinHalfSize: 87.0,
          badgePadding: 86.0,
          matchPillMinHalfWidth: 85.0,
          matchPillHorizontalPadding: 84.0,
          matchPillMinHalfHeight: 83.0,
          matchPillVerticalPadding: 82.0,
          dashedLineDashWidth: 81.0,
          dashedLineGapWidth: 80.0,
          fontFamily: 'TestFont',
          headerLetterSpacing: 77.0,
          subHeaderLetterSpacing: 76.0,
          // Layout tokens
          rowHeight: 75.0,
          intraMatchGapHeight: 74.0,
          interMatchGapHeight: 73.0,
          numberColumnWidth: 72.0,
          nameColumnWidth: 71.0,
          registrationIdColumnWidth: 70.0,
          roundColumnWidth: 69.0,
          headerTotalHeight: 68.0,
          subHeaderRowHeight: 67.0,
          centerGapWidth: 66.0,
          sectionLabelHeight: 65.0,
          medalTableWidth: 64.0,
          medalRowHeight: 63.0,
          medalNameColumnWidth: 62.0,
          medalLabelColumnWidth: 61.0,
          medalRowGap: 60.0,
          // Junction geometry
          centerFinalMinimumSpan: 59.5,
          grandFinalOutputArmLength: 59.0,
          // Banner & logo
          headerBannerHeight: 58.5,
          logoMaxHeight: 58.0,
          logoPadding: 57.0,
          matchPillFillColor: c28,
          badgeTextColor: c29,
          sectionLabelBackgroundOpacity: 0.56,
          headerSecondaryTextOpacity: 0.55,
          badgeOutlineOpacity: 0.54,
          canvasMinimumWidth: 53.0,
          canvasMinimumHeight: 52.0,
          badgeHorizontalOffset: 51.0,
          badgeBlueVerticalOffset: 50.0,
          badgeRedVerticalOffset: 49.0,
          missingInputVerticalOffset: 48.0,
          thirdPlaceToMedalGap: 47.0,
          matchPillHorizontalOffset: 46.0,
        );

        // Verify every colour field
        expect(overridden.mutedColor, c1);
        expect(overridden.connectorWonColor, c2);
        expect(overridden.canvasBackgroundColor, c5);
        expect(overridden.borderColor, c6);
        expect(overridden.primaryTextColor, c7);
        expect(overridden.secondaryTextColor, c8);
        expect(overridden.rowFillColor, c9);
        expect(overridden.headerFillColor, c10);
        expect(overridden.tbdFillColor, c11);
        expect(overridden.headerBannerBackgroundColor, c12);
        expect(overridden.headerBannerTextColor, c13);
        expect(overridden.participantAccentStripColor, c14);
        expect(overridden.blueCornerColor, c15);
        expect(overridden.redCornerColor, c16);
        expect(overridden.winnersLabelColor, c17);
        expect(overridden.losersLabelColor, c18);
        expect(overridden.medalGoldFillColor, c19);
        expect(overridden.medalSilverFillColor, c20);
        expect(overridden.medalBronzeFillColor, c21);
        expect(overridden.medalGoldTextColor, c22);
        expect(overridden.medalSilverTextColor, c23);
        expect(overridden.medalBronzeTextColor, c24);
        expect(overridden.medalGoldAccentColor, c25);
        expect(overridden.medalSilverAccentColor, c26);
        expect(overridden.medalBronzeAccentColor, c27);
        expect(overridden.matchPillFillColor, c28);
        expect(overridden.badgeTextColor, c29);

        // Verify every scalar field
        expect(overridden.connectorStrokeWidth, 7.7);
        expect(overridden.isInteractivityDisabled, isTrue);
        expect(overridden.isTextForceBold, isTrue);
        expect(overridden.fontSizeDelta, 12.0);
        expect(overridden.borderStrokeWidth, 95.0);
        expect(overridden.subtleStrokeWidth, 94.0);
        expect(overridden.wonConnectorStrokeWidth, 93.0);
        expect(overridden.canvasMargin, 91.0);
        expect(overridden.sectionGapHeight, 90.0);
        expect(overridden.accentStripWidth, 89.0);
        expect(overridden.badgeMinHalfSize, 87.0);
        expect(overridden.badgePadding, 86.0);
        expect(overridden.matchPillMinHalfWidth, 85.0);
        expect(overridden.matchPillHorizontalPadding, 84.0);
        expect(overridden.matchPillMinHalfHeight, 83.0);
        expect(overridden.matchPillVerticalPadding, 82.0);
        expect(overridden.dashedLineDashWidth, 81.0);
        expect(overridden.dashedLineGapWidth, 80.0);
        expect(overridden.fontFamily, 'TestFont');
        expect(overridden.headerLetterSpacing, 77.0);
        expect(overridden.subHeaderLetterSpacing, 76.0);
        // Layout tokens
        expect(overridden.rowHeight, 75.0);
        expect(overridden.intraMatchGapHeight, 74.0);
        expect(overridden.interMatchGapHeight, 73.0);
        expect(overridden.numberColumnWidth, 72.0);
        expect(overridden.nameColumnWidth, 71.0);
        expect(overridden.registrationIdColumnWidth, 70.0);
        expect(overridden.roundColumnWidth, 69.0);
        expect(overridden.headerTotalHeight, 68.0);
        expect(overridden.subHeaderRowHeight, 67.0);
        expect(overridden.centerGapWidth, 66.0);
        expect(overridden.sectionLabelHeight, 65.0);
        expect(overridden.medalTableWidth, 64.0);
        expect(overridden.medalRowHeight, 63.0);
        expect(overridden.medalNameColumnWidth, 62.0);
        expect(overridden.medalLabelColumnWidth, 61.0);
        expect(overridden.medalRowGap, 60.0);
        // Junction geometry
        expect(overridden.centerFinalMinimumSpan, 59.5);
        expect(overridden.grandFinalOutputArmLength, 59.0);
        // Banner & logo
        expect(overridden.headerBannerHeight, 58.5);
        expect(overridden.logoMaxHeight, 58.0);
        expect(overridden.logoPadding, 57.0);
        expect(overridden.sectionLabelBackgroundOpacity, 0.56);
        expect(overridden.headerSecondaryTextOpacity, 0.55);
        expect(overridden.badgeOutlineOpacity, 0.54);
        expect(overridden.canvasMinimumWidth, 53.0);
        expect(overridden.canvasMinimumHeight, 52.0);
        expect(overridden.badgeHorizontalOffset, 51.0);
        expect(overridden.badgeBlueVerticalOffset, 50.0);
        expect(overridden.badgeRedVerticalOffset, 49.0);
        expect(overridden.missingInputVerticalOffset, 48.0);
        expect(overridden.thirdPlaceToMedalGap, 47.0);
        expect(overridden.matchPillHorizontalOffset, 46.0);
      });
    });
  });
}
