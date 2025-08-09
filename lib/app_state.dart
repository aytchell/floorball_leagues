import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import 'api_models/entry_info.dart';

class AppState extends ChangeNotifier {
  SeasonInfo? _selectedSeason;

  SeasonInfo? get selectedSeason => _selectedSeason;

  void setSeasonId(SeasonInfo info) {
    if (_selectedSeason == null || _selectedSeason!.id != info.id) {
      _selectedSeason = info;
      notifyListeners();
    }
  }
}
