import 'dart:async';
import 'package:flutter/widgets.dart';
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
  late final AppLifecycleListener _lifecycleListener;

  TickCubit({this.tickInterval = const Duration(seconds: 30)})
    : super(TickState(tickCount: 0, timestamp: DateTime.now())) {
    _lifecycleListener = AppLifecycleListener(
      onShow: _onAppShow,
      onHide: _onAppHide,
    );
    // Start ticking on initialization
    startTicking();
  }

  void _onAppShow() {
    log.info("App shown, starting ticker");
    startTicking();
  }

  void _onAppHide() {
    log.info("App hidden, stopping ticker");
    stopTicking();
  }

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
    stopTicking();
    _lifecycleListener.dispose();
    return super.close();
  }
}
