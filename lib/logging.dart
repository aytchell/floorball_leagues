import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

void setupLogging() {
  if (kDebugMode) {
    final logTo = const String.fromEnvironment('log_to');
    Logger.root.level = Level.ALL;

    if ('console' == logTo) {
      _setupTerminalLogging();
    } else {
      _setupLogcatLogging();
    }
  } else {
    // don't log anything in release mode
    Logger.root.level = Level.OFF;
  }
}

void _setupTerminalLogging() {
  // When printing to a plain Terminal we prepend the record's level
  Logger.root.onRecord.listen((record) {
    debugPrint('[${record.level.name}] ${record.message}');
  });
}

void _setupLogcatLogging() {
  // Android Studio's "Logcat" already adds markers for the record's level
  // so we only need to print the message
  Logger.root.onRecord.listen((record) {
    debugPrint(record.message);
  });
}
