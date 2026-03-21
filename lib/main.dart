import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tkd_saas/core/config/app_config.dart';
import 'package:tkd_saas/core/di/injection.dart';
import 'package:tkd_saas/core/router/app_router.dart';
import 'package:tkd_saas/core/theme/app_theme.dart';
import 'package:tkd_saas/features/auth/presentation/bloc/authentication_bloc.dart';
import 'package:tkd_saas/features/tournament/presentation/bloc/tournament_bloc.dart';

import 'package:flutter_web_plugins/url_strategy.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();

  if (AppConfig.isAuthenticationEnabled) {
    await Supabase.initialize(
      url: 'https://lldlunqzkltclpfzpjxh.supabase.co',
      anonKey: 'sb_publishable_Kf90GkwrSzNySWSCqhJT8Q_9b94d-UM',
    );
  }

  // DI must ALWAYS be wired — non-auth services (BracketBloc, Uuid,
  // bracket generators, TournamentBloc) are resolved throughout the app.
  // Auth-related registrations (SupabaseClient, AuthenticationRepository,
  // AuthenticationBloc) use lazySingletons/factories, so they won't
  // instantiate unless explicitly resolved.
  configureDependencies();

  runApp(const TkdTournamentApp());
}

class TkdTournamentApp extends StatelessWidget {
  const TkdTournamentApp({super.key});

  @override
  Widget build(BuildContext context) {
    // When auth is disabled, skip the AuthenticationBloc provider entirely
    // and pass null to the router so all redirect guards are bypassed.
    final List<BlocProvider> blocProviders = [
      if (AppConfig.isAuthenticationEnabled)
        BlocProvider<AuthenticationBloc>(
          create: (_) =>
              getIt<AuthenticationBloc>()
                ..add(const AuthenticationSubscriptionRequested()),
        ),
      BlocProvider<TournamentBloc>(create: (_) => getIt<TournamentBloc>()),
    ];

    return MultiBlocProvider(
      providers: blocProviders,
      child: Builder(
        builder: (BuildContext context) {
          final AuthenticationBloc? authenticationBloc =
              AppConfig.isAuthenticationEnabled
              ? context.read<AuthenticationBloc>()
              : null;

          return MaterialApp.router(
            title: 'TKD Tournament Manager',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            routerConfig: AppRouter.createRouter(
              authenticationBloc: authenticationBloc,
            ),
          );
        },
      ),
    );
  }
}
