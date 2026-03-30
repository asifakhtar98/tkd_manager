/// Barrel re-export — the canonical definition now lives in the domain layer.
///
/// Presentation-layer widgets (editor panel, canvas widget) continue importing
/// from this path via relative imports without source changes.
library;

export 'package:tkd_saas/features/bracket/domain/value_objects/tie_sheet_theme_config.dart';
