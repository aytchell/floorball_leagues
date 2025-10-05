import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:logging/logging.dart';
import 'package:floorball/ui/views/landing/game_operation_card.dart';
import 'package:floorball/ui/views/leagues_list/leagues_list_page.dart';
import 'package:floorball/api/models/entry_info.dart';
import 'package:floorball/api/models/season_info.dart';
import 'package:floorball/api/models/game_operation.dart';
import 'package:floorball/api/saisonmanager.dart';
import 'package:floorball/ui/app_text_styles.dart';
import 'package:floorball/ui/main_app_scaffold.dart';
import 'package:floorball/ui/widgets/loading_spinner.dart';
import 'package:floorball/app_state.dart';

final log = Logger('LandingPage');

class LandingPage extends StatefulWidget {
  LandingPage({super.key, required this.manager});

  final Future<SaisonManager> manager;

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  List<GameOperation> gameOperations = [];
  List<SeasonInfo> seasons = [];

  SeasonInfo? selectedSeason;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void _setStateFromEntryInfo(EntryInfo info) {
    final appState = Provider.of<AppState>(context, listen: false);
    final allSeasons = _findAllSeasons(appState, info);
    final selectedSeason = _findSelectedSeason(appState, info);
    log.info('Selected season is ${selectedSeason!.name}');

    setState(() {
      gameOperations = info.gameOperations;
      seasons = allSeasons;
      this.selectedSeason = selectedSeason;
      isLoading = false;
    });
  }

  Future<void> loadData() async {
    final manager = await widget.manager;

    manager.getStart().forEach((futureInfo) {
      futureInfo.then((info) => _setStateFromEntryInfo(info));
    });
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
      return const LoadingSpinner(title: 'Lade Verbände ...');
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
        builder: (context) =>
            LeaguesListPage(gameOp: gameOp, selectedSeason: selectedSeason!),
      ),
    );
  }
}
