import 'package:flutter/material.dart';
import 'package:tkd_saas/features/bracket/domain/entities/match_entity.dart';
import 'package:tkd_saas/features/setup_bracket/domain/entities/participant_entity.dart';

/// A panel displaying all bracket matches grouped by round, allowing
/// score entry and winner selection without interacting with the bracket
/// visual itself.
///
/// This replaces the old tap-on-canvas interaction for recording match
/// results, providing a higher-usability list-based interface.
class BracketMatchListPanel extends StatelessWidget {
  const BracketMatchListPanel({
    super.key,
    required this.matches,
    required this.participants,
    required this.onRecordMatchResult,
    this.winnersBracketId,
    this.losersBracketId,
  });

  final List<MatchEntity> matches;
  final List<ParticipantEntity> participants;
  final void Function(String matchId, String winnerId) onRecordMatchResult;
  final String? winnersBracketId;
  final String? losersBracketId;

  @override
  Widget build(BuildContext context) {
    final groupedMatches = _groupMatchesBySection();
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: groupedMatches.length,
      itemBuilder: (context, index) {
        final section = groupedMatches[index];
        return _MatchSectionWidget(
          sectionTitle: section.sectionTitle,
          matches: section.matches,
          participants: participants,
          onRecordMatchResult: onRecordMatchResult,
        );
      },
    );
  }

  List<_MatchSection> _groupMatchesBySection() {
    final sections = <_MatchSection>[];
    final isDoubleElimination = winnersBracketId != null && losersBracketId != null;

    if (isDoubleElimination) {
      final wbMatches = matches.where((m) => m.bracketId == winnersBracketId).toList()
        ..sort(_matchComparator);
      final lbMatches = matches.where((m) => m.bracketId == losersBracketId).toList()
        ..sort(_matchComparator);
      final gfMatches = matches.where((m) =>
          m.bracketId != winnersBracketId && m.bracketId != losersBracketId).toList()
        ..sort(_matchComparator);

      if (wbMatches.isNotEmpty) sections.add(_MatchSection('Winners Bracket', wbMatches));
      if (lbMatches.isNotEmpty) sections.add(_MatchSection('Losers Bracket', lbMatches));
      if (gfMatches.isNotEmpty) sections.add(_MatchSection('Grand Finals', gfMatches));
    } else {
      final byRound = <int, List<MatchEntity>>{};
      for (final m in matches) {
        byRound.putIfAbsent(m.roundNumber, () => []).add(m);
      }
      final sortedRounds = byRound.keys.toList()..sort();
      for (final round in sortedRounds) {
        final roundMatches = byRound[round]!..sort(_matchComparator);
        sections.add(_MatchSection('Round $round', roundMatches));
      }
    }
    return sections;
  }

  int _matchComparator(MatchEntity a, MatchEntity b) {
    final roundCmp = a.roundNumber.compareTo(b.roundNumber);
    if (roundCmp != 0) return roundCmp;
    return a.matchNumberInRound.compareTo(b.matchNumberInRound);
  }
}

class _MatchSection {
  _MatchSection(this.sectionTitle, this.matches);
  final String sectionTitle;
  final List<MatchEntity> matches;
}

class _MatchSectionWidget extends StatelessWidget {
  const _MatchSectionWidget({
    required this.sectionTitle,
    required this.matches,
    required this.participants,
    required this.onRecordMatchResult,
  });

  final String sectionTitle;
  final List<MatchEntity> matches;
  final List<ParticipantEntity> participants;
  final void Function(String matchId, String winnerId) onRecordMatchResult;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(sectionTitle, style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold, color: theme.colorScheme.primary,
          )),
        ),
        ...matches.map((match) => _MatchEntryCard(
          match: match, participants: participants,
          onRecordMatchResult: onRecordMatchResult,
        )),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _MatchEntryCard extends StatelessWidget {
  const _MatchEntryCard({
    required this.match,
    required this.participants,
    required this.onRecordMatchResult,
  });

  final MatchEntity match;
  final List<ParticipantEntity> participants;
  final void Function(String matchId, String winnerId) onRecordMatchResult;

  ParticipantEntity? _findParticipant(String? id) =>
      id == null ? null : participants.where((p) => p.id == id).firstOrNull;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final blue = _findParticipant(match.participantBlueId);
    final red = _findParticipant(match.participantRedId);
    final isBye = match.resultType == MatchResultType.bye;
    final hasWinner = match.winnerId != null;
    final matchLabel = match.globalMatchDisplayNumber != null
        ? 'Match ${match.globalMatchDisplayNumber}'
        : 'R${match.roundNumber}-M${match.matchNumberInRound}';

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(matchLabel, style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold)),
                const Spacer(),
                if (isBye) _buildStatusChip(context, 'BYE', Colors.orange),
                if (hasWinner && !isBye) _buildStatusChip(context, 'Completed', Colors.green),
                if (!hasWinner && !isBye) _buildStatusChip(context, 'Pending', Colors.grey),
              ],
            ),
            const SizedBox(height: 8),
            _buildParticipantRow(context, 'B', blue, match.participantBlueId,
                isWinner: match.winnerId == match.participantBlueId),
            const Divider(height: 8),
            _buildParticipantRow(context, 'R', red, match.participantRedId,
                isWinner: match.winnerId == match.participantRedId),
          ],
        ),
      ),
    );
  }

  Widget _buildParticipantRow(BuildContext context, String corner,
      ParticipantEntity? participant, String? participantId,
      {required bool isWinner}) {
    final theme = Theme.of(context);
    final cornerColor = corner == 'B' ? Colors.blue : Colors.red;
    final name = participant?.fullName ?? (participantId != null ? 'Unknown' : 'TBD');
    final canSelect = participantId != null && !isWinner && match.winnerId == null;

    final capturedParticipantId = participantId;
    return InkWell(
      onTap: canSelect && capturedParticipantId != null ? () => onRecordMatchResult(match.id, capturedParticipantId) : null,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Row(
          children: [
            Container(
              width: 24, height: 24,
              decoration: BoxDecoration(color: cornerColor, borderRadius: BorderRadius.circular(12)),
              child: Center(child: Text(corner, style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
            ),
            const SizedBox(width: 10),
            Expanded(child: Text(name, style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: isWinner ? FontWeight.bold : FontWeight.normal,
              color: participantId == null ? theme.colorScheme.outline : null,
            ))),
            if (isWinner) Icon(Icons.emoji_events, color: Colors.amber.shade700, size: 20),
            if (canSelect) Icon(Icons.touch_app, color: theme.colorScheme.primary, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label, style: TextStyle(
          fontSize: 11, fontWeight: FontWeight.bold, color: color)),
    );
  }
}
