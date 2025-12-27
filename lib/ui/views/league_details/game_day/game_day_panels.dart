import 'package:collection/collection.dart';
import 'package:floorball/api/blocs/league_game_day_cubit.dart';
import 'package:floorball/api/models/game.dart';
import 'package:floorball/api/models/game_day_title.dart';
import 'package:floorball/api/models/league.dart';
import 'package:floorball/ui/theme/text_styles.dart';
import 'package:floorball/ui/views/league_details/date_and_club.dart';
import 'package:floorball/ui/views/league_details/game_day/single_champ_game_day_content.dart';
import 'package:floorball/ui/views/league_details/game_day/single_default_game_day_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const _futureBold = TextStyles.gameDayHeaderFutureBold;
const _future = TextStyles.gameDayHeaderFuture;
const _pastBold = TextStyles.gameDayHeaderPastBold;
const _past = TextStyles.gameDayHeaderPast;

List<ExpansionPanelRadio> buildGameDayPanels(
  int firstIdentifier,
  int leagueId,
  LeagueType leagueType,
  List<GameDayTitle> gameDayTitles,
) {
  return gameDayTitles
      .mapIndexed(
        (index, gdt) => _buildSingleGameDayPanel(
          firstIdentifier + index,
          leagueId,
          leagueType,
          gdt,
        ),
      )
      .toList();
}

ExpansionPanelRadio _buildSingleGameDayPanel(
  int identifier,
  int leagueId,
  LeagueType leagueType,
  GameDayTitle gdt,
) {
  return ExpansionPanelRadio(
    value: identifier,
    canTapOnHeader: true,
    headerBuilder: (context, isExpanded) =>
        _GameDayHeader(leagueId: leagueId, gdt: gdt),
    body: (leagueType == LeagueType.champ)
        ? SingleChampGameDayContent(
            leagueId: leagueId,
            gameDayNumber: gdt.gameDayNumber,
          )
        : SingleDefaultGameDayContent(
            leagueId: leagueId,
            gameDayNumber: gdt.gameDayNumber,
          ),
  );
}

class _GameDayHeader extends StatelessWidget {
  final int leagueId;
  final GameDayTitle gdt;

  const _GameDayHeader({required this.leagueId, required this.gdt});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<LeagueGameDayCubit>(
      context,
    ).ensureGamesFor(leagueId, gdt.gameDayNumber);

    return BlocBuilder<LeagueGameDayCubit, GameDaysState>(
      builder: (_, gameDaysState) {
        final datesAndClubs = _extractDateAndClubs(
          gameDaysState.gamesOf(leagueId, gdt.gameDayNumber),
        );
        switch (datesAndClubs.length) {
          case 0:
            return ListTile(title: Text(gdt.title, style: _futureBold));
          case 1:
            return _SingleDateTile(title: gdt.title, dac: datesAndClubs.first);
          case 2:
            return _DoubleDateTile(
              title: gdt.title,
              fst: datesAndClubs[0],
              snd: datesAndClubs[1],
            );
          default:
            return _MultiDateTile(
              title: gdt.title,
              fst: datesAndClubs.first,
              lst: datesAndClubs.last,
            );
        }
      },
    );
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
}

class _SingleDateTile extends StatelessWidget {
  final String title;
  final DateAndClub dac;

  const _SingleDateTile({required this.title, required this.dac});

  @override
  Widget build(BuildContext context) {
    final styles = _TextStyles.from(dac);

    return ListTile(
      title: Text(title, style: styles.bold),
      subtitle: _locationSubtitle(styles, dac),
    );
  }
}

class _DoubleDateTile extends StatelessWidget {
  final String title;
  final DateAndClub fst;
  final DateAndClub snd;

  const _DoubleDateTile({
    required this.title,
    required this.fst,
    required this.snd,
  });

  @override
  Widget build(BuildContext context) {
    final titleStyle = (fst.isBygone && snd.isBygone) ? _pastBold : _futureBold;
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

  Widget _locationSubtitleWithStyleDetect(DateAndClub dac) =>
      _locationSubtitle(_TextStyles.from(dac), dac);
}

class _MultiDateTile extends StatelessWidget {
  final String title;
  final DateAndClub fst;
  final DateAndClub lst;

  const _MultiDateTile({
    required this.title,
    required this.fst,
    required this.lst,
  });

  @override
  Widget build(BuildContext context) {
    if (fst.date == lst.date) {
      return _multiIsSingleDateTile(title, fst);
    }
    final titleStyle = lst.isBygone ? _pastBold : _futureBold;
    final fstStyles = _TextStyles.from(fst);
    final lstStyles = _TextStyles.from(lst);
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
    final styles = _TextStyles.from(dac);
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
}

Widget _locationSubtitle(_TextStyles styles, DateAndClub dac) => RichText(
  text: TextSpan(
    children: [
      TextSpan(text: '${dac.date} ', style: styles.bold),
      TextSpan(text: 'bei ${dac.hostingClub}', style: styles.normal),
    ],
  ),
  overflow: TextOverflow.ellipsis,
);

class _TextStyles {
  final TextStyle normal;
  final TextStyle bold;

  _TextStyles(this.normal, this.bold);

  factory _TextStyles.from(DateAndClub dac) => (dac.isBygone)
      ? _TextStyles(_past, _pastBold)
      : _TextStyles(_future, _futureBold);
}
