import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'ui/views/game_details/game_detail_page.dart';
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
  NoTransitionPage buildPage(BuildContext context, GoRouterState state) {
    return NoTransitionPage(
      key: state.pageKey,
      child: LeaguesListPage(gameOperationId: gameOperationId),
    );
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
  NoTransitionPage buildPage(BuildContext context, GoRouterState state) {
    return NoTransitionPage(
      key: state.pageKey,
      child: LeagueDetailsPage2(leagueId: leagueId, leagueName: leagueName),
    );
  }
}

@TypedGoRoute<GameDetailPageRoute>(path: GameDetailPage.routePath)
@immutable
class GameDetailPageRoute extends GoRouteData with $GameDetailPageRoute {
  final int gameId;
  final String? leagueName;

  const GameDetailPageRoute({required this.gameId, this.leagueName});

  @override
  NoTransitionPage buildPage(BuildContext context, GoRouterState state) {
    return NoTransitionPage(
      key: state.pageKey,
      child: GameDetailPage(gameId: gameId, leagueName: leagueName),
    );
  }
}

GoRouter buildRouter() => GoRouter(
  initialLocation: LandingPage.routePath,
  routes: [
    GoRoute(
      path: LandingPage.routePath,
      pageBuilder: (context, state) =>
          NoTransitionPage(key: state.pageKey, child: LandingPage()),
    ),
    GoRoute(
      path: SeasonSelectorPage.routePath,
      pageBuilder: (context, state) =>
          NoTransitionPage(key: state.pageKey, child: SeasonSelectorPage()),
    ),
    ...$appRoutes,
  ],
);
