import 'package:collection/collection.dart';
import 'package:floorball/api/models/game_date_time.dart';
import 'package:floorball/api/models/game_day_title.dart';
import 'package:floorball/api/models/league.dart';
import 'package:floorball/blocs/league_game_day_cubit.dart';
import 'package:floorball/ui/theme/global_colors.dart';
import 'package:floorball/ui/theme/text_styles.dart';
import 'package:floorball/ui/views/game_details/game_league_info.dart';
import 'package:floorball/ui/views/league_details/date_and_club.dart';
import 'package:floorball/ui/views/league_details/game_day/extract_dates_and_clubs.dart';
import 'package:floorball/ui/views/league_details/game_day/single_champ_game_day_content.dart';
import 'package:floorball/ui/views/league_details/game_day/single_default_game_day_content.dart';
import 'package:floorball/ui/widgets/custom_expansion_panel_radio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const _futureBold = TextStyles.gameDayHeaderFutureBold;
const _future = TextStyles.gameDayHeaderFuture;
const _pastBold = TextStyles.gameDayHeaderPastBold;
const _past = TextStyles.gameDayHeaderPast;

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
    header: _GameDayHeader(leagueId: leagueId, gdt: gdt),
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
        final datesAndClubs = extractDatesAndClubs(
          gameDaysState.gamesOf(leagueId, gdt.gameDayNumber),
        );
        switch (datesAndClubs.length) {
          case 0:
            return ListTile(
              title: Text(gdt.title, style: _futureBold),
              subtitle: _SkeletonText(),
            );
          case 1:
            return _SingleDateTile(title: gdt.title, dac: datesAndClubs.first);
          case 2:
            return _DoubleDateTile(
              title: gdt.title,
              fst: datesAndClubs[0],
              snd: datesAndClubs[1],
            );
          default:
            return _MultiDateTile(title: gdt.title, dacs: datesAndClubs);
        }
      },
    );
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
      title: _addTodayMarker(Text(title, style: styles.bold), [dac]),
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
      title: _addTodayMarker(Text(title, style: titleStyle), [fst, snd]),
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
  final List<DateAndClub> dacs;
  final DateAndClub fst;
  final DateAndClub lst;

  _MultiDateTile({required this.title, required this.dacs})
    : fst = dacs.first,
      lst = dacs.last;

  @override
  Widget build(BuildContext context) {
    if (fst.dateTime.date == lst.dateTime.date) {
      return _multiIsSingleDateTile(title, fst);
    }
    final titleStyle = lst.isBygone ? _pastBold : _futureBold;
    final fstStyles = _TextStyles.from(fst);
    final lstStyles = _TextStyles.from(lst);
    return ListTile(
      title: _addTodayMarker(Text(title, style: titleStyle), dacs),
      subtitle: RichText(
        text: TextSpan(
          children: [
            TextSpan(text: 'von ${_weekday(fst)} ', style: lstStyles.normal),
            TextSpan(text: '${fst.beautifiedDate} ', style: fstStyles.bold),
            TextSpan(text: 'bis ${_weekday(lst)} ', style: lstStyles.normal),
            TextSpan(text: lst.beautifiedDate, style: lstStyles.bold),
          ],
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _multiIsSingleDateTile(String title, DateAndClub dac) {
    final styles = _TextStyles.from(dac);
    return ListTile(
      title: _addTodayMarker(Text(title, style: styles.bold), [dac]),
      subtitle: RichText(
        text: TextSpan(
          children: [
            TextSpan(text: 'am ${_weekday(dac)} ', style: styles.normal),
            TextSpan(text: dac.beautifiedDate, style: styles.bold),
          ],
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

Widget _addTodayMarker(Text text, List<DateAndClub> dacs) {
  final nearEvents = dacs.map((dac) => dac.dateTime).isCloseToToday();
  if (nearEvents.today || nearEvents.tomorrow) {
    return Row(
      children: [
        Expanded(child: text),
        Text(
          _printTodayLabel(nearEvents),
          style: TextStyles.gameDayHeaderFutureBold.copyWith(
            color: FloorballColors.resultRunningColor,
          ),
        ),
      ],
    );
  } else {
    return text;
  }
}

String _printTodayLabel(AroundToday nearEvents) => [
  nearEvents.today ? 'heute' : null,
  nearEvents.tomorrow ? 'morgen' : null,
  nearEvents.beyond ? '...' : null,
].where((entry) => entry != null).join('/');

Widget _locationSubtitle(_TextStyles styles, DateAndClub dac) => RichText(
  text: TextSpan(
    children: [
      TextSpan(text: '${_weekday(dac)} ', style: styles.normal),
      TextSpan(text: '${dac.beautifiedDate} ', style: styles.bold),
      TextSpan(text: 'bei ${dac.hostingClub}', style: styles.normal),
    ],
  ),
  overflow: TextOverflow.ellipsis,
);

String _weekday(DateAndClub dac) {
  switch (dac.dateTime.dateTime.weekday) {
    case DateTime.monday:
      return 'Mo';
    case DateTime.tuesday:
      return 'Di';
    case DateTime.wednesday:
      return 'Mi';
    case DateTime.thursday:
      return 'Do';
    case DateTime.friday:
      return 'Fr';
    case DateTime.saturday:
      return 'Sa';
    case DateTime.sunday:
      return 'So';
    default:
      return '';
  }
}

class _TextStyles {
  final TextStyle normal;
  final TextStyle bold;

  _TextStyles(this.normal, this.bold);

  factory _TextStyles.from(DateAndClub dac) => (dac.isBygone)
      ? _TextStyles(_past, _pastBold)
      : _TextStyles(_future, _futureBold);
}

class _SkeletonText extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    width: 40,
    height: 16,
    decoration: BoxDecoration(
      color: FloorballColors.gray231,
      borderRadius: BorderRadius.circular(8),
    ),
  );
}
