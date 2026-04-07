import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tkd_saas/core/config/app_config.dart';
import 'package:tkd_saas/core/di/injection.dart';
import 'package:tkd_saas/core/router/app_router.dart';
import 'package:tkd_saas/core/theme/app_theme.dart';
import 'package:tkd_saas/features/auth/presentation/bloc/authentication_bloc.dart';
import 'package:tkd_saas/features/tournament/presentation/bloc/tournament_bloc.dart';
import 'package:tkd_saas/features/activation/presentation/bloc/activation_status_bloc.dart';
import 'package:tkd_saas/features/activation/presentation/bloc/activation_status_event.dart';

import 'package:flutter_web_plugins/url_strategy.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory(
            (await getApplicationDocumentsDirectory()).path,
          ),
  );

  if (AppConfig.isAuthenticationEnabled) {
    try {
      await Supabase.initialize(
        url: 'https://lldlunqzkltclpfzpjxh.supabase.co',
        anonKey: 'sb_publishable_Kf90GkwrSzNySWSCqhJT8Q_9b94d-UM',
      );
    } catch (e, st) {
      log(
        'Critical Error: Supabase failed to initialize on app boot.',
        error: e,
        stackTrace: st,
      );
      // The application will mount, but any features dependent on SupabaseClient
      // may throw late evaluation exceptions if accessed.
    }
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
      if (AppConfig.isAuthenticationEnabled) ...[
        BlocProvider<AuthenticationBloc>(
          create: (_) =>
              getIt<AuthenticationBloc>()
                ..add(const AuthenticationSubscriptionRequested()),
        ),
        BlocProvider<ActivationStatusBloc>(
          create: (_) =>
              getIt<ActivationStatusBloc>()
                ..add(const ActivationStatusEvent.loadRequested()),
        ),
      ],
      BlocProvider<TournamentBloc>(
        create: (_) {
          final bloc = getIt<TournamentBloc>();
          if (!AppConfig.isAuthenticationEnabled) {
            bloc.add(const TournamentEvent.loadRequested());
          }
          return bloc;
        },
      ),
    ];

    return MultiBlocProvider(
      providers: blocProviders,
      child: Builder(
        builder: (BuildContext context) {
          final AuthenticationBloc? authenticationBloc =
              AppConfig.isAuthenticationEnabled
              ? context.read<AuthenticationBloc>()
              : null;

          Widget app = MaterialApp.router(
            title: 'GameCon Tournament Manager',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            routerConfig: AppRouter.createRouter(
              authenticationBloc: authenticationBloc,
            ),
          );

          if (authenticationBloc != null) {
            app = BlocListener<AuthenticationBloc, AuthenticationState>(
              listener: (context, state) {
                state.maybeWhen(
                  authenticated: (_) {
                    context.read<TournamentBloc>().add(
                      const TournamentEvent.loadRequested(),
                    );
                    context.read<ActivationStatusBloc>().add(
                      const ActivationStatusEvent.loadRequested(),
                    );
                  },
                  unauthenticated: () {
                    context.read<TournamentBloc>().add(
                      const TournamentEvent.clearRequested(),
                    );
                    context.read<ActivationStatusBloc>().add(
                      const ActivationStatusEvent.clearRequested(),
                    );
                  },
                  orElse: () {},
                );
              },
              child: app,
            );
          }

          return app;
        },
      ),
    );
  }
}
