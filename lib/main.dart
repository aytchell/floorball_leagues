import 'package:floorball/blocs/available_seasons_cubit.dart';
import 'package:floorball/blocs/champ_table_cubit.dart';
import 'package:floorball/blocs/detailed_games_cubit.dart';
import 'package:floorball/blocs/federations_cubit.dart';
import 'package:floorball/blocs/games_visit_history_cubit.dart';
import 'package:floorball/blocs/league_game_day_cubit.dart';
import 'package:floorball/blocs/league_table_cubit.dart';
import 'package:floorball/blocs/leagues_cubit.dart';
import 'package:floorball/blocs/navigation_app_cubit.dart';
import 'package:floorball/blocs/pin_variant_cubit.dart';
import 'package:floorball/blocs/pinned_federations_cubit.dart';
import 'package:floorball/blocs/pinned_leagues_cubit.dart';
import 'package:floorball/blocs/scorer_cubit.dart';
import 'package:floorball/blocs/selected_season_cubit.dart';
import 'package:floorball/blocs/tick_cubit.dart';
import 'package:floorball/blocs/vibrate_on_fav_cubit.dart';
import 'package:floorball/entry_info_processor.dart';
import 'package:floorball/repositories/api_repository.dart';
import 'package:floorball/repositories/navigation_repository.dart';
import 'package:floorball/repositories/persistence_repository.dart';
import 'package:floorball/repositories/ref_license_repository.dart';
import 'package:floorball/routes.dart';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

final log = Logger('Main');

void setupLogging() {
  // Configure logging level and output
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    developer.log(
      record.message,
      name: record.loggerName,
      level: record.level.value,
      time: record.time,
    );
  });
}

void main() {
  setupLogging();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final apiRepository = ApiRepository();
  final persistenceRepository = PersistenceRepository();
  late final refLicenseRepository = RefLicenseRepository();

  final availableSeasonsCubit = AvailableSeasonsCubit();
  final availableFederationsCubit = AvailableFederationsCubit();
  final selectedSeasonCubit = SelectedSeasonCubit();
  late final tickCubit = TickCubit();
  late final vibrateOnFavCubit = VibrateOnFavCubit(persistenceRepository);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: apiRepository),
        RepositoryProvider(
          create: (_) => NavigationRepository(persistenceRepository),
        ),
        RepositoryProvider.value(value: refLicenseRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: availableSeasonsCubit),
          BlocProvider.value(value: availableFederationsCubit),
          BlocProvider.value(value: selectedSeasonCubit),
          BlocProvider.value(value: tickCubit),
          BlocProvider.value(value: vibrateOnFavCubit),
          BlocProvider(create: (_) => LeaguesCubit(apiRepository)),
          BlocProvider(create: (_) => LeagueGameDayCubit(apiRepository)),
          BlocProvider(create: (_) => ScorerCubit(apiRepository)),
          BlocProvider(create: (_) => LeagueTableCubit(apiRepository)),
          BlocProvider(create: (_) => ChampTableCubit(apiRepository)),
          BlocProvider(create: (_) => DetailedGamesCubit(apiRepository)),
          BlocProvider(create: (_) => GamesVisitHistoryCubit(apiRepository)),
          BlocProvider(
            create: (_) => PinnedFederationsCubit(
              persistenceRepository,
              vibrateOnFavCubit,
            ),
          ),
          BlocProvider(
            create: (_) =>
                PinnedLeaguesCubit(persistenceRepository, vibrateOnFavCubit),
          ),
          BlocProvider(create: (_) => PinVariantCubit(persistenceRepository)),
          BlocProvider(
            create: (context) => NavigationAppCubit(
              RepositoryProvider.of<NavigationRepository>(context),
            ),
          ),
        ],
        child: InnerApp(),
      ),
    );
  }
}

class InnerApp extends StatelessWidget {
  const InnerApp({super.key});

  @override
  Widget build(BuildContext context) {
    _fetchInitialData(context);
    return MaterialApp.router(
      title: 'Federations Grid',
      theme: ThemeData(
        fontFamily: 'NimbusSans',
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routerConfig: buildRouter(),
    );
  }

  void _fetchInitialData(BuildContext context) {
    log.info("Load settings from persistence");
    BlocProvider.of<PinnedFederationsCubit>(context).init();
    BlocProvider.of<PinnedLeaguesCubit>(context).init();
    BlocProvider.of<PinVariantCubit>(context).init();
    BlocProvider.of<VibrateOnFavCubit>(context).init();
    BlocProvider.of<NavigationAppCubit>(context).init();

    log.info("Triggering download of initial data");
    final processor = EntryInfoProcessor(
      BlocProvider.of<AvailableFederationsCubit>(context),
      BlocProvider.of<AvailableSeasonsCubit>(context),
      BlocProvider.of<SelectedSeasonCubit>(context),
    );
    RepositoryProvider.of<ApiRepository>(context).getStart().then(
      (stream) => stream.listen((entryInfo) => processor.process(entryInfo)),
    );
  }
}
