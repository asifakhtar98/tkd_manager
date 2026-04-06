import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tkd_saas/core/di/injection.dart';
import 'package:tkd_saas/features/auth/presentation/screens/email_confirmed_screen.dart';
import 'package:tkd_saas/features/auth/presentation/screens/login_screen.dart';
import 'package:tkd_saas/features/auth/presentation/screens/password_reset_screen.dart';
import 'package:tkd_saas/features/bracket/presentation/bloc/bracket_bloc.dart';
import 'package:tkd_saas/features/bracket/presentation/bloc/bracket_theme_preset_bloc.dart';
import 'package:tkd_saas/features/bracket/presentation/bloc/bracket_theme_preset_event.dart';
import 'package:tkd_saas/features/bracket/presentation/bloc/bracket_theme_selection_bloc.dart';
import 'package:tkd_saas/features/bracket/presentation/screens/bracket_viewer_screen.dart';
import 'package:tkd_saas/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:tkd_saas/features/setup_bracket/presentation/bloc/setup_bracket_bloc.dart';
import 'package:tkd_saas/features/setup_bracket/presentation/screens/setup_bracket_screen.dart';
import 'package:tkd_saas/features/tournament/domain/entities/bracket_snapshot.dart';
import 'package:tkd_saas/features/tournament/domain/entities/tournament_entity.dart';
import 'package:tkd_saas/features/tournament/presentation/bloc/tournament_bloc.dart';
import 'package:tkd_saas/features/tournament/presentation/screens/tournament_detail_screen.dart';
import 'package:tkd_saas/features/activation/presentation/screens/activate_software_screen.dart';
import 'package:tkd_saas/features/admin_panel/presentation/screens/admin_activation_screen.dart';
import 'package:tkd_saas/features/admin_panel/presentation/screens/admin_dashboard_screen.dart';
import 'package:tkd_saas/features/profile/presentation/screens/profile_screen.dart';
import 'package:tkd_saas/features/invoice/presentation/screens/invoice_generator_screen.dart';

export 'package:tkd_saas/features/bracket/domain/entities/bracket_format.dart';

part 'app_routes.g.dart';

/// Compile-safe route path constants.
///
/// Use these instead of raw strings (e.g. `'/login'`) in redirect guards
/// and programmatic navigation so typos become compiler errors.
abstract final class RoutePaths {
  static const String dashboard = '/';
  static const String login = '/login';
  static const String resetPassword = '/reset-password';
  static const String emailConfirmed = '/email-confirmed';

  /// Builds a tournament detail path:  `/tournaments/<id>`
  static String tournamentDetail(String tournamentId) =>
      '/tournaments/$tournamentId';

  /// Builds a bracket setup path:  `/tournaments/<id>/setup`
  static String bracketSetup(String tournamentId) =>
      '/tournaments/$tournamentId/setup';

  /// Builds a bracket viewer path:  `/tournaments/<tId>/brackets/<sId>`
  static String bracketViewer({
    required String tournamentId,
    required String snapshotId,
  }) => '/tournaments/$tournamentId/brackets/$snapshotId';

  /// Builds the activation software path `/activate`
  static const String activate = '/activate';

  /// Admin panel route path `/admin`
  static const String admin = '/admin';

  /// Profile route path `/profile`
  static const String profile = '/profile';

  /// Invoice generator route path `/invoice`
  static const String invoice = '/invoice';
}

@TypedGoRoute<LoginRoute>(path: '/login')
@immutable
class LoginRoute extends GoRouteData with $LoginRoute {
  const LoginRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const LoginScreen();
}

@TypedGoRoute<PasswordResetRoute>(path: '/reset-password')
@immutable
class PasswordResetRoute extends GoRouteData with $PasswordResetRoute {
  const PasswordResetRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const PasswordResetScreen();
}

@TypedGoRoute<EmailConfirmedRoute>(path: '/email-confirmed')
@immutable
class EmailConfirmedRoute extends GoRouteData with $EmailConfirmedRoute {
  const EmailConfirmedRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const EmailConfirmedScreen();
}

@TypedGoRoute<ActivateRoute>(path: '/activate')
@immutable
class ActivateRoute extends GoRouteData with $ActivateRoute {
  const ActivateRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ActivateSoftwareScreen();
}

@TypedGoRoute<AdminRoute>(
  path: '/admin',
  routes: <TypedGoRoute<GoRouteData>>[
    TypedGoRoute<AdminActivationRequestsRoute>(path: 'activations'),
  ],
)
@immutable
class AdminRoute extends GoRouteData with $AdminRoute {
  const AdminRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const AdminDashboardScreen();
}

@immutable
class AdminActivationRequestsRoute extends GoRouteData with $AdminActivationRequestsRoute {
  const AdminActivationRequestsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const AdminActivationScreen();
}

@TypedGoRoute<ProfileRoute>(path: '/profile')
@immutable
class ProfileRoute extends GoRouteData with $ProfileRoute {
  const ProfileRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ProfileScreen();
}

@TypedGoRoute<InvoiceRoute>(path: '/invoice')
@immutable
class InvoiceRoute extends GoRouteData with $InvoiceRoute {
  const InvoiceRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const InvoiceGeneratorScreen();
}

@TypedGoRoute<DashboardRoute>(
  path: '/',
  routes: <TypedGoRoute<GoRouteData>>[
    TypedGoRoute<TournamentDetailRoute>(
      path: 'tournaments/:tournamentId',
      routes: <TypedGoRoute<GoRouteData>>[
        TypedGoRoute<BracketSetupRoute>(path: 'setup'),
        TypedGoRoute<BracketViewerRoute>(path: 'brackets/:snapshotId'),
      ],
    ),
  ],
)
@immutable
class DashboardRoute extends GoRouteData with $DashboardRoute {
  const DashboardRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const DashboardScreen();
}

@immutable
class TournamentDetailRoute extends GoRouteData with $TournamentDetailRoute {
  const TournamentDetailRoute({required this.tournamentId});

  final String tournamentId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      TournamentDetailScreen(tournamentId: tournamentId);
}

@immutable
class BracketSetupRoute extends GoRouteData with $BracketSetupRoute {
  const BracketSetupRoute({required this.tournamentId});

  /// The owning tournament — inherited from the parent path segment.
  final String tournamentId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      BlocProvider<SetupBracketBloc>(
        create: (_) => getIt<SetupBracketBloc>(param1: tournamentId),
        child: SetupBracketScreen(tournamentId: tournamentId),
      );
}

@immutable
class BracketViewerRoute extends GoRouteData with $BracketViewerRoute {
  const BracketViewerRoute({
    required this.tournamentId,
    required this.snapshotId,
  });

  final String tournamentId;
  final String snapshotId;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return BlocBuilder<TournamentBloc, TournamentState>(
      builder: (context, tournamentState) {
        if (tournamentState.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final TournamentEntity? tournament = tournamentState.tournaments
            .where((t) => t.id == tournamentId)
            .firstOrNull;
        final BracketSnapshot? snapshot = tournamentState
            .bracketsFor(tournamentId)
            .where((s) => s.id == snapshotId)
            .firstOrNull;

        if (tournament == null || snapshot == null) {
          return _BracketNotFoundPage(tournamentId: tournamentId);
        }

        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) =>
                  getIt<BracketBloc>()
                    ..add(BracketEvent.loadFromSnapshotRequested(snapshot)),
            ),
            BlocProvider(
              create: (_) =>
                  getIt<BracketThemePresetBloc>()
                    ..add(const BracketThemePresetEvent.loadRequested()),
            ),
            BlocProvider(create: (_) => getIt<BracketThemeSelectionBloc>()),
          ],
          child: BracketViewerScreen(
            tournament: tournament,
            snapshot: snapshot,
          ),
        );
      },
    );
  }
}

/// Shown when a bracket URL cannot be resolved — either the tournament or the
/// snapshot is missing from the current [TournamentBloc] state.
///
/// Navigates the user back to the parent tournament (if it exists) or to the
/// dashboard as a last resort.
class _BracketNotFoundPage extends StatelessWidget {
  const _BracketNotFoundPage({required this.tournamentId});

  final String tournamentId;

  @override
  Widget build(BuildContext context) {
    final tournamentExists = context
        .read<TournamentBloc>()
        .state
        .tournaments
        .any((t) => t.id == tournamentId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bracket Not Found'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => tournamentExists
              ? TournamentDetailRoute(tournamentId: tournamentId).go(context)
              : const DashboardRoute().go(context),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.link_off, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            const Text(
              'This bracket could not be found.\n'
              'It may have been deleted or the URL is invalid.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              icon: const Icon(Icons.arrow_back),
              label: Text(
                tournamentExists ? 'Back to Tournament' : 'Go to Dashboard',
              ),
              onPressed: () => tournamentExists
                  ? TournamentDetailRoute(
                      tournamentId: tournamentId,
                    ).go(context)
                  : const DashboardRoute().go(context),
            ),
          ],
        ),
      ),
    );
  }
}
