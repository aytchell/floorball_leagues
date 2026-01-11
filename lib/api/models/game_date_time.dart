import 'package:intl/intl.dart';
import 'package:floorball/utils/date_time_utils.dart';

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
}
