import 'package:flutter/material.dart';
import 'api_models/game_operations.dart';
import 'rest_client.dart';

class GameOperationLeagueList extends StatefulWidget {
  final RestClient restClient;
  final int gameOpId;
  final int seasonId;
  
  // Constructor with required and optional parameters
  const GameOperationLeagueList({
    Key? key,
    required this.restClient,
    required this.gameOpId,
    required this.seasonId,
  }) : super(key: key);

  @override
  _GameOperationLeagueListState createState() => _GameOperationLeagueListState();
}

class _GameOperationLeagueListState extends State<GameOperationLeagueList> {
  List<GameOperationLeague> leagues = [];
  
  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final leagues = await AllOperationLeagues.fetchFromServer(
        widget.restClient,
        widget.gameOpId,
        widget.seasonId
        );
    setState(() {
        this.leagues = leagues!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListView.builder(
        itemCount: leagues.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(leagues[index].name),
          );
        },
      ),
    );
  }
}
