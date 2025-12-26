import 'package:floorball/ui/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:floorball/api/models/game_event.dart';
import 'package:floorball/ui/widgets/team_logo.dart';

class SingleGameEvent extends StatelessWidget {
  final GameEvent event;
  final Map<int, String> homePlayerNames;
  final Map<int, String> guestPlayerNames;
  final Uri? homeLogo;
  final Uri? guestLogo;

  final Uri? _logoUri;
  final Map<int, String> _playerNames;

  SingleGameEvent({
    super.key,
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
    return Container(
      constraints: BoxConstraints(minHeight: 45),
      padding: EdgeInsetsGeometry.symmetric(vertical: 5, horizontal: 0),
      alignment: AlignmentGeometry.center,
      child: _buildEvent(),
    );
  }

  Widget _buildEvent() {
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
            style: TextStyles.gameEventNewScore,
            textAlign: TextAlign.right,
          ),
        ),
        const SizedBox(width: 8),

        // event type - 'Tor' or 'Eigentor'
        SizedBox(
          width: 30,
          child: Text('Tor', style: TextStyles.gameEventType),
        ),

        const SizedBox(width: 8),

        // time of event (game clock)
        SizedBox(
          width: 40,
          child: Text(
            event.time,
            style: TextStyles.gameEventTime,
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _buildScorerAndAssist() {
    final scorerName = _playerNames[event.number] ?? '??';

    if (event.goalTypeString == 'Eigentor') {
      return Text('Eigentor', style: TextStyles.gameEventType);
    }

    if (event.assist == 0) {
      return Text(scorerName, style: TextStyles.gameEventScorer);
    } else {
      final assistName = _playerNames[event.assist] ?? '??';
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(scorerName, style: TextStyles.gameEventScorer),
          Text(assistName, style: TextStyles.gameEventAssist),
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

        const Text('Auszeit', style: TextStyles.gameEventType),

        const SizedBox(width: 8),

        // time of event (game clock)
        SizedBox(
          width: 40,
          child: Text(
            event.time,
            style: TextStyles.gameEventTime,
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
        Text(penalizedPlayer, style: TextStyles.gameEventPenalizedPlayer),

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
            event.time,
            style: TextStyles.gameEventTime,
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
          style: TextStyles.gameEventType,
          textAlign: TextAlign.right,
        ),
        if (event.penaltyReasonString != null &&
            event.penaltyReasonString!.isNotEmpty)
          Text(
            '${event.penaltyReasonString}',
            style: TextStyles.gameEventPenaltyReason,
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
          child: Text(event.eventType, style: TextStyles.gameEventType),
        ),
      ],
    );
  }
}
