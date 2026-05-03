import 'package:bloc/bloc.dart';
import 'package:floorball/repositories/persistence_repository.dart';

const _defaultWarnOnOldSeason = true;

class WarnOnOldSeasonState {
  final bool warn;

  WarnOnOldSeasonState(this.warn);
}

class WarnOnOldSeasonCubit extends Cubit<WarnOnOldSeasonState> {
  final PersistenceRepository _persistence;
  static const _persistenceKey = PersistenceRepository.warnOnOldSeasonKey;

  WarnOnOldSeasonCubit(this._persistence)
    : super(WarnOnOldSeasonState(_defaultWarnOnOldSeason));

  void changeWarnOnOldSeason(bool warnOnOldSeason) {
    if (warnOnOldSeason == _defaultWarnOnOldSeason) {
      _persistence.removeEntry(_persistenceKey);
    } else {
      _persistence.persistString(
        _persistenceKey,
        warnOnOldSeason ? "true" : "false",
      );
    }
    emit(WarnOnOldSeasonState(warnOnOldSeason));
  }

  bool get vibrateOnToggle => state.warn;

  void init() {
    _persistence.loadString(_persistenceKey).then((warnOnOldSeasonString) {
      if (warnOnOldSeasonString != null) {
        log.info('Loaded preferred warnOnOldSeason "$warnOnOldSeasonString"');
        emit(WarnOnOldSeasonState(warnOnOldSeasonString == "true"));
      }
    });
  }
}
