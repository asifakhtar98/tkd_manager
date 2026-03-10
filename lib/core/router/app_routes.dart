import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tkd_saas/core/di/injection.dart';
import 'package:tkd_saas/features/bracket/domain/entities/tournament_info.dart';
import 'package:tkd_saas/features/bracket/presentation/bloc/bracket_bloc.dart';
import 'package:tkd_saas/features/bracket/presentation/screens/bracket_viewer_screen.dart';
import 'package:tkd_saas/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:tkd_saas/features/participant/domain/entities/participant_entity.dart';
import 'package:tkd_saas/features/participant/presentation/screens/participant_entry_screen.dart';

part 'app_routes.g.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Route definitions — annotated for go_router_builder code generation.
// Run: dart run build_runner build --delete-conflicting-outputs
// ─────────────────────────────────────────────────────────────────────────────

@TypedGoRoute<DashboardRoute>(path: '/')
@immutable
class DashboardRoute extends GoRouteData with $DashboardRoute {
  const DashboardRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const DashboardScreen();
}

@TypedGoRoute<SetupRoute>(path: '/setup')
@immutable
class SetupRoute extends GoRouteData with $SetupRoute {
  const SetupRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ParticipantEntryScreen();
}

/// Extra data passed to the bracket route.
/// Bundles all complex objects so go_router_builder can route via `$extra`.
class BracketRouteExtra {
  const BracketRouteExtra({
    required this.participants,
    required this.dojangSeparation,
    required this.format,
    required this.includeThirdPlaceMatch,
    this.tournamentInfo,
  });

  final List<ParticipantEntity> participants;
  final bool dojangSeparation;
  final String format;
  final bool includeThirdPlaceMatch;
  final TournamentInfo? tournamentInfo;
}

@TypedGoRoute<BracketRoute>(path: '/bracket')
@immutable
class BracketRoute extends GoRouteData with $BracketRoute {
  const BracketRoute({required this.$extra});

  /// All complex bracket params passed as a single typed extra object.
  final BracketRouteExtra $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return BlocProvider(
      create: (_) => getIt<BracketBloc>()
        ..add(BracketGenerateRequested(
          participants: $extra.participants,
          format: $extra.format,
          dojangSeparation: $extra.dojangSeparation,
          includeThirdPlaceMatch: $extra.includeThirdPlaceMatch,
        )),
      child: BracketViewerScreen(
        participants: $extra.participants,
        dojangSeparation: $extra.dojangSeparation,
        format: $extra.format,
        includeThirdPlaceMatch: $extra.includeThirdPlaceMatch,
        tournamentInfo: $extra.tournamentInfo,
      ),
    );
  }
}
