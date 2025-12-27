import 'package:floorball/api/impls/double_parser.dart';
import 'package:floorball/api/models/game_event.dart';
import 'package:floorball/api/impls/int_parser.dart';
import 'package:floorball/api/impls/string_parser.dart';

GameEvent parseGameEvent(Map<String, dynamic> json) {
  return GameEvent(
    eventId: parseNullableInt(json, 'event_id'),
    eventType: parseString(json, 'event_type'),
    eventTeam: parseString(json, 'event_team'),
    period: parseDouble(json, 'period'),
    homeGoals: parseNullableInt(json, 'home_goals'),
    guestGoals: parseNullableInt(json, 'guest_goals'),
    time: parseString(json, 'time'),
    sortkey: parseString(json, 'sortkey'),
    number: parseNullableInt(json, 'number'),
    assist: parseNullableInt(json, 'assist'),
    goalType: parseNullableString(json, 'goal_type'),
    goalTypeString: parseNullableString(json, 'goal_type_string'),
    penaltyType: parseNullableString(json, 'penalty_type'),
    penaltyTypeString: parseNullableString(json, 'penalty_type_string'),
    penaltyReason: parseNullableInt(json, 'penalty_reason'),
    penaltyReasonString: parseNullableString(json, 'penalty_reason_string'),
  );
}
