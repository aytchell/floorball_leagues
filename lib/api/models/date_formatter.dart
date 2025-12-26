import 'package:intl/intl.dart';

final DateFormat formatter = DateFormat('dd.MM.yyyy');

String? beautifyNullableDate(String? yyyyMmDd) {
  if (yyyyMmDd == null) return null;

  final DateTime parsedDate = DateTime.parse(yyyyMmDd);
  return formatter.format(parsedDate);
}

String beautifyDate(String yyyyMmDd) {
  final DateTime parsedDate = DateTime.parse(yyyyMmDd);
  return formatter.format(parsedDate);
}
