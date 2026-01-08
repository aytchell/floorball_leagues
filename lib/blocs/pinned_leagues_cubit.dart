import 'dart:convert';

import 'package:floorball/repositories/persistence_repository.dart';
import 'package:floorball/utils/list_extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

final log = Logger('PinnedLeaguesCubit');

class _LeaguesPerFederation {
  const _LeaguesPerFederation._(this._leagueIdsPerFederation);

  const _LeaguesPerFederation() : _leagueIdsPerFederation = const {};

  factory _LeaguesPerFederation.init(int federationId, int leagueId) {
    final entries = Map.fromEntries([
      MapEntry(federationId, [leagueId]),
    ]);
    return _LeaguesPerFederation._(entries);
  }

  final Map<int, List<int>> _leagueIdsPerFederation;

  List<int> getPinnedLeagues(int federationId) =>
      _leagueIdsPerFederation[federationId] ?? [];

  _LeaguesPerFederation toggle(int federationId, int leagueId) {
    final Map<int, List<int>> newState = Map.from(_leagueIdsPerFederation);
    newState.update(
      federationId,
      (currentLeagueIds) => currentLeagueIds.toggle(leagueId),
      ifAbsent: () => [leagueId],
    );
    return _LeaguesPerFederation._(newState);
  }

  String asJson() => json.encode(
    _leagueIdsPerFederation.map(
      (key, value) => MapEntry(key.toString(), value),
    ),
  );

  factory _LeaguesPerFederation.fromJson(String jsonString) {
    final decoded = json.decode(jsonString) as Map<String, dynamic>;
    final pinnedLeaguesMap = decoded.map(
      (key, value) => MapEntry(int.parse(key), List<int>.from(value)),
    );
    return _LeaguesPerFederation._(pinnedLeaguesMap);
  }
}

class PinnedLeagues {
  const PinnedLeagues._(this._leagueIdsPerSeason);

  const PinnedLeagues() : _leagueIdsPerSeason = const {};

  final Map<int, _LeaguesPerFederation> _leagueIdsPerSeason;

  List<int> getPinnedLeagues(int seasonId, int federationId) =>
      _leagueIdsPerSeason[seasonId]?.getPinnedLeagues(federationId) ?? [];

  PinnedLeagues toggle(int seasonId, int federationId, int leagueId) {
    final Map<int, _LeaguesPerFederation> newState = Map.from(
      _leagueIdsPerSeason,
    );
    newState.update(
      seasonId,
      (leaguesPerSeason) => leaguesPerSeason.toggle(federationId, leagueId),
      ifAbsent: () => _LeaguesPerFederation.init(federationId, leagueId),
    );
    return PinnedLeagues._(newState);
  }

  String asJson() => json.encode(
    _leagueIdsPerSeason.map(
      (key, value) => MapEntry(key.toString(), value.asJson()),
    ),
  );

  factory PinnedLeagues.fromJson(String jsonString) {
    final decoded = json.decode(jsonString) as Map<String, dynamic>;
    final decodedState = decoded.map(
      (key, value) =>
          MapEntry(int.parse(key), _LeaguesPerFederation.fromJson(value)),
    );
    return PinnedLeagues._(decodedState);
  }
}

class PinnedLeaguesCubit extends Cubit<PinnedLeagues> {
  final PersistenceRepository persistenceRepository;
  static const _persistenceKey = PersistenceRepository.pinnedLeaguesKey;

  PinnedLeaguesCubit(this.persistenceRepository) : super(PinnedLeagues());

  void toggle(int seasonId, int federationId, int leagueId) {
    final newState = state.toggle(seasonId, federationId, leagueId);
    persistenceRepository.persistString(_persistenceKey, newState.asJson());
    emit(newState);
  }

  void init() {
    persistenceRepository.loadString(_persistenceKey).then((jsonString) {
      if (jsonString != null) {
        log.info("Loading persisted pinned leagues list");
        emit(PinnedLeagues.fromJson(jsonString));
      }
    });
  }
}
