import 'package:flutter/material.dart';
import '../../../api_models/detailed_game.dart';
import 'team_logo.dart';

class SingleGameEvent extends StatelessWidget {
  final GameEvent event;
  final Map<int, String> homePlayerNames;
  final Map<int, String> guestPlayerNames;
  final String? homeLogo;
  final String? guestLogo;

  final String? _logoPath;
  final Map<int, String> _playerNames;

  SingleGameEvent({
    required this.event,
    required this.homePlayerNames,
    required this.guestPlayerNames,
    required this.homeLogo,
    required this.guestLogo,
  }) : _logoPath = (event.eventTeam == 'home') ? homeLogo : guestLogo,
       _playerNames = (event.eventTeam == 'home')
           ? homePlayerNames
           : guestPlayerNames;

  @override
  Widget build(BuildContext context) {
    if (event.eventType == 'goal') {
      return _buildGoalEvent();
    }

    if (event.eventType == 'timeout') {
      return _buildTimeoutEvent();
    }

    if (event.eventType == 'penalty') {
      return _buildPenaltyEvent();
    }

    return _fallback();
  }

  Widget _buildGoalEvent() {
    return Row(
      children: [
        // logo of team that scored
        SizedBox(
          width: 30,
          child: TeamLogo(logoPath: _logoPath, height: 25, width: 25),
        ),

        const SizedBox(width: 24),

        // Names of scorer and assist
        SizedBox(width: 120, child: _buildScorerAndAssist()),

        const SizedBox(width: 12),

        // New game score
        Expanded(
          child: Text(
            '${event.homeGoals}:${event.guestGoals}',
            style: const TextStyle(fontSize: 14),
            textAlign: TextAlign.right,
          ),
        ),
        const SizedBox(width: 8),

        // event type - usually 'Tor'
        SizedBox(
          width: 30,
          child: Text(
            '${event.goalTypeString}',
            style: const TextStyle(fontSize: 14),
            textAlign: TextAlign.right,
          ),
        ),

        const SizedBox(width: 8),

        // time of event (game clock)
        SizedBox(
          width: 40,
          child: Text(
            '${event.time}',
            style: const TextStyle(fontSize: 14),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _buildScorerAndAssist() {
    final scorerName = _playerNames[event.number] ?? '??';

    if (event.assist == 0) {
      return Text(
        '$scorerName',
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      );
    } else {
      final assistName = _playerNames[event.assist] ?? '??';
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$scorerName',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          Text(
            '$assistName',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
        ],
      );
    }
  }

  Widget _buildTimeoutEvent() {
    return Row(
      children: [
        // logo of team that scored
        SizedBox(
          width: 30,
          child: TeamLogo(logoPath: _logoPath, height: 25, width: 25),
        ),

        // Spacer to push content to the right
        const Expanded(child: SizedBox()),

        const Text(
          'Auszeit',
          style: TextStyle(fontSize: 14),
          textAlign: TextAlign.right,
        ),

        const SizedBox(width: 8),

        // time of event (game clock)
        SizedBox(
          width: 40,
          child: Text(
            '${event.time}',
            style: const TextStyle(fontSize: 14),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _buildPenaltyEvent() {
    // TODO
    return _fallback();
  }

  Widget _fallback() {
    return Row(
      children: [
        SizedBox(
          width: 30,
          child: Text(
            '${event.eventType}',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
