import 'package:floorball/repositories/api_repository.dart';
import 'package:floorball/api/models/season_info.dart';
import 'package:floorball/repositories/navigation_repository.dart';
import 'package:floorball/repositories/persistence_repository.dart';
import 'package:floorball/repositories/team_repository.dart';
import 'package:floorball/blocs/available_seasons_cubit.dart';
import 'package:floorball/blocs/champ_table_cubit.dart';
import 'package:floorball/blocs/detailed_games_cubit.dart';
import 'package:floorball/blocs/federations_cubit.dart';
import 'package:floorball/blocs/league_game_day_cubit.dart';
import 'package:floorball/blocs/league_table_cubit.dart';
import 'package:floorball/blocs/leagues_cubit.dart';
import 'package:floorball/blocs/navigation_app_cubit.dart';
import 'package:floorball/blocs/pinned_federations_cubit.dart';
import 'package:floorball/blocs/scorer_cubit.dart';
import 'package:floorball/blocs/selected_season_cubit.dart';
import 'package:floorball/blocs/team_info_cubit.dart';
import 'package:floorball/blocs/tick_cubit.dart';
import 'package:floorball/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

final log = Logger('Main');

void setupLogging() {
  // Configure logging level and output
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });
}

void main() {
  setupLogging();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final apiRepository = ApiRepository();
  late final teamRepository = TeamRepository(apiRepository);
  final persistenceRepository = PersistenceRepository();
  late final navigationRepository = NavigationRepository(persistenceRepository);

  final availableSeasonsCubit = AvailableSeasonsCubit();
  final availableFederationsCubit = AvailableFederationsCubit();
  final selectedSeasonCubit = SelectedSeasonCubit();
  late final leaguesCubit = LeaguesCubit(apiRepository);
  late final leagueGameDayCubit = LeagueGameDayCubit(apiRepository);
  late final scorerCubit = ScorerCubit(apiRepository);
  late final leagueTableCubit = LeagueTableCubit(apiRepository);
  late final champTableCubit = ChampTableCubit(apiRepository);
  late final detailedGamesCubit = DetailedGamesCubit(apiRepository);
  late final teamInfoCubit = TeamInfoCubit(teamRepository);
  late final tickCubit = TickCubit();
  late final pinnedFederationsCubit = PinnedFederationsCubit(
    persistenceRepository,
  );
  late final navigationAppCubit = NavigationAppCubit(navigationRepository);

  @override
  Widget build(BuildContext context) {
    _fetchInitialData();
    tickCubit.startTicking();

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: apiRepository),
        RepositoryProvider.value(value: navigationRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: availableSeasonsCubit),
          BlocProvider.value(value: availableFederationsCubit),
          BlocProvider.value(value: selectedSeasonCubit),
          BlocProvider.value(value: leaguesCubit),
          BlocProvider.value(value: leagueGameDayCubit),
          BlocProvider.value(value: scorerCubit),
          BlocProvider.value(value: leagueTableCubit),
          BlocProvider.value(value: champTableCubit),
          BlocProvider.value(value: detailedGamesCubit),
          BlocProvider.value(value: teamInfoCubit),
          BlocProvider.value(value: tickCubit),
          BlocProvider.value(value: pinnedFederationsCubit),
          BlocProvider.value(value: navigationAppCubit),
        ],
        child: MaterialApp.router(
          title: 'Federations Grid',
          theme: ThemeData(
            fontFamily: 'NimbusSans',
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          routerConfig: buildRouter(),
        ),
      ),
    );
  }

  void _fetchInitialData() {
    pinnedFederationsCubit.init();
    navigationAppCubit.init();
    log.info("Triggering download of initial data");
    apiRepository.getStart().then(
      (stream) => stream.listen((entry) {
        log.info("Received initial data");
        log.info("Storing ${entry.frederations.length} federations");
        availableFederationsCubit.setFederations(entry.frederations);
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
