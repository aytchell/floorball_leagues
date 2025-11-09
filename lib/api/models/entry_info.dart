import 'federation.dart';
import 'season_info.dart';

class EntryInfo {
  final List<SeasonInfo> seasons;
  final int? currentSeasonId;
  final List<Federation> frederations;

  EntryInfo({
    required this.seasons,
    this.currentSeasonId,
    required this.frederations,
  });
}
