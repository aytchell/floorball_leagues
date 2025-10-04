import 'package:flutter/material.dart';
import 'package:floorball/api/models/season_info.dart';
import 'package:floorball/api/models/game_operation.dart';
import 'package:floorball/api/models/game_operation_league.dart';
import 'package:floorball/ui/views/league_details/league_details_page.dart';
import 'package:floorball/ui/main_app_scaffold.dart';
import 'package:floorball/ui/widgets/nothing_found.dart';
import 'package:floorball/ui/widgets/loading_spinner.dart';

class LeaguesListPage extends StatefulWidget {
  final GameOperation gameOp;
  final SeasonInfo selectedSeason;

  const LeaguesListPage({
    super.key,
    required this.gameOp,
    required this.selectedSeason,
  });

  @override
  _LeaguesListPageState createState() => _LeaguesListPageState();
}

class _LeaguesListPageState extends State<LeaguesListPage> {
  List<GameOperationLeague> leagues = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final leagues = await widget.gameOp.getLeagues(widget.selectedSeason.id);
      setState(() {
        this.leagues = leagues!;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainAppScaffold(
      title: widget.gameOp.name,
      showBackButton: true,
      body: _buildBody(context),
      selectedSeason: widget.selectedSeason,
    );
  }

  Widget _buildBody(BuildContext context) {
    if (isLoading) {
      return LoadingSpinner(title: 'Lade Liga-Daten ...');
    } else if (leagues.length > 0) {
      return _buildLeaguesList(context);
    } else {
      return _buildNothingFoundInfo(context);
    }
  }

  Widget _buildLeaguesList(BuildContext context) {
    return ListView.builder(
      itemCount: leagues.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      LeagueDetailsPage(league: leagues[index]),
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
    return NothingFoundInfoBox(
      title: 'Keine Liga-Liste verfügbar',
      message:
          'Es wurden keine Daten zu Ligen innerhalb "${widget.gameOp.name}" gefunden. Mögliche Gründe sind:\n\n * Der Server ist gerade nicht verfügbar\n * Es wurden noch keine Spieldaten eingetragen\n * Es gibt ein Problem mit der Internetverbindung',
      isLoading: isLoading,
      onRetry: loadData,
    );
  }
}
