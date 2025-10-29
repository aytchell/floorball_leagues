import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:floorball/selected_season_cubit.dart';
import 'package:floorball/api/saisonmanager.dart';
import 'package:floorball/ui/views/landing/landing_page.dart';
import 'package:floorball/ui/views/season_selector/season_selector_page.dart';
import 'package:floorball/app_state.dart';

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
      builder: (context, state) => LandingPage(manager: SaisonManager.init()),
    ),
    GoRoute(
      path: SeasonSelectorPage.routePath,
      builder: (context, state) => SeasonSelectorPage(),
    ),
  ],
);

void main() {
  setupLogging();
  runApp(ChangeNotifierProvider(create: (_) => AppState(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final ApiRepository apiRepository = ApiRepository();
  final AvailableSeasonsCubit availableSeasonsCubit = AvailableSeasonsCubit();
  final AvailableOperationsCubit availableOperationsCubit =
      AvailableOperationsCubit();
  final SelectedSeasonCubit selectedSeasonCubit = SelectedSeasonCubit();

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
          log.info(
            'Setting current season "${selectedSeason.name}" with id "${selectedSeason.id}"',
          );
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
    if (!found.isEmpty) {
      // This should normally yield the current season
      return found.first;
    }

    // fallback if 'currentSeasonId' wasn't found
    return _latestSeason(seasons);
  }

  SeasonInfo _latestSeason(List<SeasonInfo> seasons) {
    SeasonInfo latest = seasons.first;
    seasons.forEach((season) {
      if (season.id > latest.id) {
        latest = season;
      }
    });

    return latest;
  }
}
