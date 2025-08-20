import 'int_parser.dart';
import 'string_parser.dart';
import '../models/referee.dart';

Referee parseReferee(Map<String, dynamic> json) {
  return Referee(
    licenseId: parseNullableInt(json, 'license_id'),
    firstName: parseNullableString(json, 'first_name'),
    lastName: parseNullableString(json, 'last_name'),
  );
}
