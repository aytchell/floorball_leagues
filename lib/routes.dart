import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'ui/views/landing/landing_page.dart';
import 'ui/views/league_details_2/league_details_page_2.dart';
import 'ui/views/leagues_list/leagues_list_page.dart';
import 'ui/views/season_selector/season_selector_page.dart';

part 'routes.g.dart';

@TypedGoRoute<LeaguesListPageRoute>(path: LeaguesListPage.routePath)
@immutable
class LeaguesListPageRoute extends GoRouteData with $LeaguesListPageRoute {
  final int gameOperationId;

  const LeaguesListPageRoute({required this.gameOperationId});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return LeaguesListPage(gameOperationId: gameOperationId);
  }
}

@TypedGoRoute<LeagueDetailsPageRoute>(path: LeagueDetailsPage2.routePath)
@immutable
class LeagueDetailsPageRoute extends GoRouteData with $LeagueDetailsPageRoute {
  final int leagueId;
  final String leagueName;

  const LeagueDetailsPageRoute({
    required this.leagueId,
    required this.leagueName,
  });

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return LeagueDetailsPage2(leagueId: leagueId, leagueName: leagueName);
  }
}

GoRouter buildRouter() => GoRouter(
  initialLocation: LandingPage.routePath,
  routes: [
    GoRoute(
      path: LandingPage.routePath,
      builder: (context, state) => LandingPage(),
    ),
    GoRoute(
      path: SeasonSelectorPage.routePath,
      builder: (context, state) => SeasonSelectorPage(),
    ),
    ...$appRoutes,
  ],
);
