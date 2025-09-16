import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:logging/logging.dart';
import 'game_operation_card.dart';
import '../fed_op_leagues/leagues_list.dart';
import '../../net/rest_client.dart';
import '../../api/models/entry_info.dart';
import '../../api/models/season_info.dart';
import '../../api/models/game_operation.dart';
import '../../api/saisonmanager.dart';
import '../app_text_styles.dart';
import '../main_app_scaffold.dart';
import '../../app_state.dart';

final log = Logger('GameOperationsGrid');

class GameOperationsGrid extends StatefulWidget {
  const GameOperationsGrid({super.key});

  @override
  _GameOperationsGridState createState() => _GameOperationsGridState();
}

class _GameOperationsGridState extends State<GameOperationsGrid> {
  List<GameOperation> gameOperations = [];
  List<SeasonInfo> seasons = [];
  SeasonInfo? selectedSeason;
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
      log.info('Loding game operations');
      final manager = Saisonmanager(client: restClient!);
      final entryInfo = await manager.getStart();
      if (entryInfo != null) {
        final appState = Provider.of<AppState>(context, listen: false);
        final allSeasons = _findAllSeasons(appState, entryInfo);
        final selectedSeason = _findSelectedSeason(appState, entryInfo);
        log.info('Selected season is ${selectedSeason!.name}');

        setState(() {
          gameOperations = entryInfo.gameOperations;
          seasons = allSeasons;
          this.selectedSeason = selectedSeason;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Handle error
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading data: $e')));
      }
    }
  }

  List<SeasonInfo> _findAllSeasons(AppState appState, EntryInfo entryInfo) {
    final allSeasons = appState.allSeasons;
    if (allSeasons.isNotEmpty) {
      return allSeasons;
    } else {
      appState.setSeasonList(entryInfo!.seasons);
      return entryInfo!.seasons;
    }
  }

  SeasonInfo? _findSelectedSeason(AppState appState, EntryInfo entryInfo) {
    final selectedSeason = appState.selectedSeason;

    if (selectedSeason != null) return selectedSeason;
    SeasonInfo? info;
    try {
      info = entryInfo.seasons.firstWhere((season) => season.current);
    } catch (e) {
      // If no current season found, use the first one
      info = entryInfo.seasons.isNotEmpty ? entryInfo.seasons.first : null;
    }
    if (info != null) {
      appState.setSelectedSeason(info!);
    }
    return info;
  }

  @override
  Widget build(BuildContext context) {
    final subTitle = (selectedSeason == null)
        ? ""
        : '\nSaison ${selectedSeason!.name}';

    return MainAppScaffold(
      title: 'Floorball Landesverbände$subTitle',
      isHomePage: true,
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          return _buildBody();
        },
      ),
      selectedSeason: selectedSeason,
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (gameOperations.isEmpty) {
      return Center(
        child: Text(
          'No game operations found',
          style: AppTextStyles.gameOpLoadingError,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
    );
  }

  void _onGameOperationTap(GameOperation gameOp) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameOperationLeagueList(
          gameOp: gameOp,
          selectedSeason: selectedSeason!,
        ),
      ),
    );
  }
}
