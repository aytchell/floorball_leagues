import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

final log = Logger('GameParser');

class TickState {
  final int tickCount;
  final DateTime timestamp;

  const TickState({required this.tickCount, required this.timestamp});

  TickState copyWith({required int tickCount, required DateTime timestamp}) {
    return TickState(tickCount: tickCount, timestamp: timestamp);
  }
}

class TickCubit extends Cubit<TickState> {
  Timer? _timer;
  final Duration tickInterval;

  TickCubit({this.tickInterval = const Duration(seconds: 30)})
    : super(TickState(tickCount: 0, timestamp: DateTime.now()));

  void startTicking() {
    // Cancel existing timer if any
    _timer?.cancel();

    // Emit initial tick
    _emitTick();

    // Start periodic timer
    _timer = Timer.periodic(tickInterval, (_) {
      _emitTick();
    });
  }

  void stopTicking() {
    _timer?.cancel();
    _timer = null;
  }

  void _emitTick() {
    log.info("tick");
    emit(
      state.copyWith(tickCount: state.tickCount + 1, timestamp: DateTime.now()),
    );
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
