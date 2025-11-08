import 'package:collection/collection.dart';
import 'package:floorball/api/blocs/league_game_day_cubit.dart';
import 'package:floorball/api/models/game.dart';
import 'package:floorball/api/models/game_day_title.dart';
import 'package:floorball/routes.dart';
import 'package:floorball/ui/views/league_details_2/game_result_texts.dart';
import 'package:floorball/ui/widgets/striped_table_row.dart';
import 'package:floorball/ui/widgets/team_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

List<ExpansionPanelRadio> buildGameDayPanels(
  int firstIdentifier,
  int leagueId,
  List<GameDayTitle> gameDayTitles,
) {
  return gameDayTitles
      .mapIndexed(
        (index, gdt) =>
            _buildSingleGameDayPanel(firstIdentifier + index, leagueId, gdt),
      )
      .toList();
}

ExpansionPanelRadio _buildSingleGameDayPanel(
  int identifier,
  int leagueId,
  GameDayTitle gdt,
) {
  return ExpansionPanelRadio(
    value: identifier,
    canTapOnHeader: true,
    headerBuilder: (BuildContext context, bool isExpanded) {
      return ListTile(title: Text(gdt.title));
    },
    body: _SingleGameDayContent(
      leagueId: leagueId,
      gameDayNumber: gdt.gameDayNumber,
    ),
  );
}

class _SingleGameDayContent extends StatelessWidget {
  final int leagueId;
  final int gameDayNumber;

  const _SingleGameDayContent({
    required this.leagueId,
    required this.gameDayNumber,
  });

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<LeagueGameDayCubit>(
      context,
    ).ensureGamesFor(leagueId, gameDayNumber);

    return BlocBuilder<LeagueGameDayCubit, GameDaysState>(
      builder: (_, gameDaysState) {
        final games = gameDaysState.gamesOf(leagueId, gameDayNumber);
        return Column(
          children: games
              .asMap()
              .entries
              .map(
                (entry) => StripedTableRow(
                  index: entry.key,
                  child: _buildRowWithGame(context, entry.value),
                ),
              )
              .toList(),
        );
      },
    );
  }

  Widget _buildRowWithGame(BuildContext context, Game game) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: InkWell(
        onTap: () => GameDetailsPageRoute(gameId: game.gameId).push(context),
        child: Row(
          children: [
            // Left side: Both teams stacked vertically
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Home Team
                  Row(
                    children: [
                      TeamLogo(
                        uri: game.homeLogoSmallUri,
                        height: 30,
                        width: 30,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          game.homeTeamName ?? 'N.N.',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  // Guest Team
                  Row(
                    children: [
                      TeamLogo(
                        uri: game.guestLogoSmallUri,
                        height: 30,
                        width: 30,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          game.guestTeamName ?? 'N.N.',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 16),
            // Right side: Date above score
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Date
                Text(
                  game.beautifiedDate ?? 'Datum unbekannt',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 2),
                // Score
                ...buildResultTexts(game),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
