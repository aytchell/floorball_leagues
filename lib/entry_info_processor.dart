import 'package:floorball/api/models/entry_info.dart';
import 'package:floorball/api/models/season_info.dart';
import 'package:floorball/blocs/available_seasons_cubit.dart';
import 'package:floorball/blocs/federations_cubit.dart';
import 'package:floorball/blocs/selected_season_cubit.dart';

class EntryInfoProcessor {
  final AvailableFederationsCubit _availableFederationsCubit;
  final AvailableSeasonsCubit _availableSeasonsCubit;
  final SelectedSeasonCubit _selectedSeasonCubit;

  EntryInfoProcessor(
    this._availableFederationsCubit,
    this._availableSeasonsCubit,
    this._selectedSeasonCubit,
  );

  void process(EntryInfo info) {
    log.info("Received initial data");

    log.info("Storing ${info.frederations.length} federations");
    _availableFederationsCubit.setFederations(info.frederations);

    log.info("Storing ${info.seasons.length} available seasons");
    _availableSeasonsCubit.setSeasons(info.seasons);

    final selectedSeason = _findCurrentSeason(
      info.seasons,
      info.currentSeasonId,
    );
    if (selectedSeason != null) {
      _selectedSeasonCubit.seasonSelected(selectedSeason);
    }
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
