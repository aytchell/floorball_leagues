import 'package:intl/intl.dart';
import 'package:floorball/utils/date_time_utils.dart';

class AroundToday {
  final bool today;
  final bool tomorrow;
  final bool beyond;

  AroundToday(this.today, this.tomorrow, this.beyond);

  static AroundToday or(AroundToday lhs, AroundToday rhs) => AroundToday(
    lhs.today || rhs.today,
    lhs.tomorrow || rhs.tomorrow,
    lhs.beyond || rhs.beyond,
  );
}

class GameDateTime {
  final String date;
  final String? time;

  static final DateFormat formatter = DateFormat('dd.MM.yyyy');

  GameDateTime(this.date, this.time);

  late final DateTime dateTime = parseDateTimeFromStrings(date, time);
  late final String beautifiedDate = _formatDate(dateTime);

  String _formatDate(DateTime date) {
    return formatter.format(date);
  }

  bool isBefore(DateTime timestamp) => dateTime.isBefore(timestamp);

  AroundToday isCloseToToday(DateTime? today) {
    final dayToday = today ?? todaysDay();
    final dayTomorrow = dayToday.add(Duration(days: 1));
    final dayPostTomorrow = dayToday.add(Duration(days: 2));

    return AroundToday(
      dateTime.isAfter(dayToday) && dateTime.isBefore(dayTomorrow),
      dateTime.isAfter(dayTomorrow) && dateTime.isBefore(dayPostTomorrow),
      dateTime.isAfter(dayPostTomorrow),
    );
  }

  @override
  bool operator ==(Object other) =>
      (other is GameDateTime) && (dateTime == other.dateTime);

  @override
  int get hashCode => dateTime.hashCode;
}

DateTime todaysDay() {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
}
