import 'package:collection/collection.dart';
import 'package:floorball/api/models/date_formatter.dart';
import 'package:floorball/api/models/detailed_game.dart';
import 'package:floorball/ui/widgets/game_result_texts.dart';
import 'package:floorball/ui/widgets/team_logo.dart';
import 'package:floorball/utils/global_colors.dart';
import 'package:floorball/utils/list_extensions.dart';
import 'package:floorball/utils/rem.dart';
import 'package:flutter/material.dart';

class DetailedGameHeader extends StatelessWidget {
  final DetailedGame game;

  const DetailedGameHeader({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    if (!game.started) {
      if (game.noticeType != null) {
        return _NoticeGameHeader(game: game);
      } else {
        return _FutureGameHeader(game: game);
      }
    } else {
      return _PastGameHeader(game: game);
    }
  }
}

const grey153 = Color.fromARGB(255, 153, 153, 153);
const vsGrey = Color.fromARGB(255, 156, 163, 175);
const datePastFont = TextStyle(
  color: grey153,
  fontWeight: FontWeight.w700,
  fontSize: rem_1,
);
const dateFutureFont = TextStyle(
  color: Colors.black,
  fontWeight: FontWeight.w700,
  fontSize: rem_1,
);
const arenaInfoTextStyle = TextStyle(fontSize: 16, color: grey153);
const periodTextStyle = TextStyle(
  fontSize: rem_1,
  fontWeight: FontWeight.w700,
  color: Colors.black,
);
const dash = '–';

class _NoticeGameHeader extends _GameHeaderScaffold {
  const _NoticeGameHeader({required super.game});

  @override
  List<Widget> _buildHeaderEntries() => [
    _buildTeamRow(),
    const SizedBox(height: 16),
    _printNotice(),
  ];

  Widget _printNotice() {
    final text = (game.noticeType == 'Canceled')
        ? 'abgesagt'
        : game.noticeType!;
    return Text(
      text,
      style: const TextStyle(
        fontSize: rem_2_625,
        fontWeight: FontWeight.w700,
        color: FloorballColors.resultNoticeColor,
      ),
    );
  }
}

class _FutureGameHeader extends _GameHeaderScaffold {
  const _FutureGameHeader({required super.game});

  @override
  List<Widget> _buildHeaderEntries() => [
    _buildTeamRow(),
    const SizedBox(height: 16),
    _buildDateTime(dateFutureFont),
    const SizedBox(height: 8),
    _buildArenaInfo(),
  ];
}

class _PastGameHeader extends _GameHeaderScaffold {
  const _PastGameHeader({required super.game});

  @override
  List<Widget> _buildHeaderEntries() => [
    _buildTeamRow(),
    const SizedBox(height: 16),
    _buildDateTime(datePastFont),
    const SizedBox(height: 4),
    _buildScore(),
    const SizedBox(height: 4),
    _buildPeriodResults(),
  ];
}

abstract class _GameHeaderScaffold extends StatelessWidget {
  final DetailedGame game;

  const _GameHeaderScaffold({required this.game});

  List<Widget> _buildHeaderEntries();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: _buildHeaderEntries(),
      ),
    );
  }

  Widget _buildDateTime(TextStyle style) {
    final dateStr = beautifyDate(game.date);
    final timeStr = '${game.startTime} Uhr';

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(dateStr, style: style),
        SizedBox(width: 6),
        Text(dash, style: style),
        SizedBox(width: 6),
        Text(timeStr, style: style),
      ],
    );
  }

  Widget _buildArenaInfo() => Column(
    children: [
      Text(
        game.arenaName,
        style: arenaInfoTextStyle,
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 2),
      Text(
        game.arenaAddress,
        style: arenaInfoTextStyle,
        textAlign: TextAlign.center,
      ),
    ],
  );

  Widget _buildTeamRow() => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      // Home team
      Expanded(
        child: _buildTeamSection(
          teamName: game.homeTeamName,
          logoUri: game.homeLogoUri,
        ),
      ),
      // -- vs --
      Text(
        'vs',
        style: TextStyle(
          color: vsGrey,
          fontWeight: FontWeight.w700,
          fontSize: rem_1_125,
        ),
      ),
      // Guest team
      Expanded(
        child: _buildTeamSection(
          teamName: game.guestTeamName,
          logoUri: game.guestLogoUri,
        ),
      ),
    ],
  );

  Widget _buildTeamSection({required String teamName, required Uri? logoUri}) =>
      Column(
        children: [
          TeamLogo(uri: logoUri, width: 90, height: 90),
          const SizedBox(height: 8),
          // Team name
          Text(
            teamName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: rem_1,
              fontWeight: FontWeight.w700,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      );

  Widget _buildScore() {
    return Column(children: buildDetailedResultTexts(game));
  }

  Widget _buildPeriodResults() {
    final result = game.result;
    if (result == null || result.forfait) {
      return SizedBox(height: 0);
    }
    final double? currentPeriod = game.currentPeriodTitle?.period;
    final periods = [1, 2, 3, 4].take(_findNumberOfPeriods(game));

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children:
          IterableZip([
                result.homeGoalsPeriod,
                result.guestGoalsPeriod,
                periods,
              ])
              .map((triple) => _computePeriodScore(triple, currentPeriod))
              .joinWidgets(SizedBox(width: 18))
              .toList(),
    );
  }

  Widget _computePeriodScore(List<int> triple, double? currentPeriod) {
    if (game.ended) {
      // the easy case - just draw the complete result
      return _periodScore(triple);
    }
    if ((currentPeriod ?? 5.0) > triple[2]) {
      // if this is a past period or we're not sure - print the result
      return _periodScore(triple);
    }
    if ((currentPeriod ?? 0.0) == triple[2]) {
      // if we're sure that this is the current period - print the result in pink
      return _periodScore(triple, color: FloorballColors.resultRunningColor);
    }
    // we end up here if this is a future period
    return Text('$dash : $dash', style: periodTextStyle);
  }

  Text _periodScore(List<int> pair, {Color? color}) {
    return Text(
      '${pair[0]} : ${pair[1]}',
      style: (color == null)
          ? periodTextStyle
          : periodTextStyle.copyWith(color: color),
    );
  }

  int _findNumberOfPeriods(DetailedGame game) =>
      _hasOvertime(game) +
      game.periodTitles
          .where((title) => (!title.optional))
          .where((title) => title.period.floor() == title.period)
          .length;

  int _hasOvertime(DetailedGame game) {
    if (game.result?.overtime ?? false) return 1;
    if (game.currentPeriodTitle?.optional ?? false) return 1;
    return 0;
  }
}
