import 'package:flutter/material.dart';
import 'api_models/game_operations.dart';
import 'rest_client.dart';
import 'league_tabs.dart';

class GameOperationLeagueList extends StatefulWidget {
  final int gameOpId;
  final String gameOpName;
  final int seasonId;

  // Constructor with required and optional parameters
  const GameOperationLeagueList({
    super.key,
    required this.gameOpId,
    required this.gameOpName,
    required this.seasonId,
  });

  @override
  _GameOperationLeagueListState createState() =>
      _GameOperationLeagueListState();
}

class _GameOperationLeagueListState extends State<GameOperationLeagueList> {
  RestClient? restClient;
  List<GameOperationLeague> leagues = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    restClient ??= await RestClient.instance;
    final leagues = await AllOperationLeagues.fetchFromServer(
      restClient!,
      widget.gameOpId,
      widget.seasonId,
    );
    setState(() {
      this.leagues = leagues!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.gameOpName)),
      body: ListView.builder(
        itemCount: leagues.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LeagueTabs(league: leagues[index]),
                  ),
                );
              },
              style: TextButton.styleFrom(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.zero,
              ),
              child: Text(leagues[index].name),
            ),
          );
        },
      ),
    );
  }
}
