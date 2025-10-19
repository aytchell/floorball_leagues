/// Converts a date string and optional time string into a DateTime object.
///
/// The [dateString] should be in the format "yyyy-MM-dd" (e.g., "2026-09-23").
/// If [dateString] is null, returns null.
///
/// The [timeString] should be in the format "HH:mm" (e.g., "17:00").
/// If [timeString] is null, midnight (00:00) is assumed.
///
/// Returns a [DateTime] object or null if [dateString] is null.
///
/// Example:
/// ```dart
/// parseDateTimeFromStrings("2026-09-23", "17:00"); // 2026-09-23 17:00:00.000
/// parseDateTimeFromStrings("2026-09-23", null);     // 2026-09-23 00:00:00.000
/// parseDateTimeFromStrings(null, "17:00");          // null
/// ```
DateTime? parseDateTimeFromStrings(String? dateString, String? timeString) {
  if (dateString == null) {
    return null;
  }

  // Parse the date (format: yyyy-MM-dd)
  final dateParts = dateString.split('-');
  if (dateParts.length != 3) {
    throw FormatException(
      'Invalid date format. Expected yyyy-MM-dd, got: $dateString',
    );
  }

  final year = int.parse(dateParts[0]);
  final month = int.parse(dateParts[1]);
  final day = int.parse(dateParts[2]);

  // Parse the time (format: HH:mm), default to midnight if null
  int hour = 0;
  int minute = 0;

  if (timeString != null) {
    final timeParts = timeString.split(':');
    if (timeParts.length != 2) {
      throw FormatException(
        'Invalid time format. Expected HH:mm, got: $timeString',
      );
    }

    hour = int.parse(timeParts[0]);
    minute = int.parse(timeParts[1]);
  }

  return DateTime(year, month, day, hour, minute);
}
