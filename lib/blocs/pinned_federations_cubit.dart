import 'package:floorball/utils/list_extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

final log = Logger('PinnedFederationsCubit');

class PinnedFederations {
  const PinnedFederations(this._federationIdsPerSeason);

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
    return PinnedFederations(newState);
  }
}

class PinnedFederationsCubit extends Cubit<PinnedFederations> {
  PinnedFederationsCubit() : super(PinnedFederations({}));

  void toggle(int seasonId, int federationId) =>
      emit(state.toggle(seasonId, federationId));
}
