import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import 'tie_sheet_theme_config.dart';

/// Converts a [Color] to an 8-character uppercase ARGB hex string.
///
/// Uses non-deprecated [Color] component accessors (a, r, g, b are 0.0–1.0
String _colorToHexString(Color color) {
  final a = (color.a * 255).round();
  final r = (color.r * 255).round();
  final g = (color.g * 255).round();
  final b = (color.b * 255).round();
  return '${a.toRadixString(16).padLeft(2, '0')}'
          '${r.toRadixString(16).padLeft(2, '0')}'
          '${g.toRadixString(16).padLeft(2, '0')}'
          '${b.toRadixString(16).padLeft(2, '0')}'
      .toUpperCase();
}

// ══════════════════════════════════════════════════════════════════════════════
// TIE SHEET THEME EDITOR PANEL
// ══════════════════════════════════════════════════════════════════════════════

/// A side panel for interactively editing every token in [TieSheetThemeConfig].
///
/// Receives the [currentThemeConfig] and fires [onThemeConfigChanged] on
/// every slider drag, colour pick, or toggle flip so the bracket canvas
/// re-renders in real time.
class TieSheetThemeEditorPanel extends StatelessWidget {
  const TieSheetThemeEditorPanel({
    super.key,
    required this.currentThemeConfig,
    required this.onThemeConfigChanged,
  });

  final TieSheetThemeConfig currentThemeConfig;
  final ValueChanged<TieSheetThemeConfig> onThemeConfigChanged;

  // ── Preset reset helpers ──────────────────────────────────────────────────

  void _confirmAndResetToPreset(
    BuildContext context, {
    required String presetName,
    required TieSheetThemeConfig presetConfig,
  }) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Reset to $presetName'),
        content: Text(
          'This will replace all your current customisations '
          'with the $presetName preset. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              onThemeConfigChanged(presetConfig);
              Navigator.of(dialogContext).pop();
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  // ── Colour picker dialog ──────────────────────────────────────────────────

  void _showColorPickerDialog(
    BuildContext context, {
    required String label,
    required Color currentColor,
    required ValueChanged<Color> onColorChanged,
  }) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(label),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: currentColor,
            onColorChanged: (color) {
              // Live preview: update on every hue change.
              onColorChanged(color);
            },
            enableAlpha: true,
            displayThumbColor: true,
            pickerAreaHeightPercent: 0.7,
            labelTypes: const [],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Revert to original if cancelled.
              onColorChanged(currentColor);
              Navigator.of(dialogContext).pop();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        border: Border(left: BorderSide(color: theme.dividerColor)),
      ),
      child: Column(
        children: [
          // ── Header + preset buttons ──
          _buildPanelHeader(context, theme),
          const Divider(height: 1),
          // ── Scrollable editor sections ──
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _buildCanvasAndCardsSection(context),
                _buildConnectorJunctionSection(context),
                _buildTextSection(context),
                _buildHeaderBannerSection(context),
                _buildAccentsAndBadgesSection(context),
                _buildSectionLabelsSection(context),
                _buildMedalsSection(context),
                _buildShapeRadiusSection(context),
                _buildStrokeWidthsSection(context),
                _buildSpacingSection(context),
                _buildBadgePillSizingSection(context),
                _buildShadowsSection(context),
                _buildTypographySection(context),
                _buildLayoutDimensionsSection(context),
                _buildBannerAndLogoSection(context),
                _buildAdditionalColorsAndOpacitySection(context),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Panel header ──────────────────────────────────────────────────────────

  Widget _buildPanelHeader(BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Theme Editor',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Tooltip(
                  message: 'Revert all tokens to the default screen preset',
                  child: OutlinedButton.icon(
                    onPressed: () => _confirmAndResetToPreset(
                      context,
                      presetName: 'Screen',
                      presetConfig: TieSheetThemeConfig.defaultPreset,
                    ),
                    icon: const Icon(Icons.visibility, size: 14),
                    label: const Text('Screen', style: TextStyle(fontSize: 12)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Tooltip(
                  message:
                      'Revert all tokens to the high-contrast print preset',
                  child: OutlinedButton.icon(
                    onPressed: () => _confirmAndResetToPreset(
                      context,
                      presetName: 'Print',
                      presetConfig: TieSheetThemeConfig.printPreset,
                    ),
                    icon: const Icon(Icons.print, size: 14),
                    label: const Text('Print', style: TextStyle(fontSize: 12)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Colour-picker tile factory (DRY helper) ──────────────────────────────

  /// Builds a [_ColorPickerTile] wired to the panel's colour-picker dialog.
  /// Eliminates the per-tile `onShowPicker` boilerplate.
  _ColorPickerTile _buildColorPickerTile(
    BuildContext context, {
    required String label,
    required Color currentColor,
    required ValueChanged<Color> onColorSelected,
  }) {
    return _ColorPickerTile(
      label: label,
      currentColor: currentColor,
      onColorSelected: onColorSelected,
      onShowPicker: (pickerLabel, pickerColor, onChanged) =>
          _showColorPickerDialog(
            context,
            label: pickerLabel,
            currentColor: pickerColor,
            onColorChanged: onChanged,
          ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // CATEGORY SECTIONS
  // ══════════════════════════════════════════════════════════════════════════

  // ── Canvas & Cards ──────────────────────────────────────────────────────

  Widget _buildCanvasAndCardsSection(BuildContext context) {
    return _ThemeEditorExpansionSection(
      title: 'Canvas & Cards',
      icon: Icons.dashboard_outlined,
      children: [
        _buildColorPickerTile(
          context,
          label: 'Canvas Background',
          currentColor: currentThemeConfig.canvasBackgroundColor,
          onColorSelected: (color) => onThemeConfigChanged(
            currentThemeConfig.copyWith(canvasBackgroundColor: color),
          ),
        ),
        _buildColorPickerTile(
          context,
          label: 'Card Border',
          currentColor: currentThemeConfig.borderColor,
          onColorSelected: (color) => onThemeConfigChanged(
            currentThemeConfig.copyWith(borderColor: color),
          ),
        ),
        _buildColorPickerTile(
          context,
          label: 'Row Fill',
          currentColor: currentThemeConfig.rowFillColor,
          onColorSelected: (color) => onThemeConfigChanged(
            currentThemeConfig.copyWith(rowFillColor: color),
          ),
        ),
        _buildColorPickerTile(
          context,
          label: 'Header Fill',
          currentColor: currentThemeConfig.headerFillColor,
          onColorSelected: (color) => onThemeConfigChanged(
            currentThemeConfig.copyWith(headerFillColor: color),
          ),
        ),
        _buildColorPickerTile(
          context,
          label: 'TBD Fill',
          currentColor: currentThemeConfig.tbdFillColor,
          onColorSelected: (color) => onThemeConfigChanged(
            currentThemeConfig.copyWith(tbdFillColor: color),
          ),
        ),
      ],
    );
  }

  // ── Connector / Junction ──────────────────────────────────────────────────

  Widget _buildConnectorJunctionSection(BuildContext context) {
    return _ThemeEditorExpansionSection(
      title: 'Connectors & Junctions',
      icon: Icons.linear_scale,
      children: [
        _buildColorPickerTile(
          context,
          label: 'Connector',
          currentColor: currentThemeConfig.mutedColor,
          onColorSelected: (color) => onThemeConfigChanged(
            currentThemeConfig.copyWith(mutedColor: color),
          ),
        ),
        _buildColorPickerTile(
          context,
          label: 'Connector Won',
          currentColor: currentThemeConfig.connectorWonColor,
          onColorSelected: (color) => onThemeConfigChanged(
            currentThemeConfig.copyWith(connectorWonColor: color),
          ),
        ),
        _buildColorPickerTile(
          context,
          label: 'Border',
          currentColor: currentThemeConfig.borderColor,
          onColorSelected: (color) => onThemeConfigChanged(
            currentThemeConfig.copyWith(borderColor: color),
          ),
        ),
        _buildColorPickerTile(
          context,
          label: 'Muted',
          currentColor: currentThemeConfig.mutedColor,
          onColorSelected: (color) => onThemeConfigChanged(
            currentThemeConfig.copyWith(mutedColor: color),
          ),
        ),
      ],
    );
  }

  // ── Text ──────────────────────────────────────────────────────────────────

  Widget _buildTextSection(BuildContext context) {
    return _ThemeEditorExpansionSection(
      title: 'Text',
      icon: Icons.text_fields,
      children: [
        _buildColorPickerTile(
          context,
          label: 'Primary Text',
          currentColor: currentThemeConfig.primaryTextColor,
          onColorSelected: (color) => onThemeConfigChanged(
            currentThemeConfig.copyWith(primaryTextColor: color),
          ),
        ),
        _buildColorPickerTile(
          context,
          label: 'Secondary Text',
          currentColor: currentThemeConfig.secondaryTextColor,
          onColorSelected: (color) => onThemeConfigChanged(
            currentThemeConfig.copyWith(secondaryTextColor: color),
          ),
        ),
        _ToggleSwitchTile(
          label: 'Force Bold Text',
          value: currentThemeConfig.isTextForceBold,
          onChanged: (value) => onThemeConfigChanged(
            currentThemeConfig.copyWith(isTextForceBold: value),
          ),
        ),
        _SliderTile(
          label: 'Font Size Delta',
          value: currentThemeConfig.fontSizeDelta,
          min: 0.0,
          max: 32.0,
          divisions: 64,
          onChanged: (value) => onThemeConfigChanged(
            currentThemeConfig.copyWith(fontSizeDelta: value),
          ),
        ),
      ],
    );
  }

  // ── Header Banner ─────────────────────────────────────────────────────────

  Widget _buildHeaderBannerSection(BuildContext context) {
    return _ThemeEditorExpansionSection(
      title: 'Header Banner',
      icon: Icons.view_headline,
      children: [
        _buildColorPickerTile(
          context,
          label: 'Banner Background',
          currentColor: currentThemeConfig.headerBannerBackgroundColor,
          onColorSelected: (color) => onThemeConfigChanged(
            currentThemeConfig.copyWith(headerBannerBackgroundColor: color),
          ),
        ),
        _buildColorPickerTile(
          context,
          label: 'Banner Text',
          currentColor: currentThemeConfig.headerBannerTextColor,
          onColorSelected: (color) => onThemeConfigChanged(
            currentThemeConfig.copyWith(headerBannerTextColor: color),
          ),
        ),
      ],
    );
  }

  // ── Accents & Badges ──────────────────────────────────────────────────────

  Widget _buildAccentsAndBadgesSection(BuildContext context) {
    return _ThemeEditorExpansionSection(
      title: 'Accents & Badges',
      icon: Icons.color_lens_outlined,
      children: [
        _buildColorPickerTile(
          context,
          label: 'Accent Strip',
          currentColor: currentThemeConfig.participantAccentStripColor,
          onColorSelected: (color) => onThemeConfigChanged(
            currentThemeConfig.copyWith(participantAccentStripColor: color),
          ),
        ),
        _buildColorPickerTile(
          context,
          label: 'Blue Corner',
          currentColor: currentThemeConfig.blueCornerColor,
          onColorSelected: (color) => onThemeConfigChanged(
            currentThemeConfig.copyWith(blueCornerColor: color),
          ),
        ),
        _buildColorPickerTile(
          context,
          label: 'Red Corner',
          currentColor: currentThemeConfig.redCornerColor,
          onColorSelected: (color) => onThemeConfigChanged(
            currentThemeConfig.copyWith(redCornerColor: color),
          ),
        ),
      ],
    );
  }

  // ── Section Labels ────────────────────────────────────────────────────────

  Widget _buildSectionLabelsSection(BuildContext context) {
    return _ThemeEditorExpansionSection(
      title: 'Section Labels',
      icon: Icons.label_outline,
      children: [
        _buildColorPickerTile(
          context,
          label: 'Winners Label',
          currentColor: currentThemeConfig.winnersLabelColor,
          onColorSelected: (color) => onThemeConfigChanged(
            currentThemeConfig.copyWith(winnersLabelColor: color),
          ),
        ),
        _buildColorPickerTile(
          context,
          label: 'Losers Label',
          currentColor: currentThemeConfig.losersLabelColor,
          onColorSelected: (color) => onThemeConfigChanged(
            currentThemeConfig.copyWith(losersLabelColor: color),
          ),
        ),
      ],
    );
  }

  // ── Medals ────────────────────────────────────────────────────────────────

  Widget _buildMedalsSection(BuildContext context) {
    return _ThemeEditorExpansionSection(
      title: 'Medals',
      icon: Icons.emoji_events_outlined,
      children: [
        // Gold
        _SectionSubHeader(label: 'Gold'),
        _buildColorPickerTile(
          context,
          label: 'Gold Fill',
          currentColor: currentThemeConfig.medalGoldFillColor,
          onColorSelected: (color) => onThemeConfigChanged(
            currentThemeConfig.copyWith(medalGoldFillColor: color),
          ),
        ),
        _buildColorPickerTile(
          context,
          label: 'Gold Text',
          currentColor: currentThemeConfig.medalGoldTextColor,
          onColorSelected: (color) => onThemeConfigChanged(
            currentThemeConfig.copyWith(medalGoldTextColor: color),
          ),
        ),
        _buildColorPickerTile(
          context,
          label: 'Gold Accent',
          currentColor: currentThemeConfig.medalGoldAccentColor,
          onColorSelected: (color) => onThemeConfigChanged(
            currentThemeConfig.copyWith(medalGoldAccentColor: color),
          ),
        ),
        // Silver
        _SectionSubHeader(label: 'Silver'),
        _buildColorPickerTile(
          context,
          label: 'Silver Fill',
          currentColor: currentThemeConfig.medalSilverFillColor,
          onColorSelected: (color) => onThemeConfigChanged(
            currentThemeConfig.copyWith(medalSilverFillColor: color),
          ),
        ),
        _buildColorPickerTile(
          context,
          label: 'Silver Text',
          currentColor: currentThemeConfig.medalSilverTextColor,
          onColorSelected: (color) => onThemeConfigChanged(
            currentThemeConfig.copyWith(medalSilverTextColor: color),
          ),
        ),
        _buildColorPickerTile(
          context,
          label: 'Silver Accent',
          currentColor: currentThemeConfig.medalSilverAccentColor,
          onColorSelected: (color) => onThemeConfigChanged(
            currentThemeConfig.copyWith(medalSilverAccentColor: color),
          ),
        ),
        // Bronze
        _SectionSubHeader(label: 'Bronze'),
        _buildColorPickerTile(
          context,
          label: 'Bronze Fill',
          currentColor: currentThemeConfig.medalBronzeFillColor,
          onColorSelected: (color) => onThemeConfigChanged(
            currentThemeConfig.copyWith(medalBronzeFillColor: color),
          ),
        ),
        _buildColorPickerTile(
          context,
          label: 'Bronze Text',
          currentColor: currentThemeConfig.medalBronzeTextColor,
          onColorSelected: (color) => onThemeConfigChanged(
            currentThemeConfig.copyWith(medalBronzeTextColor: color),
          ),
        ),
        _buildColorPickerTile(
          context,
          label: 'Bronze Accent',
          currentColor: currentThemeConfig.medalBronzeAccentColor,
          onColorSelected: (color) => onThemeConfigChanged(
            currentThemeConfig.copyWith(medalBronzeAccentColor: color),
          ),
        ),
      ],
    );
  }

  // ── Shape / Radius ────────────────────────────────────────────────────────

  Widget _buildShapeRadiusSection(BuildContext context) {
    return _ThemeEditorExpansionSection(
      title: 'Shape & Radius',
      icon: Icons.rounded_corner,
      children: [
        _SliderTile(
          label: 'Element Border Radius',
          value: currentThemeConfig.elementBorderRadius,
          min: 0,
          max: 48,
          divisions: 96,
          onChanged: (value) => onThemeConfigChanged(
            currentThemeConfig.copyWith(elementBorderRadius: value),
          ),
        ),
        _SliderTile(
          label: 'Junction Corner Radius',
          value: currentThemeConfig.junctionCornerRadius,
          min: 0,
          max: 60,
          divisions: 120,
          onChanged: (value) => onThemeConfigChanged(
            currentThemeConfig.copyWith(junctionCornerRadius: value),
          ),
        ),
      ],
    );
  }

  // ── Stroke Widths ─────────────────────────────────────────────────────────

  Widget _buildStrokeWidthsSection(BuildContext context) {
    return _ThemeEditorExpansionSection(
      title: 'Stroke Widths',
      icon: Icons.line_weight,
      children: [
        _SliderTile(
          label: 'Border Stroke',
          value: currentThemeConfig.borderStrokeWidth,
          min: 0.5,
          max: 16,
          divisions: 31,
          onChanged: (value) => onThemeConfigChanged(
            currentThemeConfig.copyWith(borderStrokeWidth: value),
          ),
        ),
        _SliderTile(
          label: 'Subtle Stroke',
          value: currentThemeConfig.subtleStrokeWidth,
          min: 0.5,
          max: 16,
          divisions: 31,
          onChanged: (value) => onThemeConfigChanged(
            currentThemeConfig.copyWith(subtleStrokeWidth: value),
          ),
        ),
        _SliderTile(
          label: 'Won Connector Stroke',
          value: currentThemeConfig.wonConnectorStrokeWidth,
          min: 0.5,
          max: 16,
          divisions: 31,
          onChanged: (value) => onThemeConfigChanged(
            currentThemeConfig.copyWith(wonConnectorStrokeWidth: value),
          ),
        ),
        _SliderTile(
          label: 'Uniform Connector Override',
          value: currentThemeConfig.connectorStrokeWidth,
          min: 0,
          max: 16,
          divisions: 32,
          onChanged: (value) => onThemeConfigChanged(
            currentThemeConfig.copyWith(connectorStrokeWidth: value),
          ),
        ),
        const _SectionSubHeader(label: 'Dashed Lines'),
        _SliderTile(
          label: 'Dash Width',
          value: currentThemeConfig.dashedLineDashWidth,
          min: 1,
          max: 40,
          divisions: 78,
          onChanged: (value) => onThemeConfigChanged(
            currentThemeConfig.copyWith(dashedLineDashWidth: value),
          ),
        ),
        _SliderTile(
          label: 'Gap Width',
          value: currentThemeConfig.dashedLineGapWidth,
          min: 1,
          max: 40,
          divisions: 78,
          onChanged: (value) => onThemeConfigChanged(
            currentThemeConfig.copyWith(dashedLineGapWidth: value),
          ),
        ),
      ],
    );
  }

  // ── Spacing ───────────────────────────────────────────────────────────────

  Widget _buildSpacingSection(BuildContext context) {
    return _ThemeEditorExpansionSection(
      title: 'Spacing',
      icon: Icons.space_bar,
      children: [
        _SliderTile(
          label: 'Canvas Margin',
          value: currentThemeConfig.canvasMargin,
          min: 0,
          max: 200,
          divisions: 100,
          onChanged: (value) => onThemeConfigChanged(
            currentThemeConfig.copyWith(canvasMargin: value),
          ),
        ),
        _SliderTile(
          label: 'Section Gap Height',
          value: currentThemeConfig.sectionGapHeight,
          min: 0,
          max: 250,
          divisions: 125,
          onChanged: (value) => onThemeConfigChanged(
            currentThemeConfig.copyWith(sectionGapHeight: value),
          ),
        ),
        _SliderTile(
          label: 'Accent Strip Width',
          value: currentThemeConfig.accentStripWidth,
          min: 0,
          max: 32,
          divisions: 64,
          onChanged: (value) => onThemeConfigChanged(
            currentThemeConfig.copyWith(accentStripWidth: value),
          ),
        ),
        _SliderTile(
          label: 'Logo Padding',
          value: currentThemeConfig.logoPadding,
          min: 0,
          max: 64,
          divisions: 64,
          onChanged: (value) => onThemeConfigChanged(
            currentThemeConfig.copyWith(logoPadding: value),
          ),
        ),
      ],
    );
  }

  // ── Badge & Pill Sizing ───────────────────────────────────────────────────

  Widget _buildBadgePillSizingSection(BuildContext context) {
    return _ThemeEditorExpansionSection(
      title: 'Badge & Pill Sizing',
      icon: Icons.circle_outlined,
      children: [
        _SliderTile(
          label: 'Badge Min Radius',
          value: currentThemeConfig.badgeMinRadius,
          min: 4,
          max: 48,
          divisions: 88,
          onChanged: (value) => onThemeConfigChanged(
            currentThemeConfig.copyWith(badgeMinRadius: value),
          ),
        ),
        _SliderTile(
          label: 'Badge Padding',
          value: currentThemeConfig.badgePadding,
          min: 0,
          max: 24,
          divisions: 48,
          onChanged: (value) => onThemeConfigChanged(
            currentThemeConfig.copyWith(badgePadding: value),
          ),
        ),
        _SliderTile(
          label: 'Pill Min Half‑Width',
          value: currentThemeConfig.matchPillMinHalfWidth,
          min: 8,
          max: 80,
          divisions: 72,
          onChanged: (value) => onThemeConfigChanged(
            currentThemeConfig.copyWith(matchPillMinHalfWidth: value),
          ),
        ),
        _SliderTile(
          label: 'Pill H‑Padding',
          value: currentThemeConfig.matchPillHorizontalPadding,
          min: 0,
          max: 40,
          divisions: 80,
          onChanged: (value) => onThemeConfigChanged(
            currentThemeConfig.copyWith(matchPillHorizontalPadding: value),
          ),
        ),
        _SliderTile(
          label: 'Pill Min Half‑Height',
          value: currentThemeConfig.matchPillMinHalfHeight,
          min: 4,
          max: 48,
          divisions: 88,
          onChanged: (value) => onThemeConfigChanged(
            currentThemeConfig.copyWith(matchPillMinHalfHeight: value),
          ),
        ),
        _SliderTile(
          label: 'Pill V‑Padding',
          value: currentThemeConfig.matchPillVerticalPadding,
          min: 0,
          max: 24,
          divisions: 48,
          onChanged: (value) => onThemeConfigChanged(
            currentThemeConfig.copyWith(matchPillVerticalPadding: value),
          ),
        ),
      ],
    );
  }

  // ── Shadows ───────────────────────────────────────────────────────────────

  Widget _buildShadowsSection(BuildContext context) {
    return _ThemeEditorExpansionSection(
      title: 'Shadows',
      icon: Icons.layers_outlined,
      children: [
        _SliderTile(
          label: 'Opacity Multiplier',
          value: currentThemeConfig.shadowOpacityMultiplier,
          min: 0,
          max: 1,
          divisions: 20,
          onChanged: (value) => onThemeConfigChanged(
            currentThemeConfig.copyWith(shadowOpacityMultiplier: value),
          ),
        ),
        _SliderTile(
          label: 'Blur Radius',
          value: currentThemeConfig.shadowBlurRadius,
          min: 0,
          max: 40,
          divisions: 80,
          onChanged: (value) => onThemeConfigChanged(
            currentThemeConfig.copyWith(shadowBlurRadius: value),
          ),
        ),
        _buildColorPickerTile(
          context,
          label: 'Shadow Colour',
          currentColor: currentThemeConfig.shadowColor,
          onColorSelected: (color) => onThemeConfigChanged(
            currentThemeConfig.copyWith(shadowColor: color),
          ),
        ),
        _SliderTile(
          label: 'Offset X',
          value: currentThemeConfig.shadowOffsetX,
          min: 0,
          max: 20,
          divisions: 40,
          onChanged: (value) => onThemeConfigChanged(
            currentThemeConfig.copyWith(shadowOffsetX: value),
          ),
        ),
        _SliderTile(
          label: 'Offset Y',
          value: currentThemeConfig.shadowOffsetY,
          min: 0,
          max: 20,
          divisions: 40,
          onChanged: (value) => onThemeConfigChanged(
            currentThemeConfig.copyWith(shadowOffsetY: value),
          ),
        ),
      ],
    );
  }

  // ── Typography ────────────────────────────────────────────────────────────

  Widget _buildTypographySection(BuildContext context) {
    return _ThemeEditorExpansionSection(
      title: 'Typography',
      icon: Icons.font_download_outlined,
      children: [
        _FontFamilyDropdownTile(
          currentFontFamily: currentThemeConfig.fontFamily,
          onFontFamilyChanged: (fontFamily) => onThemeConfigChanged(
            currentThemeConfig.copyWith(fontFamily: fontFamily),
          ),
        ),
        _SliderTile(
          label: 'Header Letter Spacing',
          value: currentThemeConfig.headerLetterSpacing,
          min: 0,
          max: 10,
          divisions: 100,
          onChanged: (value) => onThemeConfigChanged(
            currentThemeConfig.copyWith(headerLetterSpacing: value),
          ),
        ),
        _SliderTile(
          label: 'Sub-Header Letter Spacing',
          value: currentThemeConfig.subHeaderLetterSpacing,
          min: 0,
          max: 10,
          divisions: 100,
          onChanged: (value) => onThemeConfigChanged(
            currentThemeConfig.copyWith(subHeaderLetterSpacing: value),
          ),
        ),
      ],
    );
  }

  // ── Layout Dimensions ──────────────────────────────────────────────────────

  Widget _buildLayoutDimensionsSection(BuildContext context) {
    return _ThemeEditorExpansionSection(
      title: 'Layout Dimensions',
      icon: Icons.straighten_outlined,
      children: [
        _SliderTile(
          label: 'Row Height',
          value: currentThemeConfig.rowHeight,
          min: 20,
          max: 120,
          divisions: 100,
          onChanged: (value) => onThemeConfigChanged(
            currentThemeConfig.copyWith(rowHeight: value),
          ),
        ),
        _SliderTile(
          label: 'Intra-Match Gap Height',
          value: currentThemeConfig.intraMatchGapHeight,
          min: 10,
          max: 150,
          divisions: 140,
          onChanged: (value) => onThemeConfigChanged(
            currentThemeConfig.copyWith(intraMatchGapHeight: value),
          ),
        ),
        _SliderTile(
          label: 'Inter-Match Gap Height',
          value: currentThemeConfig.interMatchGapHeight,
          min: 40,
          max: 400,
          divisions: 180,
          onChanged: (value) => onThemeConfigChanged(
            currentThemeConfig.copyWith(interMatchGapHeight: value),
          ),
        ),
        _SliderTile(
          label: 'Number Column Width',
          value: currentThemeConfig.numberColumnWidth,
          min: 16,
          max: 120,
          divisions: 104,
          onChanged: (value) => onThemeConfigChanged(
            currentThemeConfig.copyWith(numberColumnWidth: value),
          ),
        ),
        _SliderTile(
          label: 'Name Column Width',
          value: currentThemeConfig.nameColumnWidth,
          min: 100,
          max: 600,
          divisions: 100,
          onChanged: (value) => onThemeConfigChanged(
            currentThemeConfig.copyWith(nameColumnWidth: value),
          ),
        ),
        _SliderTile(
          label: 'Registration ID Column Width',
          value: currentThemeConfig.registrationIdColumnWidth,
          min: 60,
          max: 400,
          divisions: 68,
          onChanged: (value) => onThemeConfigChanged(
            currentThemeConfig.copyWith(registrationIdColumnWidth: value),
          ),
        ),
        _SliderTile(
          label: 'Round Column Width',
          value: currentThemeConfig.roundColumnWidth,
          min: 80,
          max: 500,
          divisions: 84,
          onChanged: (value) => onThemeConfigChanged(
            currentThemeConfig.copyWith(roundColumnWidth: value),
          ),
        ),
        _SliderTile(
          label: 'Header Total Height',
          value: currentThemeConfig.headerTotalHeight,
          min: 60,
          max: 300,
          divisions: 48,
          onChanged: (value) => onThemeConfigChanged(
            currentThemeConfig.copyWith(headerTotalHeight: value),
          ),
        ),
        _SliderTile(
          label: 'Sub-Header Row Height',
          value: currentThemeConfig.subHeaderRowHeight,
          min: 16,
          max: 100,
          divisions: 84,
          onChanged: (value) => onThemeConfigChanged(
            currentThemeConfig.copyWith(subHeaderRowHeight: value),
          ),
        ),
        _SliderTile(
          label: 'Center Gap Width',
          value: currentThemeConfig.centerGapWidth,
          min: 100,
          max: 800,
          divisions: 70,
          onChanged: (value) => onThemeConfigChanged(
            currentThemeConfig.copyWith(centerGapWidth: value),
          ),
        ),
        _SliderTile(
          label: 'Section Label Height',
          value: currentThemeConfig.sectionLabelHeight,
          min: 20,
          max: 100,
          divisions: 80,
          onChanged: (value) => onThemeConfigChanged(
            currentThemeConfig.copyWith(sectionLabelHeight: value),
          ),
        ),
        const _SectionSubHeader(label: 'Medal Table'),
        _SliderTile(
          label: 'Medal Table Width',
          value: currentThemeConfig.medalTableWidth,
          min: 200,
          max: 1000,
          divisions: 80,
          onChanged: (value) => onThemeConfigChanged(
            currentThemeConfig.copyWith(medalTableWidth: value),
          ),
        ),
        _SliderTile(
          label: 'Medal Row Height',
          value: currentThemeConfig.medalRowHeight,
          min: 20,
          max: 100,
          divisions: 80,
          onChanged: (value) => onThemeConfigChanged(
            currentThemeConfig.copyWith(medalRowHeight: value),
          ),
        ),
        _SliderTile(
          label: 'Medal Name Column Width',
          value: currentThemeConfig.medalNameColumnWidth,
          min: 120,
          max: 600,
          divisions: 96,
          onChanged: (value) => onThemeConfigChanged(
            currentThemeConfig.copyWith(medalNameColumnWidth: value),
          ),
        ),
        _SliderTile(
          label: 'Medal Label Column Width',
          value: currentThemeConfig.medalLabelColumnWidth,
          min: 50,
          max: 400,
          divisions: 70,
          onChanged: (value) => onThemeConfigChanged(
            currentThemeConfig.copyWith(medalLabelColumnWidth: value),
          ),
        ),
        _SliderTile(
          label: 'Medal Row Gap',
          value: currentThemeConfig.medalRowGap,
          min: 0,
          max: 32,
          divisions: 32,
          onChanged: (value) => onThemeConfigChanged(
            currentThemeConfig.copyWith(medalRowGap: value),
          ),
        ),
        const _SectionSubHeader(label: 'Junction Geometry'),
        _SliderTile(
          label: 'Center Final Min Span',
          value: currentThemeConfig.centerFinalMinimumSpan,
          min: 20,
          max: 300,
          divisions: 56,
          onChanged: (value) => onThemeConfigChanged(
            currentThemeConfig.copyWith(centerFinalMinimumSpan: value),
          ),
        ),
        _SliderTile(
          label: 'Grand Final Arm Length',
          value: currentThemeConfig.grandFinalOutputArmLength,
          min: 10,
          max: 200,
          divisions: 38,
          onChanged: (value) => onThemeConfigChanged(
            currentThemeConfig.copyWith(grandFinalOutputArmLength: value),
          ),
        ),
        const _SectionSubHeader(label: 'Canvas Constraints'),
        _SliderTile(
          label: 'Canvas Min Width',
          value: currentThemeConfig.canvasMinimumWidth,
          min: 400,
          max: 4000,
          divisions: 72,
          onChanged: (value) => onThemeConfigChanged(
            currentThemeConfig.copyWith(canvasMinimumWidth: value),
          ),
        ),
        _SliderTile(
          label: 'Canvas Min Height',
          value: currentThemeConfig.canvasMinimumHeight,
          min: 300,
          max: 3000,
          divisions: 54,
          onChanged: (value) => onThemeConfigChanged(
            currentThemeConfig.copyWith(canvasMinimumHeight: value),
          ),
        ),
        const _SectionSubHeader(label: 'Behaviour'),
        _ToggleSwitchTile(
          label: 'Disable Interactivity',
          value: currentThemeConfig.isInteractivityDisabled,
          onChanged: (value) => onThemeConfigChanged(
            currentThemeConfig.copyWith(isInteractivityDisabled: value),
          ),
        ),
      ],
    );
  }

  // ── Banner & Logo ─────────────────────────────────────────────────────────

  Widget _buildBannerAndLogoSection(BuildContext context) {
    return _ThemeEditorExpansionSection(
      title: 'Banner & Logo',
      icon: Icons.image_outlined,
      children: [
        _SliderTile(
          label: 'Header Banner Height',
          value: currentThemeConfig.headerBannerHeight,
          min: 40,
          max: 200,
          divisions: 80,
          onChanged: (value) => onThemeConfigChanged(
            currentThemeConfig.copyWith(headerBannerHeight: value),
          ),
        ),
        _SliderTile(
          label: 'Logo Max Height',
          value: currentThemeConfig.logoMaxHeight,
          min: 20,
          max: 200,
          divisions: 36,
          onChanged: (value) => onThemeConfigChanged(
            currentThemeConfig.copyWith(logoMaxHeight: value),
          ),
        ),
        _SliderTile(
          label: 'Logo Padding',
          value: currentThemeConfig.logoPadding,
          min: 0,
          max: 64,
          divisions: 64,
          onChanged: (value) => onThemeConfigChanged(
            currentThemeConfig.copyWith(logoPadding: value),
          ),
        ),
      ],
    );
  }

  // ── Additional Colours & Opacity ──────────────────────────────────────────

  Widget _buildAdditionalColorsAndOpacitySection(BuildContext context) {
    return _ThemeEditorExpansionSection(
      title: 'Extra Colours & Opacity',
      icon: Icons.opacity_outlined,
      children: [
        _buildColorPickerTile(
          context,
          label: 'Match Pill Fill',
          currentColor: currentThemeConfig.matchPillFillColor,
          onColorSelected: (color) => onThemeConfigChanged(
            currentThemeConfig.copyWith(matchPillFillColor: color),
          ),
        ),
        _buildColorPickerTile(
          context,
          label: 'Badge Text',
          currentColor: currentThemeConfig.badgeTextColor,
          onColorSelected: (color) => onThemeConfigChanged(
            currentThemeConfig.copyWith(badgeTextColor: color),
          ),
        ),
        _SliderTile(
          label: 'Section Label Bg Opacity',
          value: currentThemeConfig.sectionLabelBackgroundOpacity,
          min: 0,
          max: 1,
          divisions: 20,
          onChanged: (value) => onThemeConfigChanged(
            currentThemeConfig.copyWith(sectionLabelBackgroundOpacity: value),
          ),
        ),
        _SliderTile(
          label: 'Header Secondary Text',
          value: currentThemeConfig.headerSecondaryTextOpacity,
          min: 0,
          max: 1,
          divisions: 20,
          onChanged: (value) => onThemeConfigChanged(
            currentThemeConfig.copyWith(headerSecondaryTextOpacity: value),
          ),
        ),
        _SliderTile(
          label: 'Badge Outline Opacity',
          value: currentThemeConfig.badgeOutlineOpacity,
          min: 0,
          max: 1,
          divisions: 20,
          onChanged: (value) => onThemeConfigChanged(
            currentThemeConfig.copyWith(badgeOutlineOpacity: value),
          ),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// REUSABLE TILE WIDGETS (PRIVATE)
// ══════════════════════════════════════════════════════════════════════════════

/// Collapsible section wrapper with icon + title.
class _ThemeEditorExpansionSection extends StatelessWidget {
  const _ThemeEditorExpansionSection({
    required this.title,
    required this.icon,
    required this.children,
  });

  final String title;
  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: Icon(icon, size: 18),
      title: Text(title, style: const TextStyle(fontSize: 13)),
      dense: true,
      tilePadding: const EdgeInsets.symmetric(horizontal: 12),
      childrenPadding: const EdgeInsets.only(left: 16, right: 8, bottom: 8),
      children: children,
    );
  }
}

/// A compact sub-header inside a section (e.g. "Gold", "Silver", "Bronze").
class _SectionSubHeader extends StatelessWidget {
  const _SectionSubHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 4),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.primary,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

/// Colour swatch tile that opens a full picker dialog on tap.
class _ColorPickerTile extends StatelessWidget {
  const _ColorPickerTile({
    required this.label,
    required this.currentColor,
    required this.onColorSelected,
    required this.onShowPicker,
  });

  final String label;
  final Color currentColor;
  final ValueChanged<Color> onColorSelected;
  final void Function(
    String label,
    Color currentColor,
    ValueChanged<Color> onColorChanged,
  )
  onShowPicker;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: () => onShowPicker(label, currentColor, onColorSelected),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
          child: Row(
            children: [
              // Checkerboard behind the swatch shows transparency.
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CustomPaint(
                    painter: _CheckerboardPainter(),
                    child: Container(
                      decoration: BoxDecoration(
                        color: currentColor,
                        border: Border.all(
                          color: Colors.grey.shade400,
                          width: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '#${_colorToHexString(currentColor)}',
                style: TextStyle(
                  fontSize: 10,
                  fontFamily: 'monospace',
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Slider tile with label, current numeric value display, and range indicators.
class _SliderTile extends StatelessWidget {
  const _SliderTile({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.onChanged,
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final ValueChanged<double> onChanged;

  String _formatValue(double v) {
    return v == v.roundToDouble() ? v.toInt().toString() : v.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    final rangeTextStyle = TextStyle(
      fontSize: 9,
      fontFamily: 'monospace',
      color: Colors.grey.shade500,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(label, style: const TextStyle(fontSize: 12)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primaryContainer.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  _formatValue(value),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'monospace',
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 28,
            child: Row(
              children: [
                Text(_formatValue(min), style: rangeTextStyle),
                Expanded(
                  child: Slider(
                    value: value.clamp(min, max),
                    min: min,
                    max: max,
                    divisions: divisions,
                    onChanged: onChanged,
                  ),
                ),
                Text(_formatValue(max), style: rangeTextStyle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Toggle switch tile with label.
class _ToggleSwitchTile extends StatelessWidget {
  const _ToggleSwitchTile({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontSize: 12))),
          SizedBox(
            height: 28,
            child: FittedBox(
              child: Switch(value: value, onChanged: onChanged),
            ),
          ),
        ],
      ),
    );
  }
}

/// Dropdown tile for selecting a font family.
class _FontFamilyDropdownTile extends StatelessWidget {
  const _FontFamilyDropdownTile({
    required this.currentFontFamily,
    required this.onFontFamilyChanged,
  });

  final String currentFontFamily;
  final ValueChanged<String> onFontFamilyChanged;

  static const List<String> _availableFontFamilies = [
    'Roboto',
    'Inter',
    'Outfit',
    'Montserrat',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Expanded(
            child: Text('Font Family', style: TextStyle(fontSize: 12)),
          ),
          DropdownButton<String>(
            value: _availableFontFamilies.contains(currentFontFamily)
                ? currentFontFamily
                : _availableFontFamilies.first,
            isDense: true,
            underline: const SizedBox.shrink(),
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
            items: _availableFontFamilies
                .map((font) => DropdownMenuItem(value: font, child: Text(font)))
                .toList(),
            onChanged: (value) {
              if (value != null) onFontFamilyChanged(value);
            },
          ),
        ],
      ),
    );
  }
}

/// Paints a small checkerboard pattern behind colour swatches so the user
/// can distingush transparent / semi-transparent colours from opaque ones.
class _CheckerboardPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const cellSize = 4.0;
    final lightPaint = Paint()..color = const Color(0xFFFFFFFF);
    final darkPaint = Paint()..color = const Color(0xFFCCCCCC);

    for (var y = 0.0; y < size.height; y += cellSize) {
      for (var x = 0.0; x < size.width; x += cellSize) {
        final isEvenColumn = (x / cellSize).floor() % 2 == 0;
        final isEvenRow = (y / cellSize).floor() % 2 == 0;
        canvas.drawRect(
          Rect.fromLTWH(x, y, cellSize, cellSize),
          isEvenColumn == isEvenRow ? lightPaint : darkPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
