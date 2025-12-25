import 'package:collection/collection.dart';
import 'package:floorball/api/blocs/league_game_day_cubit.dart';
import 'package:floorball/api/blocs/tick_cubit.dart';
import 'package:floorball/api/models/game.dart';
import 'package:floorball/api/models/game_day_title.dart';
import 'package:floorball/routes.dart';
import 'package:floorball/ui/views/league_details/date_and_club.dart';
import 'package:floorball/ui/views/league_details/game_result_texts.dart';
import 'package:floorball/ui/widgets/striped_rows_list.dart';
import 'package:floorball/ui/widgets/team_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const futureBold = TextStyle(
  color: Colors.black87,
  fontWeight: FontWeight.w700,
);

const future = TextStyle(color: Colors.black87, fontWeight: FontWeight.normal);

const pastBold = TextStyle(color: Colors.black38, fontWeight: FontWeight.w700);

const past = TextStyle(color: Colors.black38, fontWeight: FontWeight.normal);

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
    headerBuilder: (context, isExpanded) =>
        _buildHeader(context, isExpanded, leagueId, gdt),
    body: _SingleGameDayContent(
      leagueId: leagueId,
      gameDayNumber: gdt.gameDayNumber,
    ),
  );
}

Widget _buildHeader(
  BuildContext context,
  bool isExpanded,
  int leagueId,
  GameDayTitle gdt,
) {
  BlocProvider.of<LeagueGameDayCubit>(
    context,
  ).ensureGamesFor(leagueId, gdt.gameDayNumber);

  return BlocBuilder<LeagueGameDayCubit, GameDaysState>(
    builder: (_, gameDaysState) {
      final games = gameDaysState.gamesOf(leagueId, gdt.gameDayNumber);
      final datesAndClubs = _extractDateAndClubs(games);
      switch (datesAndClubs.length) {
        case 0:
          return ListTile(title: Text(gdt.title, style: futureBold));
        case 1:
          final dac = datesAndClubs.first;
          return _singleDateTile(gdt.title, dac);
        case 2:
          final fst = datesAndClubs[0];
          final snd = datesAndClubs[1];
          return _doubleDateTile(gdt.title, fst, snd);
        default:
          final fst = datesAndClubs.first;
          final lst = datesAndClubs.last;
          return _multiDateTile(gdt.title, fst, lst);
      }
    },
  );
}

Widget _singleDateTile(String title, DateAndClub dac) {
  final styles = _getTextStyles(dac);

  return ListTile(
    title: Text(title, style: styles.bold),
    subtitle: _locationSubtitle(styles, dac),
  );
}

Widget _doubleDateTile(String title, DateAndClub fst, DateAndClub snd) {
  final titleStyle = (fst.isBygone && snd.isBygone) ? pastBold : futureBold;
  return ListTile(
    title: Text(title, style: titleStyle),
    subtitle: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _locationSubtitleWithStyleDetect(fst),
        _locationSubtitleWithStyleDetect(snd),
      ],
    ),
    isThreeLine: true,
  );
}

Widget _multiDateTile(String title, DateAndClub fst, DateAndClub lst) {
  if (fst.date == lst.date) {
    return _multiIsSingleDateTile(title, fst);
  }
  final titleStyle = lst.isBygone ? pastBold : futureBold;
  final fstStyles = _getTextStyles(fst);
  final lstStyles = _getTextStyles(lst);
  return ListTile(
    title: Text(title, style: titleStyle),
    subtitle: RichText(
      text: TextSpan(
        children: [
          TextSpan(text: 'von', style: lstStyles.normal),
          TextSpan(text: ' ${fst.date} ', style: fstStyles.bold),
          TextSpan(text: 'bis', style: lstStyles.normal),
          TextSpan(text: ' ${lst.date}', style: lstStyles.bold),
        ],
      ),
      overflow: TextOverflow.ellipsis,
    ),
  );
}

Widget _multiIsSingleDateTile(String title, DateAndClub dac) {
  final styles = _getTextStyles(dac);
  return ListTile(
    title: Text(title, style: styles.bold),
    subtitle: RichText(
      text: TextSpan(
        children: [
          TextSpan(text: 'am', style: styles.normal),
          TextSpan(text: ' ${dac.date} ', style: styles.bold),
        ],
      ),
      overflow: TextOverflow.ellipsis,
    ),
  );
}

Widget _locationSubtitleWithStyleDetect(DateAndClub dac) =>
    _locationSubtitle(_getTextStyles(dac), dac);

Widget _locationSubtitle(_TextStyles styles, DateAndClub dac) => RichText(
  text: TextSpan(
    children: [
      TextSpan(text: '${dac.date} ', style: styles.bold),
      TextSpan(text: 'bei ${dac.hostingClub}', style: styles.normal),
    ],
  ),
  overflow: TextOverflow.ellipsis,
);

_TextStyles _getTextStyles(DateAndClub dac) => (dac.isBygone)
    ? _TextStyles(past, pastBold)
    : _TextStyles(future, futureBold);

class _TextStyles {
  final TextStyle normal;
  final TextStyle bold;

  _TextStyles(this.normal, this.bold);
}

List<DateAndClub> _extractDateAndClubs(final List<Game> games) {
  // This is a little hack: the date of a game day has a time of 00:00:00
  // whereas 'now' has a valid time. We want a game day to "not be bygone"
  // for the whole day. So instead of adding 23h to each game day time
  // we simply subtract 23h from "today".
  final today = DateTime.now().subtract(Duration(hours: 23, minutes: 59));

  var eventList = games
      .map((game) => DateAndClub.create(game.date!, game.hostingClub!, today))
      .toSet()
      .toList();
  eventList.sort();
  return eventList;
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
        return BlocListener<TickCubit, TickState>(
          listener: (context, tickState) {
            if (_isAnyGameRunning(games, tickState.timestamp)) {
              BlocProvider.of<LeagueGameDayCubit>(
                context,
              ).refreshGamesOf(leagueId, gameDayNumber);
            }
          },
          child: StripedGamesRowsList(games),
        );
      },
    );
  }

  bool _isAnyGameRunning(List<Game> games, DateTime timestamp) =>
      games.any((game) => game.isGameRunning(timestamp));
}

class StripedGamesRowsList extends StripedRowsList<Game> {
  const StripedGamesRowsList(super.entries, {super.key})
    : super(onTap: _goToGame);

  static void _goToGame(BuildContext context, Game game) {
    GameDetailsPageRoute(gameId: game.gameId).push(context);
  }

  @override
  Widget buildRow(BuildContext context, Game game) {
    return Row(
      children: [
        // Left side: Both teams stacked vertically
        _buildBothTeams(game),
        SizedBox(width: 12),
        _buildDateAndResultOrTime(game),
      ],
    );
  }

  Widget _buildBothTeams(Game game) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Home Team
          _buildTeamRow(game.homeLogoSmallUri, game.homeTeamName),
          SizedBox(height: 8),
          // Guest Team
          _buildTeamRow(game.guestLogoSmallUri, game.guestTeamName),
        ],
      ),
    );
  }

  Widget _buildTeamRow(Uri? teamLogo, String? teamName) {
    return Row(
      children: [
        TeamLogo(uri: teamLogo, height: 30, width: 30),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            teamName ?? 'N.N.',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildDateAndResultOrTime(Game game) {
    return Column(
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
    );
  }
}
