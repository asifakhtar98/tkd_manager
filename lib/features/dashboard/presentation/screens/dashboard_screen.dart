import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tkd_saas/core/router/app_routes.dart';
import 'package:tkd_saas/features/core/data/demo_data.dart';
import 'package:tkd_saas/features/tournament/domain/entities/tournament_entity.dart';
import 'package:tkd_saas/features/tournament/presentation/bloc/tournament_bloc.dart';
import 'package:tkd_saas/features/tournament/presentation/widgets/create_tournament_dialog.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('TKD Tournament Manager'),
        elevation: 0,
        centerTitle: false,
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('New Bracket'),
        onPressed: () => const SetupRoute().push(context),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeHeader(theme),
            const SizedBox(height: 32),
            _buildTournamentSection(context, theme),
            const SizedBox(height: 48),
            _buildDemoSection(context, theme),
          ],
        ),
      ),
    );
  }

  void _pushDemo(BuildContext context, String format, int playerCount) {
    BracketRoute(
      $extra: BracketRouteExtra(
        participants: DemoData.getParticipants(playerCount),
        dojangSeparation: true,
        format: format,
        includeThirdPlaceMatch: true,
        tournament: DemoData.getTournamentEntity(format),
      ),
    ).push(context);
  }

  Widget _buildWelcomeHeader(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'TKD Tournament Dashboard',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Create professional TKD brackets or explore demo formats below.',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildTournamentSection(BuildContext context, ThemeData theme) {
    return BlocBuilder<TournamentBloc, TournamentState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'My Tournaments',
                  style: theme.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                FilledButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('New Tournament'),
                  onPressed: () => _showCreateDialog(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (state.tournaments.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Center(
                    child: Text(
                      'No tournaments yet. Create one or jump in with a demo below.',
                      style: TextStyle(color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              )
            else
              ...state.tournaments.map(
                (t) => _TournamentCard(tournament: t),
              ),
          ],
        );
      },
    );
  }

  Future<void> _showCreateDialog(BuildContext context) async {
    final tournament = await showDialog<TournamentEntity>(
      context: context,
      builder: (_) => const CreateTournamentDialog(),
    );
    if (tournament != null && context.mounted) {
      context.read<TournamentBloc>().add(TournamentEvent.created(tournament));
    }
  }

  Widget _buildDemoSection(BuildContext context, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Demo Brackets',
          style: theme.textTheme.titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          'Preview the bracket viewer with sample data — no setup needed.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _DemoCard(
              icon: Icons.account_tree_outlined,
              title: 'Single Elim (8)',
              subtitle: '8 players, Single Elimination',
              onTap: () => _pushDemo(context, 'Single Elimination', 8),
            ),
            _DemoCard(
              icon: Icons.account_tree_outlined,
              title: 'Single Elim (14)',
              subtitle: '14 players with BYEs',
              onTap: () => _pushDemo(context, 'Single Elimination', 14),
            ),
            _DemoCard(
              icon: Icons.repeat,
              title: 'Double Elim (8)',
              subtitle: '8 players, Double Elimination',
              onTap: () => _pushDemo(context, 'Double Elimination', 8),
            ),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tournament list card
// ─────────────────────────────────────────────────────────────────────────────

class _TournamentCard extends StatelessWidget {
  const _TournamentCard({required this.tournament});

  final TournamentEntity tournament;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bracketCount = context
        .read<TournamentBloc>()
        .state
        .bracketsFor(tournament.id)
        .length;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () =>
            TournamentDetailRoute(tournamentId: tournament.id).push(context),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.emoji_events_outlined,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tournament.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    if (tournament.venue.isNotEmpty ||
                        tournament.dateRange.isNotEmpty)
                      Text(
                        [
                          if (tournament.venue.isNotEmpty) tournament.venue,
                          if (tournament.dateRange.isNotEmpty)
                            tournament.dateRange,
                        ].join(' · '),
                        style: theme.textTheme.bodySmall,
                      ),
                  ],
                ),
              ),
              Chip(
                label: Text(
                  '$bracketCount ${bracketCount == 1 ? 'bracket' : 'brackets'}',
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.primary,
                  ),
                ),
                backgroundColor: theme.colorScheme.primaryContainer,
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Demo card
// ─────────────────────────────────────────────────────────────────────────────

class _DemoCard extends StatelessWidget {
  const _DemoCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, size: 36, color: Colors.blueAccent),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
