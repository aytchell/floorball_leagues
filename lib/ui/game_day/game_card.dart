import 'package:flutter/material.dart';
import '../../api/models/game.dart';
import '../app_text_styles.dart';
import 'game_detail_page.dart';
import '../widgets/team_logo.dart';

class GameResultSlice {
  final Game game;

  GameResultSlice({required this.game});

  int get gameId => game.gameId;
  String? get homeTeamName => game.homeTeamName;
  Uri? get homeLogoUri => game.homeLogoSmallUri;
  String? get guestTeamName => game.guestTeamName;
  Uri? get guestLogoUri => game.guestLogoSmallUri;

  bool get hasStarted => game.started ?? false;
  bool get hasEnded => game.ended ?? false;
  String get time => game.time ?? '??:??';
  String get result => game.resultString ?? '- : -';

  String? get seriesName =>
      _translateGroupIdentifier(game.groupIdentifier) ??
      _translateSeriesTitle(game.seriesTitle) ??
      null;

  String? _translateGroupIdentifier(String? groupIdentifier) {
    if (groupIdentifier == null) return null;

    switch (groupIdentifier!) {
      case 'group_a':
        return 'Gruppe A';
      case 'group_b':
        return 'Gruppe B';
      case 'group_c':
        return 'Gruppe C';
      case 'group_d':
        return 'Gruppe D';
      case 'group_e':
        return 'Gruppe E';
      case 'group_f':
        return 'Gruppe F';
      case 'group_g':
        return 'Gruppe G';
      case 'group_h':
        return 'Gruppe H';
      default:
        return groupIdentifier!;
    }
  }

  String? _translateSeriesTitle(String? seriesTitle) {
    if (seriesTitle == 'Spiel um Platz 3') return 'Platz 3';
    if (seriesTitle == 'Spiel im Platz 3') // sic!
      return 'Platz 3';
    if (seriesTitle == 'Spiel um Platz 5') return 'Platz 5';
    if (seriesTitle == 'Spiel um Platz 7') return 'Platz 7';
    return seriesTitle;
  }
}

class GameCard extends StatelessWidget {
  final GameResultSlice game;

  GameCard({Key? key, required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => GameDetailPage(gameId: game.gameId),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.only(bottom: 12.0),
        elevation: 2,
        child: Container(
          decoration: game.seriesName != null
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  color: Colors.blue.shade50,
                )
              : null,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Series name column (if exists)
                if (game.seriesName != null)
                  _buildSeriesNameColumn(game.seriesName!),

                // Main content area
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        // Left side: Team logos and names (stacked vertically)
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Home team
                              _buildTeamRow(
                                game.homeLogoUri,
                                game.homeTeamName,
                              ),

                              SizedBox(height: 8.0),

                              // Guest team
                              _buildTeamRow(
                                game.guestLogoUri,
                                game.guestTeamName,
                              ),
                            ],
                          ),
                        ),

                        SizedBox(width: 16.0),

                        // Right side: Result (vertically centered)
                        Expanded(flex: 1, child: _buildGameResult(game)),
                      ],
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

  Widget _buildSeriesNameColumn(String seriesName) {
    return Container(
      width: 20.0,
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(4.0),
          bottomLeft: Radius.circular(4.0),
        ),
      ),
      child: Center(
        child: RotatedBox(
          quarterTurns: 3, // 270 degrees (90 degrees counterclockwise)
          child: Text(
            seriesName,
            style: TextStyle(
              fontSize: 11.0,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildTeamRow(Uri? logoUri, String? teamName) {
    return Row(
      children: [
        TeamLogo(uri: logoUri, width: 32, height: 32),
        SizedBox(width: 12.0),
        _buildTeamName(teamName),
      ],
    );
  }

  Widget _buildGameResult(GameResultSlice game) {
    final TextStyle textStyle = AppTextStyles.gameCardResultFont;

    if (game.hasEnded) {
      return Container(
        alignment: Alignment.center,
        child: Text(game.result, style: textStyle, textAlign: TextAlign.center),
      );
    } else if (game.hasStarted) {
      return Container(
        alignment: Alignment.center,
        child: Text(
          game.result,
          style: textStyle.copyWith(color: Colors.pink),
          textAlign: TextAlign.center,
        ),
      );
    } else {
      final startTime = (game.time == null || game.time.isEmpty)
          ? '??'
          : game.time;
      return Container(
        alignment: Alignment.center,
        child: Text(
          '$startTime Uhr',
          style: textStyle,
          textAlign: TextAlign.center,
        ),
      );
    }
  }

  Widget _buildTeamName(String? teamName) {
    if (teamName != null) {
      return Expanded(
        child: Text(
          teamName!,
          style: AppTextStyles.gameCardTeamFont,
          overflow: TextOverflow.ellipsis,
        ),
      );
    } else {
      return Expanded(
        child: Text(
          'Noch nicht bekannt',
          style: AppTextStyles.gameCardTeamFont.copyWith(color: Colors.grey),
          overflow: TextOverflow.ellipsis,
        ),
      );
    }
  }
}
