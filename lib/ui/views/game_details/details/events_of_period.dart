import 'package:collection/collection.dart';
import 'package:floorball/ui/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:floorball/api/models/period_title.dart';
import 'package:floorball/api/models/game_event.dart';
import 'package:floorball/ui/widgets/striped_table_row.dart';
import 'package:floorball/ui/views/game_details/details/single_game_event.dart';

class EventsOfPeriod extends StatelessWidget {
  final bool isRunning;
  final PeriodTitle period;
  final double? currentPeriodId;
  final Map<int, String> homePlayerNames;
  final Map<int, String> guestPlayerNames;
  final Uri? homeLogo;
  final Uri? guestLogo;
  final List<GameEvent>? events;

  const EventsOfPeriod({
    super.key,
    required this.isRunning,
    required this.period,
    required this.currentPeriodId,
    required this.homePlayerNames,
    required this.guestPlayerNames,
    required this.homeLogo,
    required this.guestLogo,
    required this.events,
  });

  bool _isPause() {
    // 'pause periods' are doubles ending in .5
    return period.period.round().toDouble() != period.period;
  }

  bool _isCurrentPeriod() => period.period == currentPeriodId;

  @override
  Widget build(BuildContext context) {
    if (currentPeriodId == null || period.period > currentPeriodId!) {
      return const SizedBox.shrink(); // Renders nothing
    }

    if (_isPause()) {
      if (_isCurrentPeriod()) {
        // if the game is currently in this pause then render
        // just the title
        return Text(period.title, style: TextStyles.gameDetailsSubSection);
      }
      if (events == null || events!.isEmpty) {
        return const SizedBox.shrink(); // Renders nothing
      }

      // otherwise we render the events of this pause
      // with the below 'normal' code
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(period.title, style: TextStyles.gameDetailsSubSection),
        const SizedBox(height: 8),

        // Table
        Column(
          children: [
            // If no events to report
            if (events == null || events!.isEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                child: const Text(
                  'Keine Ereignisse',
                  style: TextStyles.gameEventNoEvents,
                ),
              ),

            // Table rows
            if (events != null && events!.isNotEmpty)
              ...events!.mapIndexed((index, event) {
                final isLastEvent = index == events!.length - 1;

                return StripedTableRow(
                  index: index,
                  padding: null,
                  blink: isRunning && isLastEvent && _isCurrentPeriod(),
                  child: SingleGameEvent(
                    event: event,
                    homePlayerNames: homePlayerNames,
                    guestPlayerNames: guestPlayerNames,
                    homeLogo: homeLogo,
                    guestLogo: guestLogo,
                  ),
                );
              }),
          ],
        ),
      ],
    );
  }
}
