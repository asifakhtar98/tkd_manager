import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tkd_saas/core/router/app_routes.dart';
import 'package:tkd_saas/features/tournament/domain/entities/bracket_snapshot.dart';
import 'package:tkd_saas/features/tournament/domain/entities/tournament_entity.dart';
import 'package:tkd_saas/features/tournament/presentation/bloc/tournament_bloc.dart';
import 'package:tkd_saas/features/tournament/presentation/widgets/create_tournament_dialog.dart';

/// Shows the detail of a tournament — its metadata and all previously
/// generated bracket snapshots. Tapping any snapshot re-opens the bracket
/// viewer. The FAB navigates to bracket setup with this tournament pre-selected.
class TournamentDetailScreen extends StatelessWidget {
  const TournamentDetailScreen({super.key, required this.tournamentId});

  final String tournamentId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TournamentBloc, TournamentState>(
      builder: (context, state) {
        final tournament = state.tournaments
            .where((t) => t.id == tournamentId)
            .firstOrNull;

        if (tournament == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Tournament')),
            body: const Center(child: Text('Tournament not found.')),
          );
        }

        final snapshots = state.bracketsFor(tournamentId);

        return Scaffold(
          appBar: AppBar(
            title: Text(tournament.name),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                tooltip: 'Edit Tournament',
                onPressed: () => _showEditDialog(context, tournament),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                tooltip: 'Delete Tournament',
                onPressed: () => _confirmDelete(context, tournament),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            icon: const Icon(Icons.add),
            label: const Text('Add Bracket'),
            onPressed: () =>
                SetupRoute(tournamentId: tournamentId).push(context),
          ),
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: _TournamentHeader(tournament: tournament),
              ),
              if (snapshots.isEmpty)
                const SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.account_tree_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No brackets yet.\nTap "+ Add Bracket" to generate the first one.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
                  sliver: SliverList.separated(
                    itemCount: snapshots.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) => _BracketSnapshotCard(
                      snapshot: snapshots[index],
                      tournament: tournament,
                      onDelete: () => context.read<TournamentBloc>().add(
                        TournamentEvent.bracketSnapshotRemoved(
                          tournamentId: tournamentId,
                          snapshotId: snapshots[index].id,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showEditDialog(
    BuildContext context,
    TournamentEntity tournament,
  ) async {
    final updated = await showDialog<TournamentEntity>(
      context: context,
      builder: (_) => CreateTournamentDialog(existing: tournament),
    );
    if (updated != null && context.mounted) {
      context.read<TournamentBloc>().add(TournamentEvent.updated(updated));
    }
  }

  Future<void> _confirmDelete(
    BuildContext context,
    TournamentEntity tournament,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Delete Tournament?'),
        content: Text(
          '"${tournament.name}" and all its brackets will be removed.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade800,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(c, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirm == true && context.mounted) {
      context.read<TournamentBloc>().add(
        TournamentEvent.deleted(tournament.id),
      );
      context.pop();
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tournament header card
// ─────────────────────────────────────────────────────────────────────────────

class _TournamentHeader extends StatelessWidget {
  const _TournamentHeader({required this.tournament});

  final TournamentEntity tournament;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final infoRows = [
      if (tournament.dateRange.isNotEmpty)
        _InfoRow(Icons.calendar_today_outlined, tournament.dateRange),
      if (tournament.venue.isNotEmpty)
        _InfoRow(Icons.location_on_outlined, tournament.venue),
      if (tournament.organizer.isNotEmpty)
        _InfoRow(Icons.person_outline, tournament.organizer),
      if (tournament.ageCategoryLabel.isNotEmpty)
        _InfoRow(Icons.category_outlined, tournament.ageCategoryLabel),
      if (tournament.genderLabel.isNotEmpty)
        _InfoRow(Icons.group_outlined, tournament.genderLabel),
      if (tournament.weightDivisionLabel.isNotEmpty)
        _InfoRow(Icons.fitness_center_outlined, tournament.weightDivisionLabel),
    ];

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tournament.name,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (infoRows.isNotEmpty) ...[
              const SizedBox(height: 12),
              ...infoRows,
            ],
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(this.icon, this.text);

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bracket snapshot card
// ─────────────────────────────────────────────────────────────────────────────

class _BracketSnapshotCard extends StatelessWidget {
  const _BracketSnapshotCard({
    required this.snapshot,
    required this.tournament,
    required this.onDelete,
  });

  final BracketSnapshot snapshot;
  final TournamentEntity tournament;
  final VoidCallback onDelete;

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Remove Bracket?'),
        content: const Text(
          'This bracket will be removed from history. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade800,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(c, true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (confirmed == true) onDelete();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            snapshot.format == BracketFormat.doubleElimination
                ? Icons.repeat
                : Icons.account_tree_outlined,
            color: theme.colorScheme.onSecondaryContainer,
          ),
        ),
        title: Text(
          snapshot.label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${snapshot.participantCount} players · '
          '${_formatDate(snapshot.generatedAt)}',
          style: theme.textTheme.bodySmall,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.delete_outline, color: Colors.grey.shade800),
              tooltip: 'Remove bracket',
              onPressed: () => _confirmDelete(context),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
        onTap: () => BracketRoute(
          $extra: BracketRouteExtra(
            participants: snapshot.participants,
            dojangSeparation: snapshot.dojangSeparation,
            bracketFormat: snapshot.format,
            includeThirdPlaceMatch: snapshot.includeThirdPlaceMatch,
            tournament: tournament,
            isHistoryView: true,
          ),
        ).push(context),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year}  '
        '${dt.hour.toString().padLeft(2, '0')}:'
        '${dt.minute.toString().padLeft(2, '0')}';
  }
}
