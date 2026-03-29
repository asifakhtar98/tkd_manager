// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
  $loginRoute,
  $passwordResetRoute,
  $emailConfirmedRoute,
  $activateRoute,
  $adminRoute,
  $profileRoute,
  $dashboardRoute,
];

RouteBase get $loginRoute =>
    GoRouteData.$route(path: '/login', factory: $LoginRoute._fromState);

mixin $LoginRoute on GoRouteData {
  static LoginRoute _fromState(GoRouterState state) => const LoginRoute();

  @override
  String get location => GoRouteData.$location('/login');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $passwordResetRoute => GoRouteData.$route(
  path: '/reset-password',
  factory: $PasswordResetRoute._fromState,
);

mixin $PasswordResetRoute on GoRouteData {
  static PasswordResetRoute _fromState(GoRouterState state) =>
      const PasswordResetRoute();

  @override
  String get location => GoRouteData.$location('/reset-password');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $emailConfirmedRoute => GoRouteData.$route(
  path: '/email-confirmed',
  factory: $EmailConfirmedRoute._fromState,
);

mixin $EmailConfirmedRoute on GoRouteData {
  static EmailConfirmedRoute _fromState(GoRouterState state) =>
      const EmailConfirmedRoute();

  @override
  String get location => GoRouteData.$location('/email-confirmed');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $activateRoute =>
    GoRouteData.$route(path: '/activate', factory: $ActivateRoute._fromState);

mixin $ActivateRoute on GoRouteData {
  static ActivateRoute _fromState(GoRouterState state) => const ActivateRoute();

  @override
  String get location => GoRouteData.$location('/activate');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $adminRoute =>
    GoRouteData.$route(path: '/admin', factory: $AdminRoute._fromState);

mixin $AdminRoute on GoRouteData {
  static AdminRoute _fromState(GoRouterState state) => const AdminRoute();

  @override
  String get location => GoRouteData.$location('/admin');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $profileRoute =>
    GoRouteData.$route(path: '/profile', factory: $ProfileRoute._fromState);

mixin $ProfileRoute on GoRouteData {
  static ProfileRoute _fromState(GoRouterState state) => const ProfileRoute();

  @override
  String get location => GoRouteData.$location('/profile');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $dashboardRoute => GoRouteData.$route(
  path: '/',
  factory: $DashboardRoute._fromState,
  routes: [
    GoRouteData.$route(
      path: 'tournaments/:tournamentId',
      factory: $TournamentDetailRoute._fromState,
      routes: [
        GoRouteData.$route(
          path: 'setup',
          factory: $BracketSetupRoute._fromState,
        ),
        GoRouteData.$route(
          path: 'brackets/:snapshotId',
          factory: $BracketViewerRoute._fromState,
        ),
      ],
    ),
  ],
);

mixin $DashboardRoute on GoRouteData {
  static DashboardRoute _fromState(GoRouterState state) =>
      const DashboardRoute();

  @override
  String get location => GoRouteData.$location('/');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $TournamentDetailRoute on GoRouteData {
  static TournamentDetailRoute _fromState(GoRouterState state) =>
      TournamentDetailRoute(
        tournamentId: state.pathParameters['tournamentId']!,
      );

  TournamentDetailRoute get _self => this as TournamentDetailRoute;

  @override
  String get location => GoRouteData.$location(
    '/tournaments/${Uri.encodeComponent(_self.tournamentId)}',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $BracketSetupRoute on GoRouteData {
  static BracketSetupRoute _fromState(GoRouterState state) =>
      BracketSetupRoute(tournamentId: state.pathParameters['tournamentId']!);

  BracketSetupRoute get _self => this as BracketSetupRoute;

  @override
  String get location => GoRouteData.$location(
    '/tournaments/${Uri.encodeComponent(_self.tournamentId)}/setup',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $BracketViewerRoute on GoRouteData {
  static BracketViewerRoute _fromState(GoRouterState state) =>
      BracketViewerRoute(
        tournamentId: state.pathParameters['tournamentId']!,
        snapshotId: state.pathParameters['snapshotId']!,
      );

  BracketViewerRoute get _self => this as BracketViewerRoute;

  @override
  String get location => GoRouteData.$location(
    '/tournaments/${Uri.encodeComponent(_self.tournamentId)}/brackets/${Uri.encodeComponent(_self.snapshotId)}',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}
