import 'game_operation.dart';
import 'season_info.dart';

class EntryInfo {
  final List<SeasonInfo> seasons;
  final int? currentSeasonId;
  final List<GameOperation> gameOperations;

  EntryInfo({
    required this.seasons,
    this.currentSeasonId,
    required this.gameOperations,
  });
}
