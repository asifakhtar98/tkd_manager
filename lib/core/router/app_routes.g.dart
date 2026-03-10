// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
  $dashboardRoute,
  $setupRoute,
  $tournamentDetailRoute,
  $bracketRoute,
];

RouteBase get $dashboardRoute =>
    GoRouteData.$route(path: '/', factory: $DashboardRoute._fromState);

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

RouteBase get $setupRoute =>
    GoRouteData.$route(path: '/setup', factory: $SetupRoute._fromState);

mixin $SetupRoute on GoRouteData {
  static SetupRoute _fromState(GoRouterState state) =>
      SetupRoute(tournamentId: state.uri.queryParameters['tournament-id']);

  SetupRoute get _self => this as SetupRoute;

  @override
  String get location => GoRouteData.$location(
    '/setup',
    queryParams: {
      if (_self.tournamentId != null) 'tournament-id': _self.tournamentId,
    },
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

RouteBase get $tournamentDetailRoute => GoRouteData.$route(
  path: '/tournament/:tournamentId',
  factory: $TournamentDetailRoute._fromState,
);

mixin $TournamentDetailRoute on GoRouteData {
  static TournamentDetailRoute _fromState(GoRouterState state) =>
      TournamentDetailRoute(
        tournamentId: state.pathParameters['tournamentId']!,
      );

  TournamentDetailRoute get _self => this as TournamentDetailRoute;

  @override
  String get location => GoRouteData.$location(
    '/tournament/${Uri.encodeComponent(_self.tournamentId)}',
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

RouteBase get $bracketRoute =>
    GoRouteData.$route(path: '/bracket', factory: $BracketRoute._fromState);

mixin $BracketRoute on GoRouteData {
  static BracketRoute _fromState(GoRouterState state) =>
      BracketRoute($extra: state.extra as BracketRouteExtra);

  BracketRoute get _self => this as BracketRoute;

  @override
  String get location => GoRouteData.$location('/bracket');

  @override
  void go(BuildContext context) => context.go(location, extra: _self.$extra);

  @override
  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: _self.$extra);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: _self.$extra);

  @override
  void replace(BuildContext context) =>
      context.replace(location, extra: _self.$extra);
}
