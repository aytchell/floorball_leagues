import 'package:floorball/api/blocs/detailed_games_cubit.dart';
import 'package:floorball/api/blocs/league_game_day_cubit.dart';
import 'package:floorball/api/blocs/league_table_cubit.dart';
import 'package:floorball/api/blocs/leagues_cubit.dart';
import 'package:floorball/api/blocs/scorer_cubit.dart';
import 'package:floorball/ui/views/leagues_list/leagues_list_page_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:logging/logging.dart';
import 'package:go_router/go_router.dart';

import 'package:floorball/selected_season_cubit.dart';
import 'package:floorball/ui/views/landing/landing_page.dart';
import 'package:floorball/ui/views/season_selector/season_selector_page.dart';

import 'package:floorball/api/api_repository.dart';
import 'package:floorball/api/blocs/available_seasons_cubit.dart';
import 'package:floorball/api/blocs/game_operations_cubit.dart';

import 'api/models/season_info.dart';

final log = Logger('Main');

void setupLogging() {
  // Configure logging level and output
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });
}

final _router = GoRouter(
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

void main() {
  setupLogging();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final apiRepository = ApiRepository();
  final availableSeasonsCubit = AvailableSeasonsCubit();
  final availableOperationsCubit = AvailableOperationsCubit();
  final selectedSeasonCubit = SelectedSeasonCubit();
  late final leaguesCubit = LeaguesCubit(apiRepository);
  late final leagueGameDayCubit = LeagueGameDayCubit(apiRepository);
  late final scorerCubit = ScorerCubit(apiRepository);
  late final leagueTableCubit = LeagueTableCubit(apiRepository);
  late final detailedGamesCubit = DetailedGamesCubit(apiRepository);

  @override
  Widget build(BuildContext context) {
    _fetchInitialData();

    return MultiRepositoryProvider(
      providers: [RepositoryProvider.value(value: apiRepository)],
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: availableSeasonsCubit),
          BlocProvider.value(value: availableOperationsCubit),
          BlocProvider.value(value: selectedSeasonCubit),
          BlocProvider.value(value: leaguesCubit),
          BlocProvider.value(value: leagueGameDayCubit),
          BlocProvider.value(value: scorerCubit),
          BlocProvider.value(value: leagueTableCubit),
          BlocProvider.value(value: detailedGamesCubit),
        ],
        child: MaterialApp.router(
          title: 'Game Operations Grid',
          theme: ThemeData(
            fontFamily: 'NimbusSans',
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          routerConfig: _router,
        ),
      ),
    );
  }

  void _fetchInitialData() {
    log.info("Triggering download of initial data");
    apiRepository.getStart().then(
      (stream) => stream.listen((entry) {
        log.info("Received initial data");
        log.info("Storing ${entry.gameOperations.length} game operations");
        availableOperationsCubit.setOperations(entry.gameOperations);
        log.info("Storing ${entry.seasons.length} available seasons");
        availableSeasonsCubit.setSeasons(entry.seasons);
        final selectedSeason = _findCurrentSeason(
          entry.seasons,
          entry.currentSeasonId,
        );
        if (selectedSeason != null) {
          selectedSeasonCubit.seasonSelected(selectedSeason);
        }
      }),
    );
  }

  SeasonInfo? _findCurrentSeason(
    List<SeasonInfo> seasons,
    int? currentSeasonId,
  ) {
    if (seasons.isEmpty) {
      return null;
    }

    final found = seasons.where((s) => s.id == currentSeasonId);
    if (found.isNotEmpty) {
      // This should normally yield the current season
      return found.first;
    }

    // fallback if 'currentSeasonId' wasn't found
    return _latestSeason(seasons);
  }

  SeasonInfo _latestSeason(List<SeasonInfo> seasons) {
    SeasonInfo latest = seasons.first;
    for (var season in seasons) {
      if (season.id > latest.id) {
        latest = season;
      }
    }

    return latest;
  }
}
