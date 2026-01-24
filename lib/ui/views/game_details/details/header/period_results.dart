import 'package:collection/collection.dart';
import 'package:floorball/api/models/detailed_game.dart';
import 'package:floorball/ui/theme/global_colors.dart';
import 'package:floorball/ui/theme/text_styles.dart';
import 'package:floorball/utils/list_extensions.dart';
import 'package:flutter/material.dart';

class PeriodResults extends StatelessWidget {
  final DetailedGame game;

  static const enDash = '\u2013';

  const PeriodResults({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final result = game.result;
    if (result == null || result.forfait) {
      return SizedBox(height: 0);
    }
    final double? currentPeriod = game.currentPeriodTitle?.period;
    final periods = [1, 2, 3, 4, 5].take(_findNumberOfPeriods(game));

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
    if (game.ended || game.gameStatus == DetailedGameStatus.matchRecordClosed) {
      // the easy case - just draw the complete result
      return _periodScore(triple);
    }
    if ((currentPeriod ?? 6.0) > triple[2]) {
      // if this is a past period or we're not sure - print the result
      return _periodScore(triple);
    }
    if ((currentPeriod ?? 0.0) == triple[2]) {
      // if we're sure that this is the current period - print the result in pink
      return _periodScore(triple, color: FloorballColors.resultRunningColor);
    }
    // we end up here if this is a future period
    return Text('$enDash : $enDash', style: TextStyles.gameDetailHeaderPeriods);
  }

  Text _periodScore(List<int> pair, {Color? color}) {
    return Text(
      '${pair[0]} : ${pair[1]}',
      style: (color == null)
          ? TextStyles.gameDetailHeaderPeriods
          : TextStyles.gameDetailHeaderPeriods.copyWith(color: color),
    );
  }

  int _findNumberOfPeriods(DetailedGame game) =>
      _hasOvertime(game) +
      _hasPenaltyShots(game) +
      game.periodTitles
          .where((title) => (!title.optional))
          .where((title) => title.period.floor() == title.period)
          .length;

  int _hasPenaltyShots(DetailedGame game) {
    // If a game has ended it's ingame status will stay at the last "period"
    // So this check will work for running and ended games
    if (game.ingameStatus == DetailedIngameStatus.penaltyShots) return 1;
    return 0;
  }

  int _hasOvertime(DetailedGame game) {
    // For overtime we can't consult the ingame status as it might
    // also be "penaltyShots"
    if (game.result?.overtime ?? false) return 1;
    if (game.currentPeriodTitle?.optional ?? false) return 1;
    return 0;
  }
}
