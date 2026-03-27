import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tkd_saas/core/config/app_config.dart';
import 'package:tkd_saas/core/router/app_routes.dart';
import 'package:tkd_saas/features/tournament/domain/entities/bracket_classification.dart';
import 'package:tkd_saas/features/auth/presentation/bloc/authentication_bloc.dart';
import 'package:tkd_saas/features/core/data/demo_data.dart';
import 'package:tkd_saas/features/tournament/domain/entities/tournament_entity.dart';
import 'package:tkd_saas/features/tournament/presentation/bloc/tournament_bloc.dart';
import 'package:tkd_saas/features/tournament/presentation/widgets/create_tournament_dialog.dart';

/// Main dashboard showing tournaments, demo brackets, and a sign-out action.
///
/// This is the default route for authenticated users.
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTournamentSection(context, theme),
            const SizedBox(height: 48),
            _buildDemoSection(context, theme),
          ],
        ),
      ),
    );
  }

  void _navigateToDemoBracketViewer(
    BuildContext context, {
    required BracketFormat bracketFormat,
    required int playerCount,
    bool includeThirdPlaceMatch = false,
    bool dojangSeparation = true,
  }) {
    BracketRoute(
      $extra: BracketRouteExtra(
        participants: DemoData.getParticipants(playerCount),
        dojangSeparation: dojangSeparation,
        bracketFormat: bracketFormat,
        includeThirdPlaceMatch: includeThirdPlaceMatch,
        tournament: DemoData.demoTournament,
        classification: const BracketClassification(
          ageCategoryLabel: 'Demo Age Category',
          genderLabel: 'Demo Gender',
          weightDivisionLabel: 'Under 59',
        ),
      ),
    ).push(context);
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
                      'No tournaments yet. Create one or jump in with a demo below.',
                      style: TextStyle(color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              )
            else
              ...state.tournaments.map((t) => _TournamentCard(tournament: t)),
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

  Widget _buildDemoSection(BuildContext context, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Demo Brackets',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Preview the bracket viewer with sample data — no setup needed.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),

        // ── Single Elimination ──
        const SizedBox(height: 24),
        _buildSectionHeader(theme, 'Single Elimination', theme.colorScheme.primary),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _DemoCard(
              icon: Icons.account_tree_outlined,
              title: '3 Players',
              subtitle: 'Minimal with 1 BYE',
              accentColor: Colors.grey.shade800,
              onTap: () => _navigateToDemoBracketViewer(
                context,
                bracketFormat: BracketFormat.singleElimination,
                playerCount: 3,
              ),
            ),
            _DemoCard(
              icon: Icons.account_tree_outlined,
              title: '4 Players',
              subtitle: 'Perfect small bracket',
              accentColor: Colors.grey.shade800,
              onTap: () => _navigateToDemoBracketViewer(
                context,
                bracketFormat: BracketFormat.singleElimination,
                playerCount: 4,
              ),
            ),
            _DemoCard(
              icon: Icons.account_tree_outlined,
              title: '5 Players',
              subtitle: 'BYEs in action',
              accentColor: Colors.grey.shade800,
              onTap: () => _navigateToDemoBracketViewer(
                context,
                bracketFormat: BracketFormat.singleElimination,
                playerCount: 5,
              ),
            ),
            _DemoCard(
              icon: Icons.account_tree_outlined,
              title: '7 Players',
              subtitle: 'Odd count, many BYEs',
              accentColor: Colors.grey.shade800,
              onTap: () => _navigateToDemoBracketViewer(
                context,
                bracketFormat: BracketFormat.singleElimination,
                playerCount: 7,
              ),
            ),
            _DemoCard(
              icon: Icons.account_tree_outlined,
              title: '8 Players',
              subtitle: 'Perfect bracket',
              accentColor: Colors.grey.shade800,
              onTap: () => _navigateToDemoBracketViewer(
                context,
                bracketFormat: BracketFormat.singleElimination,
                playerCount: 8,
              ),
            ),
            _DemoCard(
              icon: Icons.account_tree_outlined,
              title: '20 Players',
              subtitle: 'Mid-size with BYEs',
              accentColor: Colors.grey.shade800,
              onTap: () => _navigateToDemoBracketViewer(
                context,
                bracketFormat: BracketFormat.singleElimination,
                playerCount: 20,
              ),
            ),
            _DemoCard(
              icon: Icons.account_tree_outlined,
              title: '24 Players',
              subtitle: 'Large non-power-of-2',
              accentColor: Colors.grey.shade800,
              onTap: () => _navigateToDemoBracketViewer(
                context,
                bracketFormat: BracketFormat.singleElimination,
                playerCount: 24,
              ),
            ),
            _DemoCard(
              icon: Icons.account_tree_outlined,
              title: '32 Players',
              subtitle: 'Full 5-round draw',
              accentColor: Colors.grey.shade800,
              onTap: () => _navigateToDemoBracketViewer(
                context,
                bracketFormat: BracketFormat.singleElimination,
                playerCount: 32,
              ),
            ),
            _DemoCard(
              icon: Icons.account_tree_outlined,
              title: '64 Players',
              subtitle: 'Large-scale tournament',
              accentColor: Colors.grey.shade800,
              onTap: () => _navigateToDemoBracketViewer(
                context,
                bracketFormat: BracketFormat.singleElimination,
                playerCount: 64,
              ),
            ),
          ],
        ),

        // ── SE + 3rd Place Match ──
        const SizedBox(height: 32),
        _buildSectionHeader(theme, 'Single Elimination + 3rd Place', theme.colorScheme.primary),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _DemoCard(
              icon: Icons.emoji_events_outlined,
              title: '4P + 3rd Place',
              subtitle: 'Bronze match, small draw',
              accentColor: Colors.grey.shade800,
              onTap: () => _navigateToDemoBracketViewer(
                context,
                bracketFormat: BracketFormat.singleElimination,
                playerCount: 4,
                includeThirdPlaceMatch: true,
              ),
            ),
            _DemoCard(
              icon: Icons.emoji_events_outlined,
              title: '8P + 3rd Place',
              subtitle: 'Bronze match, standard',
              accentColor: Colors.grey.shade800,
              onTap: () => _navigateToDemoBracketViewer(
                context,
                bracketFormat: BracketFormat.singleElimination,
                playerCount: 8,
                includeThirdPlaceMatch: true,
              ),
            ),
            _DemoCard(
              icon: Icons.emoji_events_outlined,
              title: '32P + 3rd Place',
              subtitle: 'Bronze match, large draw',
              accentColor: Colors.grey.shade800,
              onTap: () => _navigateToDemoBracketViewer(
                context,
                bracketFormat: BracketFormat.singleElimination,
                playerCount: 32,
                includeThirdPlaceMatch: true,
              ),
            ),
          ],
        ),

        // ── Double Elimination ──
        const SizedBox(height: 32),
        _buildSectionHeader(theme, 'Double Elimination', theme.colorScheme.secondary),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _DemoCard(
              icon: Icons.repeat,
              title: '4 Players',
              subtitle: 'Minimal DE bracket',
              accentColor: Colors.grey.shade800,
              onTap: () => _navigateToDemoBracketViewer(
                context,
                bracketFormat: BracketFormat.doubleElimination,
                playerCount: 4,
              ),
            ),
            _DemoCard(
              icon: Icons.repeat,
              title: '5 Players',
              subtitle: 'DE with odd count',
              accentColor: Colors.grey.shade800,
              onTap: () => _navigateToDemoBracketViewer(
                context,
                bracketFormat: BracketFormat.doubleElimination,
                playerCount: 5,
              ),
            ),
            _DemoCard(
              icon: Icons.repeat,
              title: '6 Players',
              subtitle: 'DE with BYEs',
              accentColor: Colors.grey.shade800,
              onTap: () => _navigateToDemoBracketViewer(
                context,
                bracketFormat: BracketFormat.doubleElimination,
                playerCount: 6,
              ),
            ),
            _DemoCard(
              icon: Icons.repeat,
              title: '8 Players',
              subtitle: 'Standard DE bracket',
              accentColor: Colors.grey.shade800,
              onTap: () => _navigateToDemoBracketViewer(
                context,
                bracketFormat: BracketFormat.doubleElimination,
                playerCount: 8,
              ),
            ),
            _DemoCard(
              icon: Icons.repeat,
              title: '20 Players',
              subtitle: 'Mid-size DE with BYEs',
              accentColor: Colors.grey.shade800,
              onTap: () => _navigateToDemoBracketViewer(
                context,
                bracketFormat: BracketFormat.doubleElimination,
                playerCount: 20,
              ),
            ),
            _DemoCard(
              icon: Icons.repeat,
              title: '24 Players',
              subtitle: 'Large DE non-power-of-2',
              accentColor: Colors.grey.shade800,
              onTap: () => _navigateToDemoBracketViewer(
                context,
                bracketFormat: BracketFormat.doubleElimination,
                playerCount: 24,
              ),
            ),
            _DemoCard(
              icon: Icons.repeat,
              title: '32 Players',
              subtitle: 'Full-scale DE draw',
              accentColor: Colors.grey.shade800,
              onTap: () => _navigateToDemoBracketViewer(
                context,
                bracketFormat: BracketFormat.doubleElimination,
                playerCount: 32,
              ),
            ),
          ],
        ),

        // ── No Dojang Separation ──
        const SizedBox(height: 32),
        _buildSectionHeader(theme, 'No Dojang Separation', theme.colorScheme.tertiary),
        const SizedBox(height: 4),
        Text(
          'Brackets seeded without dojang-based separation logic.',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _DemoCard(
              icon: Icons.shuffle,
              title: 'SE · 8 Players',
              subtitle: 'Random seed, no separation',
              accentColor: Colors.grey.shade800,
              onTap: () => _navigateToDemoBracketViewer(
                context,
                bracketFormat: BracketFormat.singleElimination,
                playerCount: 8,
                dojangSeparation: false,
              ),
            ),
            _DemoCard(
              icon: Icons.shuffle,
              title: 'SE · 32 Players',
              subtitle: 'Large draw, no separation',
              accentColor: Colors.grey.shade800,
              onTap: () => _navigateToDemoBracketViewer(
                context,
                bracketFormat: BracketFormat.singleElimination,
                playerCount: 32,
                dojangSeparation: false,
              ),
            ),
            _DemoCard(
              icon: Icons.shuffle,
              title: 'DE · 8 Players',
              subtitle: 'DE, no separation',
              accentColor: Colors.grey.shade800,
              onTap: () => _navigateToDemoBracketViewer(
                context,
                bracketFormat: BracketFormat.doubleElimination,
                playerCount: 8,
                dojangSeparation: false,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionHeader(
    ThemeData theme,
    String title,
    Color color,
  ) {
    return Text(
      title,
      style: theme.textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.w600,
        color: color,
      ),
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

// ─────────────────────────────────────────────────────────────────────────────
// Demo card
// ─────────────────────────────────────────────────────────────────────────────

class _DemoCard extends StatelessWidget {
  const _DemoCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.accentColor = Colors.grey,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color accentColor;

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
                Icon(icon, size: 36, color: accentColor),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
