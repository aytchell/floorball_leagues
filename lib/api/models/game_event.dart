class GameEvent {
  int eventId;
  String eventType;
  String eventTeam;
  double period;
  int? homeGoals;
  int? guestGoals;
  String time;
  String sortkey;
  int? number;
  int? assist;
  String? goalType;
  String? goalTypeString;
  String? penaltyType;
  String? penaltyTypeString;
  int? penaltyReason;
  String? penaltyReasonString;

  GameEvent({
    required this.eventId,
    required this.eventType,
    required this.eventTeam,
    required this.period,
    this.homeGoals,
    this.guestGoals,
    required this.time,
    required this.sortkey,
    this.number,
    this.assist,
    this.goalType,
    this.goalTypeString,
    this.penaltyType,
    this.penaltyTypeString,
    this.penaltyReason,
    this.penaltyReasonString,
  });
}
