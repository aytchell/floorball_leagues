import 'package:floorball/api/models/game.dart';
import 'package:floorball/api/models/game_date_time.dart';
import 'package:floorball/ui/views/league_details/date_and_club.dart';

List<DateAndClub> extractDatesAndClubs(final List<Game> games) {
  final todayAtMidnight = todaysDay();

  var eventList = games
      .map(
        (game) => DateAndClub.create(
          dateTime: game.dateTime,
          hostingClub: game.hostingClub!,
          isBygone: game.dateTime.isBefore(todayAtMidnight),
        ),
      )
      .toSet()
      .toList();
  eventList.sort();
  return eventList;
}
