import 'package:intl/intl.dart';

final DateFormat formatter = DateFormat('dd.MM.yyyy');

String? beautifyDate(String? yyyyMmDd) {
  if (yyyyMmDd == null) return null;

  final DateTime parsedDate = DateTime.parse(yyyyMmDd);
  return formatter.format(parsedDate);
}
