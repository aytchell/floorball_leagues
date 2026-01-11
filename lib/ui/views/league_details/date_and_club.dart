import 'package:floorball/api/models/game_date_time.dart';

class DateAndClub implements Comparable<DateAndClub> {
  final GameDateTime dateTime;
  final bool isBygone;
  final String hostingClub;
  final String _comparisonKey;

  DateAndClub._(
    this.dateTime,
    this.isBygone,
    this.hostingClub,
    this._comparisonKey,
  );

  factory DateAndClub.create(
    GameDateTime dateTime,
    String hostingClub,
    DateTime today,
  ) => DateAndClub._(
    dateTime,
    dateTime.isBefore(today),
    hostingClub,
    '${dateTime.date} @ $hostingClub',
  );

  String get beautifiedDate => dateTime.beautifiedDate;

  @override
  int compareTo(DateAndClub other) {
    return _comparisonKey.compareTo(other._comparisonKey);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! DateAndClub) return false;
    return _comparisonKey == other._comparisonKey;
  }

  @override
  int get hashCode => Object.hash(dateTime.beautifiedDate, hostingClub);
}
