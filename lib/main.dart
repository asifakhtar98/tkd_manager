import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tkd_saas/core/di/injection.dart';
import 'package:tkd_saas/core/router/app_router.dart';
import 'package:tkd_saas/core/theme/app_theme.dart';
import 'package:tkd_saas/features/auth/presentation/bloc/authentication_bloc.dart';
import 'package:tkd_saas/features/tournament/presentation/bloc/tournament_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://lldlunqzkltclpfzpjxh.supabase.co',
    anonKey: 'sb_publishable_Kf90GkwrSzNySWSCqhJT8Q_9b94d-UM',
  );

  configureDependencies();

  runApp(const TkdTournamentApp());
}

class TkdTournamentApp extends StatelessWidget {
  const TkdTournamentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (_) => getIt<AuthenticationBloc>()
            ..add(const AuthenticationSubscriptionRequested()),
        ),
        BlocProvider<TournamentBloc>(
          create: (_) => getIt<TournamentBloc>(),
        ),
      ],
      child: Builder(
        builder: (BuildContext context) {
          // The router must be created inside the widget tree so it can
          // access the AuthenticationBloc for redirect decisions.
          final AuthenticationBloc authenticationBloc =
              context.read<AuthenticationBloc>();

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
