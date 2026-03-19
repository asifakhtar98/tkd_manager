import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tkd_saas/features/bracket/domain/entities/match_entity.dart';

/// A dialog for recording match results.
///
/// Displays Blue (Chung) vs Red (Hong) participant names and allows the
/// user to declare a winner, select a result type, and optionally enter scores.
class ScoreEntryDialog extends StatefulWidget {
  const ScoreEntryDialog({
    required this.match,
    required this.blueParticipantName,
    required this.redParticipantName,
    super.key,
  });

  final MatchEntity match;
  final String blueParticipantName;
  final String redParticipantName;

  /// Shows the dialog and returns a [ScoreEntryResult] if confirmed, null if cancelled.
  static Future<ScoreEntryResult?> show({
    required BuildContext context,
    required MatchEntity match,
    required String blueParticipantName,
    required String redParticipantName,
  }) {
    return showDialog<ScoreEntryResult>(
      context: context,
      builder: (_) => ScoreEntryDialog(
        match: match,
        blueParticipantName: blueParticipantName,
        redParticipantName: redParticipantName,
      ),
    );
  }

  @override
  State<ScoreEntryDialog> createState() => _ScoreEntryDialogState();
}

class _ScoreEntryDialogState extends State<ScoreEntryDialog> {
  String? _selectedWinnerId;
  MatchResultType _resultType = MatchResultType.points;
  final _blueScoreController = TextEditingController();
  final _redScoreController = TextEditingController();

  bool get _isBlueWinner => _selectedWinnerId == widget.match.participantBlueId;
  bool get _isRedWinner => _selectedWinnerId == widget.match.participantRedId;

  @override
  void dispose() {
    _blueScoreController.dispose();
    _redScoreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.sports_martial_arts, color: colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            'Match R${widget.match.roundNumber}-M${widget.match.matchNumberInRound}',
            style: theme.textTheme.titleLarge,
          ),
        ],
      ),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Blue vs Red Selection ──
            Row(
              children: [
                Expanded(
                  child: _ParticipantCard(
                    name: widget.blueParticipantName,
                    color: Colors.blue,
                    label: 'CHUNG',
                    isSelected: _isBlueWinner,
                    onTap: () => setState(() {
                      _selectedWinnerId = widget.match.participantBlueId;
                    }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'VS',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                Expanded(
                  child: _ParticipantCard(
                    name: widget.redParticipantName,
                    color: Colors.red,
                    label: 'HONG',
                    isSelected: _isRedWinner,
                    onTap: () => setState(() {
                      _selectedWinnerId = widget.match.participantRedId;
                    }),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ── Result Type ──
            DropdownButtonFormField<MatchResultType>(
              initialValue: _resultType,
              decoration: const InputDecoration(
                labelText: 'Result Type',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              items: const [
                DropdownMenuItem(
                  value: MatchResultType.points,
                  child: Text('Points'),
                ),
                DropdownMenuItem(
                  value: MatchResultType.knockout,
                  child: Text('Knockout'),
                ),
                DropdownMenuItem(
                  value: MatchResultType.disqualification,
                  child: Text('Disqualification'),
                ),
                DropdownMenuItem(
                  value: MatchResultType.withdrawal,
                  child: Text('Withdrawal'),
                ),
                DropdownMenuItem(
                  value: MatchResultType.refereeDecision,
                  child: Text('Referee Decision'),
                ),
              ],
              onChanged: (selectedResultType) {
                if (selectedResultType != null)
                  setState(() => _resultType = selectedResultType);
              },
            ),
            const SizedBox(height: 16),

            // ── Scores (optional) ──
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _blueScoreController,
                    decoration: const InputDecoration(
                      labelText: 'Blue Score',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _redScoreController,
                    decoration: const InputDecoration(
                      labelText: 'Red Score',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _selectedWinnerId == null
              ? null
              : () {
                  Navigator.of(context).pop(
                    ScoreEntryResult(
                      winnerId: _selectedWinnerId!,
                      resultType: _resultType,
                      blueScore: int.tryParse(_blueScoreController.text),
                      redScore: int.tryParse(_redScoreController.text),
                    ),
                  );
                },
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}

/// A tappable card representing one participant in the match.
class _ParticipantCard extends StatelessWidget {
  const _ParticipantCard({
    required this.name,
    required this.color,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String name;
  final Color color;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? color.withAlpha(30) : Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? color : Colors.grey.shade300,
          width: isSelected ? 2.5 : 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (isSelected) ...[
                const SizedBox(height: 4),
                Icon(Icons.check_circle, color: color, size: 20),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// The result returned from the [ScoreEntryDialog].
class ScoreEntryResult {
  const ScoreEntryResult({
    required this.winnerId,
    required this.resultType,
    this.blueScore,
    this.redScore,
  });

  final String winnerId;
  final MatchResultType resultType;
  final int? blueScore;
  final int? redScore;
}
