import 'int_parser.dart';
import 'string_parser.dart';

class Referee {
  int? licenseId;
  String? firstName;
  String? lastName;

  Referee({
    required this.licenseId,
    required this.firstName,
    required this.lastName,
  });

  factory Referee.fromJson(Map<String, dynamic> json) {
    return Referee(
      licenseId: parseNullableInt(json, 'license_id'),
      firstName: parseNullableString(json, 'first_name'),
      lastName: parseNullableString(json, 'last_name'),
    );
  }
}
