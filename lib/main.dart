import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'ui/all_operations_view/game_operations_grid.dart';
import 'text_theme.dart';

final log = Logger('Main');

void setupLogging() {
  // Configure logging level and output
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });
}

void main() {
  setupLogging();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Game Operations Grid',
      theme: ThemeData(
        fontFamily: 'NimbusSans',
        primarySwatch: Colors.blue,
        textTheme: AppTextTheme.theme,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: GameOperationsGrid(),
    );
  }
}


