import 'package:floorball/ui/views/leagues_list/leagues_list_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'leagues_list_page_route.g.dart';

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
