import 'package:flutter/material.dart';
import 'api_models/game_operations.dart';

class LeagueTabs extends StatefulWidget {
  final GameOperationLeague league;

  const LeagueTabs({
    super.key,
    required this.league,
  });

  @override
  _LeagueTabsState createState() => _LeagueTabsState();
}

class _LeagueTabsState extends State<LeagueTabs> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.league.name),
      ),
      body: Center(
        child: Text(
          widget.league.name,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
