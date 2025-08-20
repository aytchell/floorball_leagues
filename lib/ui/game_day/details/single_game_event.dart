import 'package:flutter/material.dart';
import '../../../api/models/game_event.dart';
import '../../widgets/team_logo.dart';

class SingleGameEvent extends StatelessWidget {
  final GameEvent event;
  final Map<int, String> homePlayerNames;
  final Map<int, String> guestPlayerNames;
  final Uri? homeLogo;
  final Uri? guestLogo;

  final Uri? _logoUri;
  final Map<int, String> _playerNames;

  SingleGameEvent({
    required this.event,
    required this.homePlayerNames,
    required this.guestPlayerNames,
    required this.homeLogo,
    required this.guestLogo,
  }) : _logoUri = (event.eventTeam == 'home') ? homeLogo : guestLogo,
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
          child: TeamLogo(uri: _logoUri, height: 25, width: 25),
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

        // event type - 'Tor' or 'Eigentor'
        SizedBox(
          width: 30,
          child: Text(
            'Tor',
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

    if (event.goalTypeString == 'Eigentor') {
      return Text(
        'Eigentor',
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      );
    }

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
          child: TeamLogo(uri: _logoUri, height: 25, width: 25),
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
    final penalizedPlayer = _playerNames[event.number] ?? '??';
    return Row(
      children: [
        // logo of team that got penalized
        SizedBox(
          width: 30,
          child: TeamLogo(uri: _logoUri, height: 25, width: 25),
        ),

        const SizedBox(width: 24),

        // Name of penalized player
        Text(
          '$penalizedPlayer',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),

        // Spacer to push content to the right
        const Expanded(child: SizedBox()),

        SizedBox(
          width: 120, // Give it a fixed width for proper text wrapping
          child: _buildPenaltyReason(),
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

  Widget _buildPenaltyReason() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'Strafe ${event.penaltyTypeString}',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          textAlign: TextAlign.right,
        ),
        if (event.penaltyReasonString != null &&
            event.penaltyReasonString!.isNotEmpty)
          Text(
            '${event.penaltyReasonString}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
          ),
      ],
    );
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
