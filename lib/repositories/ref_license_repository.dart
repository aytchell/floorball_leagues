import 'dart:async';
import 'dart:convert';

import 'package:floorball/net/rest_client.dart';
import 'package:floorball/utils/list_extensions.dart';
import 'package:logging/logging.dart';

final log = Logger('RefLicenseRepository');

class RefLicense {
  final int licenseId;
  final String licenseType;
  final String validUntil;
  final String? extraLicenses;
  final String? extrasValidUntil;
  final String club;

  RefLicense({
    required this.licenseId,
    required this.licenseType,
    required this.validUntil,
    this.extraLicenses,
    this.extrasValidUntil,
    required this.club,
  });

  static RefLicense? fromRow(String row) {
    final cells = row.split(';');
    if (cells.length != 6) {
      log.warning('ref csv row has wrong number of entries: "$row"');
      return null;
    }

    final extras = cells[3].trim();
    final validUntil = cells[4].trim();

    try {
      return RefLicense(
        licenseId: int.parse(cells[0]),
        licenseType: cells[1],
        validUntil: cells[2],
        extraLicenses: (extras == '-' || extras.isEmpty) ? null : extras,
        extrasValidUntil: (validUntil.isEmpty) ? null : validUntil,
        club: cells[5],
      );
    } catch (e) {
      log.warning('Malformed row: "$row"');
      return null;
    }
  }
}

class RefLicenseRepository {
  late final Future<Map<int, RefLicense>> _licenses =
      _fetchAndParseLicenseList();
  static final _url = Uri(
    scheme: 'https',
    host: 'sr.floorball.de',
    path: '/lizenzcheck/members.csv',
  );

  Future<Map<int, RefLicense>> get licenses async => _licenses;

  Future<List<String>> _fetchLicenseCsvList() => RestClient.instance
      .then((client) => client.getFileStreamSync(_url))
      .then((stream) => stream.last)
      .then((file) => file.readAsLinesSync(encoding: latin1));

  Future<Map<int, RefLicense>> _fetchAndParseLicenseList() async {
    try {
      final csv = await _fetchLicenseCsvList();
      return _parseCsvList(csv);
    } catch (e) {
      log.severe('Failed to fetch or parse license list: $e');
      return {};
    }
  }

  Map<int, RefLicense> _parseCsvList(List<String> csv) => Map.fromEntries(
    // skip the header row
    csv
        .skip(1)
        .mapNotNull((row) => RefLicense.fromRow(row))
        .map((entry) => MapEntry(entry.licenseId, entry)),
  );
}
