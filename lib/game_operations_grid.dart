import 'package:flutter/material.dart';
import 'game_operation_card.dart';
import 'leagues_list.dart';
import 'rest_client.dart';
import 'api_models/entry_info.dart';

class GameOperationsGrid extends StatefulWidget {
  const GameOperationsGrid({super.key});

  @override
  _GameOperationsGridState createState() => _GameOperationsGridState();
}

class _GameOperationsGridState extends State<GameOperationsGrid> {
  List<GameOperation> gameOperations = [];
  int? currentSeasonId;
  RestClient? restClient;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    restClient ??= await RestClient.create();
    try {
      final entryInfo = await EntryInfo.fetchFromServer(restClient!);
      setState(() {
        gameOperations = entryInfo!.gameOperations;
        currentSeasonId = entryInfo.currentSeasonId!;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Floorball Ligen'),
        backgroundColor: Colors.blue,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : gameOperations.isEmpty
              ? Center(
                  child: Text(
                    'No game operations found',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Two columns
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.8, // Adjust based on your needs
                    ),
                    itemCount: gameOperations.length,
                    itemBuilder: (context, index) {
                      final gameOp = gameOperations[index];
                      return GameOperationCard(
                        gameOperation: gameOp,
                        onTap: () => _onGameOperationTap(gameOp),
                      );
                    },
                  ),
                ),
    );
  }

  void _onGameOperationTap(GameOperation gameOp) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>
        GameOperationLeagueList(
          restClient: restClient!,
          gameOpId: gameOp.id!,
          seasonId: currentSeasonId!
        )
      ),
    );
  }
}

