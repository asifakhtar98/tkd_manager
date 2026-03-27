import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tkd_saas/core/config/app_config.dart';
import 'package:tkd_saas/core/router/app_routes.dart';
import 'package:tkd_saas/features/auth/presentation/bloc/authentication_bloc.dart';
import 'package:tkd_saas/features/tournament/domain/entities/tournament_entity.dart';
import 'package:tkd_saas/features/tournament/presentation/bloc/tournament_bloc.dart';
import 'package:tkd_saas/features/tournament/presentation/widgets/create_tournament_dialog.dart';

/// Main dashboard showing tournaments and a sign-out action.
///
/// This is the default route for authenticated users. The pre-seeded
/// "Demo Tournament" appears in the tournament list like any other
/// tournament — users click into it to access its demo brackets.
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
        actions: [
          if (AppConfig.isAuthenticationEnabled) ...[
            TextButton.icon(
              onPressed: () {
                context.read<AuthenticationBloc>().add(
                  const AuthenticationSignOutRequested(),
                );
              },
              icon: const Icon(Icons.logout),
              label: const Text('Sign Out'),
            ),
            const SizedBox(width: 8),
          ],
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: _buildTournamentSection(context, theme),
      ),
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
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
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
                      'No tournaments yet. Create one to get started.',
                      style: TextStyle(color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              )
            else
              ...state.tournaments.map(
                (tournament) => _TournamentCard(tournament: tournament),
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tournament \u201c${tournament.name}\u201d created.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
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
        .watch<TournamentBloc>()
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
