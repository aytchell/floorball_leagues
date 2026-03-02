import 'package:floorball/api/models/game_event.dart';
import 'package:floorball/ui/theme/text_styles.dart';
import 'package:floorball/ui/widgets/team_logo.dart';
import 'package:flutter/material.dart';

Widget buildSingleGameEvent({
  required GameEvent event,
  required Map<int, String> homePlayerNames,
  required Map<int, String> guestPlayerNames,
  Uri? homeLogo,
  Uri? guestLogo,
}) {
  return SingleGameEvent(
    event: event,
    logoUri: (event.eventTeam == 'home') ? homeLogo : guestLogo,
    body: _buildEventBody(
      event: event,
      playerNames: (event.eventTeam == 'home')
          ? homePlayerNames
          : guestPlayerNames,
    ),
  );
}

Widget _buildEventBody({
  required GameEvent event,
  required Map<int, String> playerNames,
}) {
  switch (event.eventType) {
    case 'goal':
      return _GoalEvent(event: event, playerNames: playerNames);
    case 'timeout':
      return _TimeoutEvent();
    case 'penalty':
      return _PenaltyEvent(event: event, playerNames: playerNames);
    default:
      return _Fallback(event: event);
  }
}

class SingleGameEvent extends StatelessWidget {
  final GameEvent event;
  final Uri? logoUri;
  final Widget body;

  const SingleGameEvent({
    super.key,
    required this.event,
    required this.logoUri,
    required this.body,
  });

  @override
  Widget build(BuildContext context) => Container(
    constraints: BoxConstraints(minHeight: 45),
    padding: EdgeInsetsGeometry.symmetric(vertical: 5, horizontal: 0),
    alignment: AlignmentGeometry.center,
    child: _buildEvent(),
  );

  Widget _buildEvent() {
    return Row(
      children: [
        _TeamLogoForEvent(logoUri: logoUri),
        const SizedBox(width: 24),
        Expanded(child: body),
        const SizedBox(width: 8),
        _TimeOfEvent(event: event),
      ],
    );
  }
}

class _GoalEvent extends StatelessWidget {
  final GameEvent event;
  final Map<int, String> playerNames;

  const _GoalEvent({required this.event, required this.playerNames});

  @override
  Widget build(BuildContext context) {
    if (event.goalType == 'owngoal') {
      return _SoleGoalLayout(event: event, scorerName: 'Eigentor');
    }

    final scorerName = playerNames[event.number] ?? '${event.number}';
    if (event.goalType == 'penalty_shot') {
      return _penaltyShotGoal(scorerName);
    }

    if (event.assist == null || event.assist == 0) {
      return _SoleGoalLayout(event: event, scorerName: scorerName);
    } else {
      return _assistedGoal(scorerName);
    }
  }

  Widget _penaltyShotGoal(String scorerName) => _PenaltyEventLayout(
    playerName: scorerName,
    eventTitleWidget: Row(children: _scoreAndGoalText(event)),
    eventSubtitle: 'Strafschuss',
  );

  Widget _assistedGoal(String scorerName) {
    final assistName = playerNames[event.assist] ?? '${event.assist}';
    return _AssistedGoalLayout(
      event: event,
      scorerName: scorerName,
      assistName: assistName,
    );
  }
}

class _SoleGoalLayout extends StatelessWidget {
  final GameEvent event;
  final String scorerName;

  const _SoleGoalLayout({required this.event, required this.scorerName});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(scorerName, style: TextStyles.gameEventPrimaryPlayer),
        ),
        const SizedBox(width: 12),
        ..._scoreAndGoalText(event),
      ],
    );
  }
}

class _AssistedGoalLayout extends StatelessWidget {
  final GameEvent event;
  final String scorerName;
  final String assistName;

  const _AssistedGoalLayout({
    required this.event,
    required this.scorerName,
    required this.assistName,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(scorerName, style: TextStyles.gameEventPrimaryPlayer),
              Text(assistName, style: TextStyles.gameEventSecondaryPlayer),
            ],
          ),
        ),
        const SizedBox(width: 12),
        ..._scoreAndGoalText(event),
      ],
    );
  }
}

List<Widget> _scoreAndGoalText(GameEvent event) => [
  // New game score
  Text(
    '${event.homeGoals}:${event.guestGoals}',
    style: TextStyles.gameEventNewScore,
    textAlign: TextAlign.right,
  ),
  const SizedBox(width: 8),
  Text('Tor', style: TextStyles.gameEventType),
];

class _TimeoutEvent extends StatelessWidget {
  const _TimeoutEvent();

  @override
  Widget build(BuildContext context) => Row(
    children: [
      // Spacer to push content to the right
      const Expanded(child: SizedBox()),
      const Text('Auszeit', style: TextStyles.gameEventType),
    ],
  );
}

class _PenaltyEventLayout extends StatelessWidget {
  final String playerName;
  final Widget eventTitleWidget;
  final String eventSubtitle;

  const _PenaltyEventLayout({
    required this.playerName,
    required this.eventTitleWidget,
    required this.eventSubtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [_playerNameAndEventTitle(), _buildEventSubtitle()],
    );
  }

  Widget _playerNameAndEventTitle() => Row(
    children: [
      Expanded(
        child: Text(
          playerName,
          textAlign: TextAlign.left,
          style: TextStyles.gameEventPrimaryPlayer,
        ),
      ),
      eventTitleWidget,
    ],
  );

  Widget _buildEventSubtitle() => Text(
    eventSubtitle,
    style: TextStyles.gameEventSubType,
    overflow: TextOverflow.ellipsis,
    textAlign: TextAlign.right,
  );
}

class _PenaltyEvent extends StatelessWidget {
  final GameEvent event;
  final Map<int, String> playerNames;

  const _PenaltyEvent({required this.event, required this.playerNames});

  @override
  Widget build(BuildContext context) => _PenaltyEventLayout(
    playerName: playerNames[event.number] ?? '${event.number}',
    eventTitleWidget: Text(
      'Strafe ${event.penaltyTypeString}',
      style: TextStyles.gameEventType,
      textAlign: TextAlign.right,
    ),
    eventSubtitle: event.penaltyReasonString ?? '???',
  );
}

class _Fallback extends StatelessWidget {
  final GameEvent event;

  const _Fallback({required this.event});

  @override
  Widget build(BuildContext context) => Row(
    children: [
      // Spacer to push content to the right
      const Expanded(child: SizedBox()),
      SizedBox(
        width: 40,
        child: Text(event.eventType, style: TextStyles.gameEventType),
      ),
    ],
  );
}

class _TeamLogoForEvent extends StatelessWidget {
  final Uri? logoUri;

  const _TeamLogoForEvent({this.logoUri});

  @override
  Widget build(BuildContext context) =>
      SizedBox(width: 30, child: TeamLogo(uri: logoUri, height: 25, width: 25));
}

class _TimeOfEvent extends StatelessWidget {
  final GameEvent event;

  const _TimeOfEvent({required this.event});

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 40,
    child: Text(
      event.time,
      style: TextStyles.gameEventTime,
      textAlign: TextAlign.right,
    ),
  );
}
