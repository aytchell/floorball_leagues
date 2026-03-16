import 'package:collection/collection.dart';
import 'package:floorball/api/models/game_day_title.dart';
import 'package:floorball/api/models/league.dart';
import 'package:floorball/ui/views/game_details/game_league_info.dart';
import 'package:floorball/ui/views/league_details/game_day/game_day_header.dart';
import 'package:floorball/ui/views/league_details/game_day/single_champ_game_day_content.dart';
import 'package:floorball/ui/views/league_details/game_day/single_default_game_day_content.dart';
import 'package:floorball/ui/widgets/custom_expansion_panel_radio.dart';
import 'package:flutter/material.dart';

List<ExpansionPanelRadio> buildGameDayPanels(
  int firstIdentifier,
  int leagueId,
  GameLeagueInfo gameLeagueInfo,
  List<GameDayTitle> gameDayTitles,
) {
  return gameDayTitles
      .mapIndexed(
        (index, gdt) => _buildSingleGameDayPanel(
          firstIdentifier + index,
          leagueId,
          gameLeagueInfo,
          gdt,
        ),
      )
      .toList();
}

ExpansionPanelRadio _buildSingleGameDayPanel(
  int identifier,
  int leagueId,
  GameLeagueInfo gameLeagueInfo,
  GameDayTitle gdt,
) {
  return buildExpansionHeaderPanelRadio(
    value: identifier,
    header: GameDayHeader(leagueId: leagueId, gdt: gdt),
    body: (gameLeagueInfo.leagueType == LeagueType.champ)
        ? SingleChampGameDayContent(
            leagueId: leagueId,
            gameDayNumber: gdt.gameDayNumber,
            gameLeagueInfo: gameLeagueInfo,
          )
        : SingleDefaultGameDayContent(
            gameLeagueInfo: gameLeagueInfo,
            leagueId: leagueId,
            gameDayNumber: gdt.gameDayNumber,
          ),
  );
}
