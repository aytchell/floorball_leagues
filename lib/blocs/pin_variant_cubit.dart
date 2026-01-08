import 'package:floorball/repositories/persistence_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PinVariantState {
  final String? variantIdent;

  PinVariantState(this.variantIdent);
}

class PinVariantCubit extends Cubit<PinVariantState> {
  final PersistenceRepository _persistence;
  static const _persistenceKey = PersistenceRepository.pinVariantKey;

  PinVariantCubit(this._persistence) : super(PinVariantState(null));

  void changePinVariant(String? variantIdent) {
    if (variantIdent == null) {
      _persistence.removeEntry(_persistenceKey);
    } else {
      _persistence.persistString(_persistenceKey, variantIdent);
    }
    emit(PinVariantState(variantIdent));
  }

  void init() {
    _persistence.loadString(_persistenceKey).then((variantIdent) {
      if (variantIdent != null) {
        log.info('Loaded preferred pin variant "$variantIdent"');
        emit(PinVariantState(variantIdent));
      }
    });
  }
}
