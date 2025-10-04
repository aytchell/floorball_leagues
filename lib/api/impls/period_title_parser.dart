import 'package:floorball/api/models/period_title.dart';

PeriodTitle parsePeriodTitle(Map<String, dynamic> json) {
  return PeriodTitle(
    period: (json['period'] as num).toDouble(),
    shortTitle: json['short_title'] as String,
    title: json['title'] as String,
    statusId: json['status_id'] as String,
    canEndGame: json['can_end_game'] as bool,
    optional: json['optional'] as bool,
    running: json['running'] as bool,
  );
}
