import 'package:floorball/repositories/navigation_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NavigationAppState {
  final NavigationApp? selectedApp;
  final List<NavigationApp> availableApps;

  NavigationAppState(this.selectedApp, this.availableApps);
}

class NavigationAppCubit extends Cubit<NavigationAppState> {
  final NavigationRepository _repository;

  NavigationAppCubit(this._repository) : super(NavigationAppState(null, []));

  void changeAvailableApps(List<NavigationApp> availableApps) =>
      emit(NavigationAppState(state.selectedApp, availableApps));

  void changeSelectedApp(NavigationApp? app) {
    if (app != null) {
      _repository.persistSelection(app);
    }
    _emitSelectedApp(app);
  }

  void _emitSelectedApp(NavigationApp? app) =>
      emit(NavigationAppState(app, state.availableApps));

  void init() {
    _repository
        .loadSelection()
        .then((selection) => _emitSelectedApp(selection))
        .ignore();
    _repository
        .getAvailableNavigationApps()
        .then((available) => changeAvailableApps(available))
        .ignore();
  }
}
