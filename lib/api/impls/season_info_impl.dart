import '../../api_models/int_parser.dart';

import '../models/season_info.dart';
import 'season_info_impl.dart';

class SeasonInfoImpl extends SeasonInfo {
  SeasonInfoImpl({required int id, required String name, bool current = false})
    : super(id: id, name: name, current: current);

  factory SeasonInfoImpl.fromJson(Map<String, dynamic> json) {
    return SeasonInfoImpl(
      id: parseInt(json, 'id'),
      name: json['name'] as String,
      current: json['current'] as bool? ?? false,
    );
  }
}
