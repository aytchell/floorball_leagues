import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:floorball/api/saisonmanager.dart';
import 'package:floorball/ui/views/landing/landing_page.dart';
import 'package:floorball/ui/views/season_selector/season_selector_page.dart';
import 'package:floorball/app_state.dart';

final log = Logger('Main');

void setupLogging() {
  // Configure logging level and output
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });
}

final _router = GoRouter(
  initialLocation: LandingPage.routePath,
  routes: [
    GoRoute(
      path: LandingPage.routePath,
      builder: (context, state) => LandingPage(manager: SaisonManager.init()),
    ),
    GoRoute(
      path: SeasonSelectorPage.routePath,
      builder: (context, state) => SeasonSelectorPage(),
    ),
  ],
);

void main() {
  setupLogging();
  runApp(ChangeNotifierProvider(create: (_) => AppState(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Game Operations Grid',
      theme: ThemeData(
        fontFamily: 'NimbusSans',
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routerConfig: _router,
    );
  }
}
