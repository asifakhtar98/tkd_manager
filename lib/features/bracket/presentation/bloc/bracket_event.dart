import 'package:tkd_saas/features/participant/domain/entities/participant_entity.dart';

/// Base class for all bracket BLoC events.
sealed class BracketEvent {
  const BracketEvent();
}

/// Trigger initial generation. Carries all params required by the engine.
final class BracketGenerateRequested extends BracketEvent {
  const BracketGenerateRequested({
    required this.participants,
    required this.format,
    required this.dojangSeparation,
    required this.includeThirdPlaceMatch,
  });

  final List<ParticipantEntity> participants;

  /// 'Single Elimination' | 'Double Elimination'
  final String format;
  final bool dojangSeparation;
  final bool includeThirdPlaceMatch;
}

/// Re-generate using the same params stored from the last [BracketGenerateRequested].
final class BracketRegenerateRequested extends BracketEvent {
  const BracketRegenerateRequested();
}
