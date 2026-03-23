import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:tkd_saas/features/bracket/presentation/widgets/tie_sheet_theme_config.dart';

void main() {
  group('TieSheetThemeMode', () {
    test('has correct labels', () {
      expect(TieSheetThemeMode.defaultMode.label, 'Screen');
      expect(TieSheetThemeMode.printMode.label, 'Print');
    });

    test('values list has exactly two entries', () {
      expect(TieSheetThemeMode.values, hasLength(2));
    });
  });

  group('TieSheetThemeConfig', () {
    group('defaultMode preset', () {
      const config = TieSheetThemeConfig.defaultMode();

      // ── Connector / junction tokens ──
      test('connectorColor matches original slate', () {
        expect(config.connectorColor, const Color(0xFF64748B));
      });
      test('connectorWonColor matches original dark-slate', () {
        expect(config.connectorWonColor, const Color(0xFF334155));
      });
      test('pendingColor matches original light-slate', () {
        expect(config.pendingColor, const Color(0xFF94A3B8));
      });
      test('mutedColor matches original slate', () {
        expect(config.mutedColor, const Color(0xFF64748B));
      });

      // ── Canvas & card tokens ──
      test('canvasBackgroundColor is warm white', () {
        expect(config.canvasBackgroundColor, const Color(0xFFFFFEFC));
      });
      test('cardBorderColor matches original light-slate', () {
        expect(config.cardBorderColor, const Color(0xFF94A3B8));
      });
      test('shadowOpacityMultiplier is full', () {
        expect(config.shadowOpacityMultiplier, 1.0);
      });
      test('connectorStrokeWidth is zero (varied widths)', () {
        expect(config.connectorStrokeWidth, 0.0);
      });
      test('isInteractivityDisabled is false', () {
        expect(config.isInteractivityDisabled, isFalse);
      });
      test('fontSizeDelta adds 4px in default mode', () {
        expect(config.fontSizeDelta, 4.0);
      });

      // ── Text tokens ──
      test('primaryTextColor is ink', () {
        expect(config.primaryTextColor, const Color(0xFF1E293B));
      });
      test('secondaryTextColor is subtle', () {
        expect(config.secondaryTextColor, const Color(0xFF64748B));
      });
      test('isTextForceBold is false', () {
        expect(config.isTextForceBold, isFalse);
      });

      // ── Fill tokens ──
      test('rowFillColor matches original', () {
        expect(config.rowFillColor, const Color(0xFFF8FAFC));
      });
      test('headerFillColor matches original', () {
        expect(config.headerFillColor, const Color(0xFFE2E8F0));
      });
      test('tbdFillColor matches original', () {
        expect(config.tbdFillColor, const Color(0xFFF1F5F9));
      });

      // ── Header banner ──
      test('headerBannerBackgroundColor is dark', () {
        expect(config.headerBannerBackgroundColor, const Color(0xFF1E293B));
      });
      test('headerBannerTextColor is white', () {
        expect(config.headerBannerTextColor, const Color(0xFFFFFFFF));
      });

      // ── Accent & badges ──
      test('participantAccentStripColor is blue', () {
        expect(config.participantAccentStripColor, const Color(0xFF2563EB));
      });
      test('blueCornerColor is blue', () {
        expect(config.blueCornerColor, const Color(0xFF2563EB));
      });
      test('redCornerColor is red', () {
        expect(config.redCornerColor, const Color(0xFFDC2626));
      });

      // ── Section labels ──
      test('winnersLabelColor is blue', () {
        expect(config.winnersLabelColor, const Color(0xFF2563EB));
      });
      test('losersLabelColor is red', () {
        expect(config.losersLabelColor, const Color(0xFFDC2626));
      });

      // ── Medal tokens ──
      test('medalGoldFillColor matches original', () {
        expect(config.medalGoldFillColor, const Color(0xFFFEF9C3));
      });
      test('medalSilverFillColor matches original', () {
        expect(config.medalSilverFillColor, const Color(0xFFF1F5F9));
      });
      test('medalBronzeFillColor matches original', () {
        expect(config.medalBronzeFillColor, const Color(0xFFFED7AA));
      });
      test('medalGoldTextColor matches original', () {
        expect(config.medalGoldTextColor, const Color(0xFF92400E));
      });
      test('medalSilverTextColor matches original', () {
        expect(config.medalSilverTextColor, const Color(0xFF475569));
      });
      test('medalBronzeTextColor matches original', () {
        expect(config.medalBronzeTextColor, const Color(0xFF9A3412));
      });
      test('medalGoldAccentColor matches original', () {
        expect(config.medalGoldAccentColor, const Color(0xFFF59E0B));
      });
      test('medalSilverAccentColor matches original', () {
        expect(config.medalSilverAccentColor, const Color(0xFF94A3B8));
      });
      test('medalBronzeAccentColor matches original', () {
        expect(config.medalBronzeAccentColor, const Color(0xFFF97316));
      });

      // ── Shape / radius tokens ──
      test('cardBorderRadius is 6', () {
        expect(config.cardBorderRadius, 6.0);
      });
      test('sectionLabelBorderRadius is 6', () {
        expect(config.sectionLabelBorderRadius, 6.0);
      });
      test('headerBannerBorderRadius is 8', () {
        expect(config.headerBannerBorderRadius, 8.0);
      });
      test('junctionCornerRadius is 10', () {
        expect(config.junctionCornerRadius, 10.0);
      });

      // ── Stroke width tokens ──
      test('thickStrokeWidth is 3.5', () {
        expect(config.thickStrokeWidth, 3.5);
      });
      test('thinStrokeWidth is 3.0', () {
        expect(config.thinStrokeWidth, 3.0);
      });
      test('wonConnectorStrokeWidth is 4.0', () {
        expect(config.wonConnectorStrokeWidth, 4.0);
      });
      test('byeConnectorStrokeWidth is 1.5', () {
        expect(config.byeConnectorStrokeWidth, 1.5);
      });

      // ── Spacing tokens ──
      test('canvasMargin is 36', () {
        expect(config.canvasMargin, 36.0);
      });
      test('sectionGapHeight is 50', () {
        expect(config.sectionGapHeight, 50.0);
      });
      test('accentStripWidth is 4', () {
        expect(config.accentStripWidth, 4.0);
      });
      test('logoRowHeight is 72', () {
        expect(config.logoRowHeight, 72.0);
      });

      // ── Badge & pill sizing tokens ──
      test('badgeMinRadius is 10', () {
        expect(config.badgeMinRadius, 10.0);
      });
      test('badgePadding is 4', () {
        expect(config.badgePadding, 4.0);
      });
      test('matchPillMinHalfWidth is 16', () {
        expect(config.matchPillMinHalfWidth, 16.0);
      });
      test('matchPillHorizontalPadding is 8', () {
        expect(config.matchPillHorizontalPadding, 8.0);
      });
      test('matchPillMinHalfHeight is 11', () {
        expect(config.matchPillMinHalfHeight, 11.0);
      });
      test('matchPillVerticalPadding is 4', () {
        expect(config.matchPillVerticalPadding, 4.0);
      });

      // ── Dashed line tokens ──
      test('dashedLineDashWidth is 6', () {
        expect(config.dashedLineDashWidth, 6.0);
      });
      test('dashedLineGapWidth is 4', () {
        expect(config.dashedLineGapWidth, 4.0);
      });

      // ── Shadow tokens ──
      test('shadowBlurRadius is 6', () {
        expect(config.shadowBlurRadius, 6.0);
      });
      test('shadowColor is translucent black', () {
        expect(config.shadowColor, const Color(0x1A000000));
      });

      // ── Typography tokens ──
      test('fontFamily is Roboto', () {
        expect(config.fontFamily, 'Roboto');
      });
      test('headerLetterSpacing is 1.2', () {
        expect(config.headerLetterSpacing, 1.2);
      });
      test('subHeaderLetterSpacing is 0.5', () {
        expect(config.subHeaderLetterSpacing, 0.5);
      });
    });

    group('printMode preset', () {
      const config = TieSheetThemeConfig.printMode();

      // ── All connectors are black ──
      test('connectorColor is black', () {
        expect(config.connectorColor, const Color(0xFF000000));
      });
      test('connectorWonColor is black', () {
        expect(config.connectorWonColor, const Color(0xFF000000));
      });
      test('pendingColor is black', () {
        expect(config.pendingColor, const Color(0xFF000000));
      });
      test('mutedColor is black', () {
        expect(config.mutedColor, const Color(0xFF000000));
      });

      // ── Canvas & card ──
      test('canvasBackgroundColor is pure white', () {
        expect(config.canvasBackgroundColor, const Color(0xFFFFFFFF));
      });
      test('cardBorderColor is black', () {
        expect(config.cardBorderColor, const Color(0xFF000000));
      });
      test('shadowOpacityMultiplier is zero (no shadows)', () {
        expect(config.shadowOpacityMultiplier, 0.0);
      });
      test('connectorStrokeWidth is uniform 3.0', () {
        expect(config.connectorStrokeWidth, 3.0);
      });
      test('isInteractivityDisabled is true', () {
        expect(config.isInteractivityDisabled, isTrue);
      });
      test('fontSizeDelta adds 8px in print mode', () {
        expect(config.fontSizeDelta, 8.0);
      });

      // ── Text — all black + bold ──
      test('primaryTextColor is black', () {
        expect(config.primaryTextColor, const Color(0xFF000000));
      });
      test('secondaryTextColor is black', () {
        expect(config.secondaryTextColor, const Color(0xFF000000));
      });
      test('isTextForceBold is true', () {
        expect(config.isTextForceBold, isTrue);
      });

      // ── Fills — all white (no background) ──
      test('rowFillColor is white', () {
        expect(config.rowFillColor, const Color(0xFFFFFFFF));
      });
      test('headerFillColor is white', () {
        expect(config.headerFillColor, const Color(0xFFFFFFFF));
      });
      test('tbdFillColor is white', () {
        expect(config.tbdFillColor, const Color(0xFFFFFFFF));
      });

      // ── Header banner — inverted for print ──
      test('headerBannerBackgroundColor is white', () {
        expect(config.headerBannerBackgroundColor, const Color(0xFFFFFFFF));
      });
      test('headerBannerTextColor is black', () {
        expect(config.headerBannerTextColor, const Color(0xFF000000));
      });

      // ── Accents & badges — all black ──
      test('participantAccentStripColor is black', () {
        expect(config.participantAccentStripColor, const Color(0xFF000000));
      });
      test('blueCornerColor is black', () {
        expect(config.blueCornerColor, const Color(0xFF000000));
      });
      test('redCornerColor is black', () {
        expect(config.redCornerColor, const Color(0xFF000000));
      });

      // ── Section labels — all black ──
      test('winnersLabelColor is black', () {
        expect(config.winnersLabelColor, const Color(0xFF000000));
      });
      test('losersLabelColor is black', () {
        expect(config.losersLabelColor, const Color(0xFF000000));
      });

      // ── Medal tokens — all white fills, all black text/accents ──
      test('all medal fills are white', () {
        expect(config.medalGoldFillColor, const Color(0xFFFFFFFF));
        expect(config.medalSilverFillColor, const Color(0xFFFFFFFF));
        expect(config.medalBronzeFillColor, const Color(0xFFFFFFFF));
      });
      test('all medal text colors are black', () {
        expect(config.medalGoldTextColor, const Color(0xFF000000));
        expect(config.medalSilverTextColor, const Color(0xFF000000));
        expect(config.medalBronzeTextColor, const Color(0xFF000000));
      });
      test('all medal accent colors are black', () {
        expect(config.medalGoldAccentColor, const Color(0xFF000000));
        expect(config.medalSilverAccentColor, const Color(0xFF000000));
        expect(config.medalBronzeAccentColor, const Color(0xFF000000));
      });

      // ── Shape / radius tokens (same geometry as default) ──
      test('cardBorderRadius is 6', () {
        expect(config.cardBorderRadius, 6.0);
      });
      test('headerBannerBorderRadius is 8', () {
        expect(config.headerBannerBorderRadius, 8.0);
      });
      test('junctionCornerRadius is 10', () {
        expect(config.junctionCornerRadius, 10.0);
      });

      // ── Spacing tokens (same as default) ──
      test('canvasMargin is 36', () {
        expect(config.canvasMargin, 36.0);
      });
      test('logoRowHeight is 72', () {
        expect(config.logoRowHeight, 72.0);
      });

      // ── Typography tokens (same as default) ──
      test('fontFamily is Roboto', () {
        expect(config.fontFamily, 'Roboto');
      });
      test('headerLetterSpacing is 1.2', () {
        expect(config.headerLetterSpacing, 1.2);
      });

      // ── Luminance checks: print mode darker than default ──
      test('connectorColor luminance lower than default', () {
        const defaultConnector = Color(0xFF64748B);
        expect(
          config.connectorColor.computeLuminance(),
          lessThan(defaultConnector.computeLuminance()),
        );
      });
    });

    group('fromMode factory', () {
      test('defaultMode returns defaultMode preset', () {
        final config = TieSheetThemeConfig.fromMode(
          TieSheetThemeMode.defaultMode,
        );
        expect(config, const TieSheetThemeConfig.defaultMode());
      });

      test('printMode returns printMode preset', () {
        final config = TieSheetThemeConfig.fromMode(
          TieSheetThemeMode.printMode,
        );
        expect(config, const TieSheetThemeConfig.printMode());
      });
    });

    group('equality', () {
      test('identical presets are equal', () {
        const configA = TieSheetThemeConfig.defaultMode();
        const configB = TieSheetThemeConfig.defaultMode();
        expect(configA, equals(configB));
        expect(configA.hashCode, configB.hashCode);
      });

      test('different presets are not equal', () {
        const defaultConfig = TieSheetThemeConfig.defaultMode();
        const printConfig = TieSheetThemeConfig.printMode();
        expect(defaultConfig, isNot(equals(printConfig)));
        expect(defaultConfig.hashCode, isNot(equals(printConfig.hashCode)));
      });

      test('custom config with same values as preset is equal', () {
        const preset = TieSheetThemeConfig.defaultMode();
        const custom = TieSheetThemeConfig(
          connectorColor: Color(0xFF64748B),
          connectorWonColor: Color(0xFF334155),
          pendingColor: Color(0xFF94A3B8),
          mutedColor: Color(0xFF64748B),
          canvasBackgroundColor: Color(0xFFFFFEFC),
          cardBorderColor: Color(0xFF94A3B8),
          shadowOpacityMultiplier: 1.0,
          connectorStrokeWidth: 0.0,
          isInteractivityDisabled: false,
          primaryTextColor: Color(0xFF1E293B),
          secondaryTextColor: Color(0xFF64748B),
          isTextForceBold: false,
          fontSizeDelta: 4.0,
          rowFillColor: Color(0xFFF8FAFC),
          headerFillColor: Color(0xFFE2E8F0),
          tbdFillColor: Color(0xFFF1F5F9),
          headerBannerBackgroundColor: Color(0xFF1E293B),
          headerBannerTextColor: Color(0xFFFFFFFF),
          participantAccentStripColor: Color(0xFF2563EB),
          blueCornerColor: Color(0xFF2563EB),
          redCornerColor: Color(0xFFDC2626),
          winnersLabelColor: Color(0xFF2563EB),
          losersLabelColor: Color(0xFFDC2626),
          medalGoldFillColor: Color(0xFFFEF9C3),
          medalSilverFillColor: Color(0xFFF1F5F9),
          medalBronzeFillColor: Color(0xFFFED7AA),
          medalGoldTextColor: Color(0xFF92400E),
          medalSilverTextColor: Color(0xFF475569),
          medalBronzeTextColor: Color(0xFF9A3412),
          medalGoldAccentColor: Color(0xFFF59E0B),
          medalSilverAccentColor: Color(0xFF94A3B8),
          medalBronzeAccentColor: Color(0xFFF97316),
          // Shape / radius
          cardBorderRadius: 6.0,
          sectionLabelBorderRadius: 6.0,
          headerBannerBorderRadius: 8.0,
          junctionCornerRadius: 10.0,
          // Stroke widths
          thickStrokeWidth: 3.5,
          thinStrokeWidth: 3.0,
          wonConnectorStrokeWidth: 4.0,
          byeConnectorStrokeWidth: 1.5,
          // Spacing
          canvasMargin: 36.0,
          sectionGapHeight: 50.0,
          accentStripWidth: 4.0,
          logoRowHeight: 72.0,
          // Badge & pill
          badgeMinRadius: 10.0,
          badgePadding: 4.0,
          matchPillMinHalfWidth: 16.0,
          matchPillHorizontalPadding: 8.0,
          matchPillMinHalfHeight: 11.0,
          matchPillVerticalPadding: 4.0,
          // Dashed line
          dashedLineDashWidth: 6.0,
          dashedLineGapWidth: 4.0,
          // Shadow
          shadowBlurRadius: 6.0,
          shadowColor: Color(0x1A000000),
          // Typography
          fontFamily: 'Roboto',
          headerLetterSpacing: 1.2,
          subHeaderLetterSpacing: 0.5,
        );
        expect(custom, equals(preset));
      });
    });
  });
}
