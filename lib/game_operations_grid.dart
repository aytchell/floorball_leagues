import 'package:flutter/material.dart';
import 'game_operation_card.dart';
import 'rest_client.dart';
import 'api_models/entry_info.dart';
import 'api_models/game_operations.dart';

class GameOperationsGrid extends StatefulWidget {
  @override
  _GameOperationsGridState createState() => _GameOperationsGridState();
}

class _GameOperationsGridState extends State<GameOperationsGrid> {
  List<GameOperation> gameOperations = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final restClient = await RestClient.create();
    try {
      final entryInfo = await EntryInfo.fetchFromServer(restClient);
      setState(() {
        gameOperations = entryInfo!.gameOperations;
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
    // Handle tap - navigate to game details, etc.
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(gameOp.name ?? 'Unknown Game'),
        content: Text('Short Name: ${gameOp.shortName ?? 'N/A'}\nPath: ${gameOp.path ?? 'N/A'}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}

