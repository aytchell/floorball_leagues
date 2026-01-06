import 'dart:convert';

import 'package:floorball/utils/list_extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

final log = Logger('PinnedFederationsCubit');

class PinnedFederations {
  const PinnedFederations._(this._federationIdsPerSeason);

  const PinnedFederations() : _federationIdsPerSeason = const {};

  final Map<int, List<int>> _federationIdsPerSeason;

  List<int> getPinnedFederations(int seasonId) =>
      _federationIdsPerSeason[seasonId] ?? [];

  PinnedFederations toggle(int seasonId, int federationId) {
    final Map<int, List<int>> newState = Map.from(_federationIdsPerSeason);
    newState.update(
      seasonId,
      (fedIds) => fedIds.toggle(federationId),
      ifAbsent: () => [federationId],
    );
    return PinnedFederations._(newState);
  }

  String asJson() => json.encode(
    _federationIdsPerSeason.map(
      (key, value) => MapEntry(key.toString(), value),
    ),
  );

  factory PinnedFederations.fromJson(String jsonString) {
    final decoded = json.decode(jsonString) as Map<String, dynamic>;
    final pinnedFedMap = decoded.map(
      (key, value) => MapEntry(int.parse(key), List<int>.from(value)),
    );
    return PinnedFederations._(pinnedFedMap);
  }
}

class PinnedFederationsCubit extends Cubit<PinnedFederations> {
  PinnedFederationsCubit() : super(PinnedFederations());

  static const sharedPrefsKey = 'pinnedFederations';

  void toggle(int seasonId, int federationId) {
    final newState = state.toggle(seasonId, federationId);
    SharedPreferences.getInstance().then(
      (prefs) => prefs.setString(sharedPrefsKey, newState.asJson()),
    );
    emit(newState);
  }

  void init(String? jsonString) {
    if (jsonString != null) {
      emit(PinnedFederations.fromJson(jsonString));
    }
  }
}
