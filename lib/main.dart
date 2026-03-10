import 'package:flutter/material.dart';
import 'package:tkd_saas/core/di/injection.dart';
import 'package:tkd_saas/core/router/app_router.dart';
import 'package:tkd_saas/core/theme/app_theme.dart';

void main() {
  configureDependencies();
  runApp(const TkdTournamentApp());
}

class TkdTournamentApp extends StatelessWidget {
  const TkdTournamentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'TKD Tournament Manager',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: AppRouter.createRouter(),
    );
  }
}
