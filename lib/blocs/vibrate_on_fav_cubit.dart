import 'package:bloc/bloc.dart';
import 'package:floorball/repositories/persistence_repository.dart';

const _defaultVibrateOnFav = true;

class VibrateOnFavState {
  final bool vibrate;

  VibrateOnFavState(this.vibrate);
}

class VibrateOnFavCubit extends Cubit<VibrateOnFavState> {
  final PersistenceRepository _persistence;
  static const _persistenceKey = PersistenceRepository.vibrateOnFavKey;

  VibrateOnFavCubit(this._persistence)
    : super(VibrateOnFavState(_defaultVibrateOnFav));

  void changeVibrateOnFav(bool vibrateOnFav) {
    if (vibrateOnFav == _defaultVibrateOnFav) {
      _persistence.removeEntry(_persistenceKey);
    } else {
      _persistence.persistString(
        _persistenceKey,
        vibrateOnFav ? "true" : "false",
      );
    }
    emit(VibrateOnFavState(vibrateOnFav));
  }

  bool get vibrateOnToggle => state.vibrate;

  void init() {
    _persistence.loadString(_persistenceKey).then((vibrateOnFavString) {
      if (vibrateOnFavString != null) {
        log.info('Loaded preferred vibrateOnFav "$vibrateOnFavString"');
        emit(VibrateOnFavState(vibrateOnFavString == "true"));
      }
    });
  }
}
