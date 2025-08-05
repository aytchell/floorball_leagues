import 'package:flutter/material.dart';
import 'game_operation_card.dart';
import '../fed_op_leagues/leagues_list.dart';
import '../../net/rest_client.dart';
import '../../api_models/entry_info.dart';
import '../app_text_styles.dart';

class GameOperationsGrid extends StatefulWidget {
  const GameOperationsGrid({super.key});

  @override
  _GameOperationsGridState createState() => _GameOperationsGridState();
}

class _GameOperationsGridState extends State<GameOperationsGrid> {
  List<GameOperation> gameOperations = [];
  List<SeasonInfo> seasons = [];
  SeasonInfo? season;
  int? seasonId;
  RestClient? restClient;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    restClient ??= await RestClient.instance;
    try {
      final entryInfo = await EntryInfo.fetchFromServer(restClient!);
      setState(() {
        gameOperations = entryInfo!.gameOperations;
        seasons = entryInfo!.seasons;
        season = (seasonId == null)
            ? entryInfo!.seasons.firstWhere((season) => season.current)
            : entryInfo!.seasons.firstWhere((season) => season.id == seasonId!);
        seasonId = season?.id ?? entryInfo.currentSeasonId;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Handle error
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error loading data: $e')));
    }
  }

  void _onSeasonSelected(SeasonInfo selectedSeason) {
    setState(() {
      seasonId = selectedSeason.id;
      season = selectedSeason;
    });
    Navigator.pop(context); // Close the drawer
  }

  @override
  Widget build(BuildContext context) {
    final subTitle = (season == null) ? "" : '\nSaison ${season!.name}';
    return Scaffold(
      appBar: AppBar(
        title: Text('Floorball Landesverbände${subTitle}'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
      ),
      drawer: _buildSeasonDrawer(),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : gameOperations.isEmpty
          ? Center(
              child: Text(
                'No game operations found',
                style: AppTextStyles.gameOpLoadingError,
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

  Widget _buildSeasonDrawer() {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue[600]),
            child: Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Saison auswählen',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: seasons.length,
              itemBuilder: (context, index) {
                final seasonInfo = seasons[index];
                final isCurrentSeason = seasonInfo.id == seasonId;

                return ListTile(
                  leading: Icon(
                    isCurrentSeason
                        ? Icons.check_circle
                        : Icons.circle_outlined,
                    color: isCurrentSeason ? Colors.blue[600] : Colors.grey,
                  ),
                  title: Text(
                    seasonInfo.name,
                    style: TextStyle(
                      fontWeight: isCurrentSeason
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isCurrentSeason
                          ? Colors.blue[600]
                          : Colors.black87,
                    ),
                  ),
                  trailing: seasonInfo.current
                      ? Chip(
                          label: Text(
                            'Aktuell',
                            style: TextStyle(fontSize: 10, color: Colors.white),
                          ),
                          backgroundColor: Colors.green,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        )
                      : null,
                  onTap: () => _onSeasonSelected(seasonInfo),
                  selected: isCurrentSeason,
                  selectedTileColor: Colors.blue[50],
                );
              },
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '${seasons.length} Saisons verfügbar',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  void _onGameOperationTap(GameOperation gameOp) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameOperationLeagueList(
          gameOpId: gameOp.id!,
          gameOpName: gameOp.name!,
          seasonId: seasonId!,
        ),
      ),
    );
  }
}
