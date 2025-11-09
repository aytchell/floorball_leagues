import 'dart:collection';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:floorball/api/models/league.dart';
import 'package:floorball/ui/views/league_details/game_card.dart';
import 'package:floorball/ui/views/league_details/game_day_table.dart';
import 'package:floorball/api/models/game.dart';
import 'package:floorball/api/models/game_day_title.dart';
import 'package:floorball/ui/views/league_details/date_and_club.dart';
import 'package:floorball/ui/widgets/expandable_card.dart';
import 'package:floorball/ui/widgets/loading_spinner.dart';
import 'package:floorball/ui/app_text_styles.dart';

class GameSubDayInfo {
  final String dateAtClub;
  final String arenaName;
  final String arenaAddress;
  final List<Game> games;

  GameSubDayInfo({
    required this.dateAtClub,
    required this.arenaName,
    required this.arenaAddress,
    required this.games,
  });
}

class ExpandableGameDayCard extends StatefulWidget {
  ExpandableGameDayCard({
    super.key,
    required this.league,
    required this.gameDayTitle,
    required this.isExpanded,
    required this.onTap,
  }) : leagueType = league.leagueType ?? 'league';

  final League league;
  final GameDayTitle gameDayTitle;
  final bool isExpanded;
  final VoidCallback onTap;
  final String leagueType;

  @override
  ExpandableGameDayCardState createState() => ExpandableGameDayCardState();
}

class ExpandableGameDayCardState extends State<ExpandableGameDayCard> {
  List<Game> games = [];
  bool isLoading = true;

  // Define color constants to avoid accessing theme colors in static contexts
  static const Color expandedTextColor = Color(
    0xFF1976D2,
  ); // Colors.blue.shade700
  static const Color expandedBygoneTextColor = Color(
    0xFF90CAF9,
  ); // Colors.blue.shade200
  static const Color expandedBackgroundColor = Color(
    0xFFE3F2FD,
  ); // Colors.blue[50]
  static const Color collapsedIconColor = Color(0xFF757575); // Colors.grey[600]
  static const Color expandedContentBackgroundColor = Color(
    0xFFFAFAFA,
  ); // Colors.grey[50]

  // Text styles as instance getters to access theme if needed
  TextStyle get _expandedDateStyle => const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: expandedTextColor,
  );

  TextStyle get _expandedTextStyle => const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w200,
    color: expandedTextColor,
  );

  TextStyle get _collapsedDateStyle => const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );

  TextStyle get _collapsedTextStyle => const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w200,
    color: Colors.black87,
  );

  TextStyle get _expandedBygoneDateStyle => const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: expandedTextColor,
  );

  TextStyle get _expandedBygoneTextStyle => const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w200,
    color: expandedTextColor,
  );

  TextStyle get _collapsedBygoneDateStyle => const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: Colors.black38,
  );

  TextStyle get _collapsedBygoneTextStyle => const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w200,
    color: Colors.black38,
  );

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    int number = widget.gameDayTitle.gameDayNumber;
    widget.league.getGames(number).forEach((futureGamesList) {
      futureGamesList.then((gamesList) => _setStateFromGamesList(gamesList));
    });
  }

  void _setStateFromGamesList(List<Game> games) {
    setState(() {
      this.games = games;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const LoadingSpinner(title: 'Lade Spieltage ...');
    }

    final gameDayTitle = _computeTitle(widget.gameDayTitle.title, games);

    return ExpandableCard(
      title: gameDayTitle,
      isExpanded: widget.isExpanded,
      onTap: widget.onTap,
      expandedBackgroundColor: expandedBackgroundColor,
      expandedContentBackgroundColor: expandedContentBackgroundColor,
      customHeader: Column(
        children: [
          _buildGameDayTitle(gameDayTitle),
          ..._buildGameDateAndClubs(games),
        ],
      ),
      child: _buildGamesTable(games),
    );
  }

  String _computeTitle(final String title, final List<Game> games) {
    if (widget.leagueType == 'champ') {
      final groups = games
          .map((game) => [_groupIdentifier(game), _seriesTitle(game)].nonNulls)
          .expand((i) => i)
          .toSet();
      var type = '';
      if (groups.length == 1) {
        type = '(${groups.first})';
      } else if (groups.length == 2) {
        type = '(Gruppen/Platzierung)';
      }

      return '$title $type';
      // } else if (widget.leagueType == 'cup') {
      // TODO
    } else {
      return title;
    }
  }

  String? _groupIdentifier(Game game) {
    final ident = game.groupIdentifier;
    return (ident != null) ? 'Gruppenphase' : null;
  }

  String? _seriesTitle(Game game) {
    final title = game.seriesTitle;
    return (title != null) ? 'Platzierungsphase' : null;
  }

  Row _buildGameDayTitle(String title) {
    final expandedStyle = AppTextStyles.gameDayTitleExpanded;
    final collapsedStyle = AppTextStyles.gameDayTitleCollapsed;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: widget.isExpanded ? expandedStyle : collapsedStyle),
        Icon(
          widget.isExpanded
              ? Icons.keyboard_arrow_up
              : Icons.keyboard_arrow_down,
          color: widget.isExpanded ? expandedTextColor : collapsedIconColor,
        ),
      ],
    );
  }

  List<Row> _buildGameDateAndClubs(List<Game> games) {
    final dateAndClubs = _extractDateAndClubs(games);
    final dateStyle = widget.isExpanded
        ? _expandedDateStyle
        : _collapsedDateStyle;
    final textStyle = widget.isExpanded
        ? _expandedTextStyle
        : _collapsedTextStyle;
    final bygoneDateStyle = widget.isExpanded
        ? _expandedBygoneDateStyle
        : _collapsedBygoneDateStyle;
    final bygoneTextStyle = widget.isExpanded
        ? _expandedBygoneTextStyle
        : _collapsedBygoneTextStyle;
    if (dateAndClubs.length <= 3) {
      return dateAndClubs
          .map(
            (dac) => _buildSingleDateAndClubRow(
              dac,
              dateStyle,
              textStyle,
              bygoneDateStyle,
              bygoneTextStyle,
            ),
          )
          .toList();
    } else {
      return [
        _buildCombinedDateAndClubRow(
          dateAndClubs,
          dateStyle,
          textStyle,
          bygoneDateStyle,
          bygoneTextStyle,
        ),
      ];
    }
  }

  Row _buildSingleDateAndClubRow(
    DateAndClub dac,
    TextStyle upcomingDateStyle,
    TextStyle upcomingTextStyle,
    TextStyle bygoneDateStyle,
    TextStyle bygoneTextStyle,
  ) {
    final isBygone = dac.isBygone;
    final textStyle = isBygone ? bygoneTextStyle : upcomingTextStyle;
    final dateStyle = isBygone ? bygoneDateStyle : upcomingDateStyle;
    return Row(
      children: [
        Text(dac.date, style: dateStyle),
        Text(' bei ${dac.hostingClub}', style: textStyle),
      ],
    );
  }

  Row _buildCombinedDateAndClubRow(
    List<DateAndClub> dacs,
    TextStyle upcomingDateStyle,
    TextStyle upcomingTextStyle,
    TextStyle bygoneDateStyle,
    TextStyle bygoneTextStyle,
  ) {
    final isBygone = dacs.last.isBygone;
    final textStyle = isBygone ? bygoneTextStyle : upcomingTextStyle;
    final dateStyle = isBygone ? bygoneDateStyle : upcomingDateStyle;

    return Row(
      children: [
        Text('von ', style: textStyle),
        Text(dacs.first.date, style: dateStyle),
        Text(' bis ', style: textStyle),
        Text(dacs.last.date, style: dateStyle),
      ],
    );
  }

  List<DateAndClub> _extractDateAndClubs(final List<Game> games) {
    // This is a little hack: the date of a game day has a time of 00:00:00
    // whereas 'now' has a valid time. We want a game day to "not be bygone"
    // for the whole day. So instead of adding 23h to each game day time
    // we simply subtract 23h from "today".
    final today = DateTime.now().subtract(Duration(hours: 23));

    var eventList = games
        .map((game) => DateAndClub.create(game.date!, game.hostingClub!, today))
        .toSet()
        .toList();
    eventList.sort();
    return eventList;
  }

  Map<String, GameSubDayInfo> _groupBySubday(List<Game> games) {
    // entries in map should be sorted by key
    final groups = SplayTreeMap.from(
      groupBy(games, (game) => '${game.date}\n${game.hostingClub}'),
    );
    return groups.map(
      (key, value) => MapEntry(
        key,
        GameSubDayInfo(
          dateAtClub: key,
          arenaName: value[0].arenaName!,
          arenaAddress: value[0].arenaAddress!,
          games: value,
        ),
      ),
    );
  }

  Widget _buildGamesTable(List<Game> games) {
    final gameData = _groupBySubday(games).entries
        .map(
          (sub) => GameSubdayRows(
            info: _buildGameSubDayInfoCard(sub.value),
            games: sub.value.games
                .map((game) => GameResultSlice(game: game))
                .toList(),
          ),
        )
        .toList();
    return SportGamesTable(leagueName: widget.league.name, subdays: gameData);
  }

  Widget _buildGameSubDayInfoCard(GameSubDayInfo info) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Text(info.dateAtClub, style: AppTextStyles.gameSubDayTitle),
            subtitle: Text(
              info.arenaName,
              style: AppTextStyles.gameSubDaySubTitle,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextButton(
                child: const Text('Navigieren'),
                onPressed: () {
                  /* ... */
                },
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
    );
  }
}
