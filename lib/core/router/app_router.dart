import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tkd_saas/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:tkd_saas/features/participant/presentation/screens/participant_entry_screen.dart';
import 'package:tkd_saas/features/bracket/presentation/screens/bracket_viewer_screen.dart';
import 'package:tkd_saas/features/participant/domain/entities/participant_entity.dart';
import 'package:tkd_saas/features/bracket/domain/entities/tournament_info.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  // Use a factory method to ensure tests get a fresh router instance
  static GoRouter createRouter() => GoRouter(
    navigatorKey: GlobalKey<NavigatorState>(), // Use a fresh key too
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/setup',
        builder: (context, state) => const ParticipantEntryScreen(),
      ),
      GoRoute(
        path: '/bracket',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          if (extra == null) {
            return const Scaffold(body: Center(child: Text('Error: No data provided for bracket')));
          }
          return BracketViewerScreen(
            participants: extra['participants'] as List<ParticipantEntity>,
            dojangSeparation: extra['dojangSeparation'] as bool,
            format: extra['format'] as String,
            includeThirdPlaceMatch: extra['includeThirdPlaceMatch'] as bool,
            tournamentInfo: extra['tournamentInfo'] as TournamentInfo?,
          );
        },
      ),
    ],
  );
}
