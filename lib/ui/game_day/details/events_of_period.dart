import 'package:flutter/material.dart';
import '../../../api/models/period_title.dart';
import '../../../api/models/game_event.dart';
import 'single_game_event.dart';

class EventsOfPeriod extends StatelessWidget {
  final PeriodTitle period;
  final double? currentPeriodId;
  final Map<int, String> homePlayerNames;
  final Map<int, String> guestPlayerNames;
  final Uri? homeLogo;
  final Uri? guestLogo;
  final List<GameEvent>? events;

  const EventsOfPeriod({
    super.key,
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

  @override
  Widget build(BuildContext context) {
    if (currentPeriodId == null || period.period > currentPeriodId!)
      return const SizedBox.shrink(); // Renders nothing

    if (_isPause()) {
      if (period.period == currentPeriodId) {
        // if the game is currently in this pause then render
        // just the title
        return Text(
          '${period.title}',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        );
      }
      if (events == null || events!.isEmpty)
        return const SizedBox.shrink(); // Renders nothing

      // otherwise we render the events of this pause
      // with the below 'normal' code
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${period.title}',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),

        // Table
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            children: [
              // If no events to report
              if (events == null || events!.isEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  child: const Text(
                    'keine Ereignisse',
                    style: TextStyle(
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),

              // Table rows
              if (events != null && events!.isNotEmpty)
                ...events!.asMap().entries.map((entry) {
                  final index = entry.key;
                  final event = entry.value;
                  final isEven = index % 2 == 0;

                  return Container(
                    decoration: BoxDecoration(
                      color: isEven ? Colors.grey.shade50 : Colors.white,
                      border: index > 0
                          ? Border(
                              top: BorderSide(
                                color: Colors.grey.shade300,
                                width: 0.5,
                              ),
                            )
                          : null,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
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
        ),
      ],
    );
  }
}
