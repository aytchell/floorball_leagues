import 'package:bloc/bloc.dart';
import 'package:floorball/api/models/federation.dart';

class AvailableFederations {
  AvailableFederations(this.federations);

  final List<Federation> federations;

  Federation? get(int federationId) =>
      federations.where((op) => op.id == federationId).firstOrNull;
}

class AvailableFederationsCubit extends Cubit<AvailableFederations> {
  AvailableFederationsCubit() : super(AvailableFederations([]));

  void setFederations(List<Federation> federations) =>
      emit(AvailableFederations(federations));
}
