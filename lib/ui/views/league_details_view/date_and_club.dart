import 'package:logging/logging.dart';
import 'package:intl/intl.dart';

final log = Logger('DateAndClub');

class DateAndClub implements Comparable<DateAndClub> {
  final String date;
  final bool isBygone;
  final String hostingClub;
  final String _comparisonKey;

  DateAndClub._(
    this.date,
    this.isBygone,
    this.hostingClub,
    this._comparisonKey,
  );

  factory DateAndClub.create(
    String yyyyMmDd,
    String hostingClub,
    DateTime today,
  ) {
    try {
      final DateTime parsedDate = DateTime.parse(yyyyMmDd);
      final DateFormat formatter = DateFormat('dd.MM.yyyy');
      final beautifiedDate = formatter.format(parsedDate);

      return DateAndClub._(
        beautifiedDate,
        parsedDate.isBefore(today),
        hostingClub,
        '${yyyyMmDd} @ $hostingClub',
      );
    } catch (e) {
      log.severe('Error parsing date string "$yyyyMmDd": $e');
      return DateAndClub._(
        yyyyMmDd,
        false,
        hostingClub,
        '${yyyyMmDd} @ $hostingClub',
      );
    }
  }

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
  int get hashCode => Object.hash(date, hostingClub);
}
