import 'package:flutter/material.dart';
import '../../api_models/game_operations.dart';
import '../../net/rest_client.dart';
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
      appBar: AppBar(
        title: Text(widget.gameOpName, maxLines: 2),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
      ),
      body: (leagues.length > 0)
          ? _buildLeagesList(context)
          : _buildNothingFoundInfo(context),
    );
  }

  Widget _buildLeagesList(BuildContext context) {
    return ListView.builder(
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
    );
  }

  Widget _buildNothingFoundInfo(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.info_outline, size: 64, color: Colors.blue[600]),
                const SizedBox(height: 16),
                Text(
                  'Keine Liga-Liste verfügbar',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Es wurden keine Daten zu Ligen innerhalb "${widget.gameOpName}" gefunden. Mögliche Gründe sind:\n\n * Der Server ist gerade nicht verfügbar\n * Es wurden noch keine Spieldaten eingetragen\n * Es gibt ein Problem mit der Internetverbindung',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    // Add your refresh logic here
                    // setState(() {
                    //   // Reload leagues
                    // });
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Try Again'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
