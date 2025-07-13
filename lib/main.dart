import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'restClient.dart';
import 'apiModels/entryInfo.dart';
import 'apiModels/gameOperations.dart';

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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Game Operations Grid',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: GameOperationsGrid(),
    );
  }
}

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
        title: Text('Game Operations'),
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

class GameOperationCard extends StatelessWidget {
  final GameOperation gameOperation;
  final VoidCallback onTap;

  const GameOperationCard({
    Key? key,
    required this.gameOperation,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(8),
                child: gameOperation.logoUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          gameOperation.logoUrl.toString(),
                          fit: BoxFit.contain,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                              child: Icon(
                                Icons.error_outline,
                                size: 50,
                                color: Colors.grey[600],
                              ),
                            );
                          },
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: Colors.grey[600],
                        ),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    gameOperation.name ?? 'Unknown Game',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
