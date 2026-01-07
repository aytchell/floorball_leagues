import 'dart:convert';

import 'package:floorball/repositories/persistence_repository.dart';
import 'package:floorball/utils/list_extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

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
  final PersistenceRepository persistenceRepository;
  static const _persistenceKey = PersistenceRepository.pinnedFederationsKey;

  PinnedFederationsCubit(this.persistenceRepository)
    : super(PinnedFederations());

  void toggle(int seasonId, int federationId) {
    final newState = state.toggle(seasonId, federationId);
    persistenceRepository.persistString(_persistenceKey, newState.asJson());
    emit(newState);
  }

  void init() {
    persistenceRepository.loadString(_persistenceKey).then((jsonString) {
      if (jsonString != null) {
        log.info("Loading persisted pinned federations list");
        emit(PinnedFederations.fromJson(jsonString));
      }
    });
  }
}
