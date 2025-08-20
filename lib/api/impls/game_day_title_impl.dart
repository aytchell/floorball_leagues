import '../models/game_day_title.dart';
import '../../api_models/int_parser.dart';

class GameDayTitleImpl extends GameDayTitle {
  GameDayTitleImpl({required int gameDayNumber, required String title})
    : super(gameDayNumber: gameDayNumber, title: title);

  factory GameDayTitleImpl.fromJson(Map<String, dynamic> json) {
    return GameDayTitleImpl(
      gameDayNumber: parseInt(json, 'game_day_number'),
      title: json['title'] as String,
    );
  }
}
