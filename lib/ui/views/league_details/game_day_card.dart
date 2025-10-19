import 'dart:collection';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:floorball/api/models/game_operation_league.dart';
import 'package:floorball/ui/views/league_details/game_card.dart';
import 'package:floorball/ui/views/league_details/game_day_table.dart';
import 'package:floorball/api/models/game.dart';
import 'package:floorball/ui/views/league_details/date_and_club.dart';
import 'package:floorball/ui/widgets/expandable_card.dart';
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

class ExpandableGameDayCard extends StatelessWidget {
  const ExpandableGameDayCard({
    Key? key,
    required this.league,
    required this.gameDayNumber,
    required this.title,
    required this.games,
    required this.isExpanded,
    required this.onTap,
  }) : super(key: key);

  final GameOperationLeague league;
  final int gameDayNumber;
  final String title;
  final List<Game> games;
  final bool isExpanded;
  final VoidCallback onTap;

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
  Widget build(BuildContext context) {
    return ExpandableCard(
      title: title,
      isExpanded: isExpanded,
      onTap: onTap,
      expandedBackgroundColor: expandedBackgroundColor,
      expandedContentBackgroundColor: expandedContentBackgroundColor,
      customHeader: Column(
        children: [_buildGameDayTitle(), ..._buildGameDateAndClubs()],
      ),
      child: _buildGamesTable(),
    );
  }

  Widget _buildButtonLikeHeader() {
    final List<Row> rows = [];
    rows.add(_buildGameDayTitle());
    rows.addAll(_buildGameDateAndClubs());

    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: isExpanded ? expandedBackgroundColor : Colors.white,
          borderRadius: isExpanded
              ? const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                )
              : BorderRadius.circular(4),
        ),
        child: Column(children: rows),
      ),
    );
  }

  Row _buildGameDayTitle() {
    final expandedStyle = AppTextStyles.gameDayTitleExpanded;
    final collapsedStyle = AppTextStyles.gameDayTitleCollapsed;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: isExpanded ? expandedStyle : collapsedStyle),
        Icon(
          isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
          color: isExpanded ? expandedTextColor : collapsedIconColor,
        ),
      ],
    );
  }

  List<Row> _buildGameDateAndClubs() {
    final dateAndClubs = _extractDateAndClubs();
    final dateStyle = isExpanded ? _expandedDateStyle : _collapsedDateStyle;
    final textStyle = isExpanded ? _expandedTextStyle : _collapsedTextStyle;
    final bygoneDateStyle = isExpanded
        ? _expandedBygoneDateStyle
        : _collapsedBygoneDateStyle;
    final bygoneTextStyle = isExpanded
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
        Text('${dac.date}', style: dateStyle),
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
        Text('${dacs.first.date}', style: dateStyle),
        Text(' bis ', style: textStyle),
        Text('${dacs.last.date}', style: dateStyle),
      ],
    );
  }

  List<DateAndClub> _extractDateAndClubs() {
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

  Widget _buildExpandableContent() {
    // Expandable content
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: isExpanded ? null : 0,
      child: isExpanded
          ? Container(
              width: double.infinity,
              padding: const EdgeInsets.all(4.0),
              decoration: const BoxDecoration(
                color: expandedContentBackgroundColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(4),
                  bottomRight: Radius.circular(4),
                ),
              ),
              child: _buildGamesTable(),
            )
          : const SizedBox.shrink(),
    );
  }

  Map<String, GameSubDayInfo> _groupBySubday(List<Game> games) {
    // entries in map should be sorted by key
    final groups = SplayTreeMap.from(
      groupBy(games, (game) => "${game.date}\n${game.hostingClub}"),
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

  Widget _buildGamesTable() {
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
    return SportGamesTable(leagueName: league.name, subdays: gameData);
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
