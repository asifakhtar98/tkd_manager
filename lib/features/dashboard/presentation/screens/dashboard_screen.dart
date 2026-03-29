import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tkd_saas/core/config/app_config.dart';
import 'package:tkd_saas/core/router/app_routes.dart';
import 'package:tkd_saas/features/activation/domain/entities/activation_status.dart';
import 'package:tkd_saas/features/activation/presentation/bloc/activation_status_bloc.dart';
import 'package:tkd_saas/features/activation/presentation/bloc/activation_status_state.dart';
import 'package:tkd_saas/features/tournament/domain/entities/tournament_entity.dart';
import 'package:tkd_saas/features/tournament/presentation/bloc/tournament_bloc.dart';
import 'package:tkd_saas/features/tournament/presentation/widgets/create_tournament_dialog.dart';

import 'package:tkd_saas/features/activation/presentation/widgets/activation_guard_builder.dart';

/// Main dashboard showing tournaments, activation status, and a sign-out action.
///
/// This is the default route for authenticated users. The pre-seeded
/// "Demo Tournament" appears in the tournament list like any other
/// tournament — users click into it to access its demo brackets.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _DashboardScreenBody();
  }
}

class _DashboardScreenBody extends StatefulWidget {
  const _DashboardScreenBody();

  @override
  State<_DashboardScreenBody> createState() => _DashboardScreenBodyState();
}

class _DashboardScreenBodyState extends State<_DashboardScreenBody> {
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
            BlocBuilder<ActivationStatusBloc, ActivationStatusState>(
              buildWhen: (previous, current) =>
                  previous.isAdmin != current.isAdmin,
              builder: (context, activationStatusState) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (activationStatusState.isAdmin)
                      IconButton(
                        tooltip: 'Admin Panel',
                        icon: const Icon(Icons.admin_panel_settings),
                        onPressed: () => const AdminRoute().go(context),
                      ),
                    IconButton(
                      tooltip: 'My Profile',
                      icon: const Icon(Icons.account_circle),
                      onPressed: () => const ProfileRoute().go(context),
                    ),
                  ],
                );
              },
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
          if (state.lastMutationError != null &&
              state.lastMutationError!.isNotEmpty) {
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
            if (scrollInfo.metrics.pixels >=
                scrollInfo.metrics.maxScrollExtent - 200) {
              context.read<TournamentBloc>().add(
                const TournamentEvent.loadMoreRequested(),
              );
            }
            return false;
          },
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _ActivationStatusBanner(),
                    const SizedBox(height: 16),
                    _buildTournamentSection(context, theme),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
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
                ActivationGuardBuilder(
                  builder: (context, isLocked) => FilledButton.icon(
                    icon: state.isSaving
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : (isLocked
                              ? const Icon(Icons.lock)
                              : const Icon(Icons.add)),
                    label: const Text('New Tournament'),
                    onPressed: state.isSaving || isLocked
                        ? null
                        : () => _showCreateDialog(context),
                  ),
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
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Activation Status Banner
// ─────────────────────────────────────────────────────────────────────────────

class _ActivationStatusBanner extends StatelessWidget {
  const _ActivationStatusBanner();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActivationStatusBloc, ActivationStatusState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const SizedBox.shrink();
        }

        final status = state.activationStatus;
        if (status == null) return const SizedBox.shrink();

        return switch (status) {
          ActivationStatusActive(:final expiresAt) => _buildActiveBanner(
            context,
            expiresAt,
          ),
          ActivationStatusPendingReview() => _buildPendingBanner(context),
          ActivationStatusNotActivated() => _buildNotActivatedBanner(context),
        };
      },
    );
  }

  Widget _buildActiveBanner(BuildContext context, DateTime expiresAt) {
    final dateFormat = DateFormat('dd MMM yyyy');
    final daysRemaining = expiresAt.difference(DateTime.now().toUtc()).inDays;

    return Card(
      color: Colors.green.shade50,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Icon(Icons.verified, color: Colors.green.shade700, size: 28),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Product Activated',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade800,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Active until ${dateFormat.format(expiresAt.toLocal())} ($daysRemaining days remaining)',
                    style: TextStyle(
                      color: Colors.green.shade700,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPendingBanner(BuildContext context) {
    return Card(
      color: Colors.amber.shade50,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Icon(Icons.hourglass_top, color: Colors.amber.shade800, size: 28),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Activation Request Pending',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.amber.shade900,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Your activation request is awaiting admin approval.',
                    style: TextStyle(
                      color: Colors.amber.shade800,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotActivatedBanner(BuildContext context) {
    return Card(
      color: Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Icon(Icons.lock_outline, color: Colors.grey.shade700, size: 28),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Software Not Activated',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Activate your software to unlock all features.',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            FilledButton.icon(
              icon: const Icon(Icons.rocket_launch, size: 18),
              label: const Text('Activate Now'),
              onPressed: () => const ActivateRoute().go(context),
            ),
          ],
        ),
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
