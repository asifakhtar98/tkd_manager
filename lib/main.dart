import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tkd_saas/core/di/injection.dart';
import 'package:tkd_saas/core/router/app_router.dart';
import 'package:tkd_saas/core/theme/app_theme.dart';
import 'package:tkd_saas/features/tournament/presentation/bloc/tournament_bloc.dart';

void main() {
  configureDependencies();
  runApp(const TkdTournamentApp());
}

class TkdTournamentApp extends StatelessWidget {
  const TkdTournamentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TournamentBloc>(
      // Provide the lazySingleton so all screens share the same instance.
      create: (_) => getIt<TournamentBloc>(),
      child: MaterialApp.router(
        title: 'TKD Tournament Manager',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        routerConfig: AppRouter.createRouter(),
      ),
    );
  }
}
