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
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Tournament loading is now eager-loaded at the app root in main.dart
    // to ensure deep-linking consistently has data fetching underway.
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('TKD Tournament Manager'),
        elevation: 0,
        centerTitle: false,
        actions: [
          if (AppConfig.isAuthenticationEnabled)
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              tooltip: 'More options',
              onSelected: (value) {
                if (value == 'sign_out') {
                  _confirmSignOut(context);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'sign_out',
                  child: Row(
                    children: [
                      Icon(Icons.logout, size: 20),
                      SizedBox(width: 12),
                      Text('Sign Out'),
                    ],
                  ),
                ),
              ],
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocListener<TournamentBloc, TournamentState>(
        listenWhen: (previous, current) {
          return previous.isSaving != current.isSaving ||
                 previous.lastMutationError != current.lastMutationError ||
                 previous.tournaments.length != current.tournaments.length;
        },
        listener: (context, state) {
          if (state.lastMutationError != null && state.lastMutationError!.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.lastMutationError!),
                backgroundColor: theme.colorScheme.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 200) {
              context.read<TournamentBloc>().add(const TournamentEvent.loadMoreRequested());
            }
            return false;
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: _buildTournamentSection(context, theme),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Sign Out?'),
        content: const Text('Are you sure you want to sign out?'),
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
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      context.read<AuthenticationBloc>().add(
        const AuthenticationSignOutRequested(),
      );
    }
  }

  Widget _buildTournamentSection(BuildContext context, ThemeData theme) {
    return BlocBuilder<TournamentBloc, TournamentState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(48.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

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
                  icon: state.isSaving 
                      ? const SizedBox(
                          width: 16, 
                          height: 16, 
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)
                        )
                      : const Icon(Icons.add),
                  label: const Text('New Tournament'),
                  onPressed: state.isSaving ? null : () => _showCreateDialog(context),
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
            if (state.isFetchingMore)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24.0),
                child: Center(child: CircularProgressIndicator()),
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
      // Success snackbar could be handled in the BlocListener if we mapped the specific success,
      // but for now, the BlocListener will catch errors. 
      // If no error falls out and isSaving finishes, it succeeded.
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
            TournamentDetailRoute(tournamentId: tournament.id).go(context),
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
