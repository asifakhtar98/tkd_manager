import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tkd_saas/core/di/injection.dart';
import 'package:tkd_saas/features/bracket/presentation/bloc/bracket_bloc.dart';
import 'package:tkd_saas/features/bracket/presentation/screens/bracket_viewer_screen.dart';
import 'package:tkd_saas/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:tkd_saas/features/participant/domain/entities/participant_entity.dart';
import 'package:tkd_saas/features/participant/presentation/screens/participant_entry_screen.dart';
import 'package:tkd_saas/features/tournament/domain/entities/tournament_entity.dart';
import 'package:tkd_saas/features/tournament/presentation/screens/tournament_detail_screen.dart';

part 'app_routes.g.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Bracket format — type-safe enum replacing raw 'Single Elimination' /
// 'Double Elimination' strings throughout the codebase.
// ─────────────────────────────────────────────────────────────────────────────

/// The elimination format used to generate a bracket.
///
/// Every bracket-related screen, BLoC event, and snapshot references this enum
/// instead of a raw string, giving compile-time safety and a single source of
/// truth for display labels.
enum BracketFormat {
  /// Standard single-elimination (knockout) tournament.
  singleElimination('Single Elimination'),

  /// Double-elimination tournament with winners / losers brackets and grand
  /// finals.
  doubleElimination('Double Elimination');

  const BracketFormat(this.displayLabel);

  /// Human-readable label used in UI text, PDF headers, and snapshot labels.
  final String displayLabel;
}

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
  const SetupRoute({this.tournamentId});

  /// When provided, the participant entry screen pre-selects this tournament.
  final String? tournamentId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      ParticipantEntryScreen(tournamentId: tournamentId);
}

@TypedGoRoute<TournamentDetailRoute>(path: '/tournament/:tournamentId')
@immutable
class TournamentDetailRoute extends GoRouteData with $TournamentDetailRoute {
  const TournamentDetailRoute({required this.tournamentId});

  final String tournamentId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      TournamentDetailScreen(tournamentId: tournamentId);
}

/// Extra data passed to the bracket route.
///
/// Bundles all complex objects so go_router_builder can route via `$extra`.
class BracketRouteExtra {
  const BracketRouteExtra({
    required this.participants,
    required this.dojangSeparation,
    required this.bracketFormat,
    required this.includeThirdPlaceMatch,
    this.tournament,
    this.isHistoryView = false,
  });

  final List<ParticipantEntity> participants;
  final bool dojangSeparation;

  /// The elimination format for this bracket.
  final BracketFormat bracketFormat;

  final bool includeThirdPlaceMatch;

  /// The owning tournament — null only for demo/legacy paths.
  final TournamentEntity? tournament;

  /// When true, the bracket is being replayed from history — the viewer
  /// must NOT save a new [BracketSnapshot] so history stays clean.
  final bool isHistoryView;
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
        ..add(
          BracketGenerateRequested(
            participants: $extra.participants,
            bracketFormat: $extra.bracketFormat,
            dojangSeparation: $extra.dojangSeparation,
            includeThirdPlaceMatch: $extra.includeThirdPlaceMatch,
          ),
        ),
      child: BracketViewerScreen(
        participants: $extra.participants,
        dojangSeparation: $extra.dojangSeparation,
        bracketFormat: $extra.bracketFormat,
        includeThirdPlaceMatch: $extra.includeThirdPlaceMatch,
        tournament: $extra.tournament,
        isHistoryView: $extra.isHistoryView,
      ),
    );
  }
}
