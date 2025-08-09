import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import 'api_models/entry_info.dart';

class AppState extends ChangeNotifier {
  SeasonInfo? _selectedSeason;
  List<SeasonInfo> _seasons = [];

  SeasonInfo? get selectedSeason => _selectedSeason;

  List<SeasonInfo> get allSeasons => _seasons;

  void setSeasonIfNull(SeasonInfo info) {
    if (_selectedSeason == null) {
      _selectedSeason = info;
      notifyListeners();
    }
  }

  void setSelectedSeason(SeasonInfo info) {
    if (_selectedSeason == null || _selectedSeason!.id != info.id) {
      _selectedSeason = info;
      notifyListeners();
    }
  }

  void setSeasonList(List<SeasonInfo> list) {
    _seasons = list;
    notifyListeners();
  }
}
