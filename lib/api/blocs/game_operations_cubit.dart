import 'package:bloc/bloc.dart';
import 'package:floorball/api/models/game_operation.dart';

class AvailableOperations {
  AvailableOperations(this.operations);

  final List<GameOperation> operations;
}

class AvailableOperationsCubit extends Cubit<AvailableOperations> {
  AvailableOperationsCubit() : super(AvailableOperations([]));

  void setOperations(List<GameOperation> operations) =>
      emit(AvailableOperations(operations));
}
