import 'package:floorball/repositories/team_repository.dart';
import 'package:floorball/ui/views/settings/settings_page.dart';
import 'package:floorball/ui/views/team_details/team_details_full_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'api/models/league.dart';
import 'ui/views/game_details/game_details_page.dart';
import 'ui/views/landing/landing_page.dart';
import 'ui/views/league_details/league_details_page.dart';
import 'ui/views/leagues_list/leagues_list_page.dart';
import 'ui/views/season_selector/season_selector_page.dart';
import 'ui/views/team_details/team_details_page.dart';

part 'routes.g.dart';

@TypedGoRoute<LeaguesListPageRoute>(path: LeaguesListPage.routePath)
@immutable
class LeaguesListPageRoute extends GoRouteData with $LeaguesListPageRoute {
  final int federationId;

  const LeaguesListPageRoute({required this.federationId});

  @override
  NoTransitionPage buildPage(BuildContext context, GoRouterState state) {
    return NoTransitionPage(
      key: state.pageKey,
      child: LeaguesListPage(federationId: federationId),
    );
  }
}

@TypedGoRoute<LeagueDetailsPageRoute>(path: LeagueDetailsPage.routePath)
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
      child: LeagueDetailsPage(leagueId: leagueId, leagueName: leagueName),
    );
  }
}

@TypedGoRoute<GameDetailsPageRoute>(path: GameDetailsPage.routePath)
@immutable
class GameDetailsPageRoute extends GoRouteData with $GameDetailsPageRoute {
  final int gameId;
  final LeagueType leagueType;
  final String? leagueName;

  const GameDetailsPageRoute({
    required this.gameId,
    required this.leagueType,
    this.leagueName,
  });

  @override
  NoTransitionPage buildPage(BuildContext context, GoRouterState state) {
    return NoTransitionPage(
      key: state.pageKey,
      child: GameDetailsPage(
        gameId: gameId,
        leagueType: leagueType,
        leagueName: leagueName,
      ),
    );
  }
}

@TypedGoRoute<TeamDetailsFullPageRoute>(path: TeamDetailsFullPage.routePath)
@immutable
class TeamDetailsFullPageRoute extends GoRouteData
    with $TeamDetailsFullPageRoute {
  final TeamInfo $extra;

  const TeamDetailsFullPageRoute({required this.$extra});

  @override
  NoTransitionPage buildPage(BuildContext context, GoRouterState state) {
    return NoTransitionPage(
      key: state.pageKey,
      child: TeamDetailsFullPage(data: $extra),
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
      path: SettingsPage.routePath,
      pageBuilder: (context, state) =>
          NoTransitionPage(key: state.pageKey, child: SettingsPage()),
    ),
    GoRoute(
      path: SeasonSelectorPage.routePath,
      pageBuilder: (context, state) =>
          NoTransitionPage(key: state.pageKey, child: SeasonSelectorPage()),
    ),
    ...$appRoutes,
  ],
);
