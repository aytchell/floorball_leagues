/* 'period' is a double which looks a bit weird. Here's a real live example:
{
    "period": 2.5,
    "short_title": "PV",
    "title": "Pause vor Verlängerung",
    "status_id": "pause_et",
    "can_end_game": false,
    "optional": true,
    "running": false}
*/

class PeriodTitle {
  double period;
  String shortTitle;
  String title;
  String statusId;
  bool canEndGame;
  bool optional;
  bool running;

  PeriodTitle({
    required this.period,
    required this.shortTitle,
    required this.title,
    required this.statusId,
    required this.canEndGame,
    required this.optional,
    required this.running,
  });

  factory PeriodTitle.fromJson(Map<String, dynamic> json) {
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
}
