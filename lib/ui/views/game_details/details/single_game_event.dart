import 'package:floorball/api/models/game_event.dart';
import 'package:floorball/ui/theme/text_styles.dart';
import 'package:floorball/ui/widgets/team_logo.dart';
import 'package:flutter/material.dart';

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
  Widget build(BuildContext context) => Container(
    constraints: BoxConstraints(minHeight: 45),
    padding: EdgeInsetsGeometry.symmetric(vertical: 5, horizontal: 0),
    alignment: AlignmentGeometry.center,
    child: _buildEvent(),
  );

  Widget _buildEvent() {
    return Row(
      children: [
        _TeamLogoForEvent(logoUri: _logoUri),
        const SizedBox(width: 24),
        Expanded(child: _buildEventBody()),
        const SizedBox(width: 8),
        _TimeOfEvent(event: event),
      ],
    );
  }

  Widget _buildEventBody() {
    switch (event.eventType) {
      case 'goal':
        return _GoalEvent(
          event: event,
          playerNames: _playerNames,
          logoUri: _logoUri,
        );
      case 'timeout':
        return _TimeoutEvent(event: event, logoUri: _logoUri);
      case 'penalty':
        return _PenaltyEvent(
          event: event,
          playerNames: _playerNames,
          logoUri: _logoUri,
        );
      default:
        return _Fallback(event: event);
    }
  }
}

class _GoalEvent extends StatelessWidget {
  final GameEvent event;
  final Map<int, String> playerNames;
  final Uri? logoUri;

  const _GoalEvent({
    required this.event,
    required this.playerNames,
    this.logoUri,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildScorerAndAssist()),
        const SizedBox(width: 12),
        // New game score
        Text(
          '${event.homeGoals}:${event.guestGoals}',
          style: TextStyles.gameEventNewScore,
          textAlign: TextAlign.right,
        ),
        const SizedBox(width: 8),
        // event type - 'Tor'
        // (in case of an 'Eigentor' this is written to the player's column)
        Text('Tor', style: TextStyles.gameEventType),
      ],
    );
  }

  Widget _buildScorerAndAssist() {
    if (event.goalTypeString == 'Eigentor') {
      return const Text('Eigentor', style: TextStyles.gameEventType);
    }

    final scorerName = playerNames[event.number] ?? '${event.number}';

    if (event.assist == 0) {
      return Text(scorerName, style: TextStyles.gameEventScorer);
    } else {
      final assistName = playerNames[event.assist] ?? '${event.number}';
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(scorerName, style: TextStyles.gameEventScorer),
          Text(assistName, style: TextStyles.gameEventAssist),
        ],
      );
    }
  }
}

class _TimeoutEvent extends StatelessWidget {
  final GameEvent event;
  final Uri? logoUri;

  const _TimeoutEvent({required this.event, this.logoUri});

  @override
  Widget build(BuildContext context) => Row(
    children: [
      // Spacer to push content to the right
      const Expanded(child: SizedBox()),
      const Text('Auszeit', style: TextStyles.gameEventType),
    ],
  );
}

class _PenaltyEvent extends StatelessWidget {
  final GameEvent event;
  final Map<int, String> playerNames;
  final Uri? logoUri;

  const _PenaltyEvent({
    required this.event,
    required this.playerNames,
    this.logoUri,
  });

  @override
  Widget build(BuildContext context) {
    final penalizedPlayer = playerNames[event.number] ?? '${event.number}';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _playerNameAndPenaltyType(penalizedPlayer),
        _buildPenaltyReason(),
      ],
    );
  }

  Widget _playerNameAndPenaltyType(String penalizedPlayer) => Row(
    children: [
      Expanded(
        child: Text(
          penalizedPlayer,
          textAlign: TextAlign.left,
          style: TextStyles.gameEventPenalizedPlayer,
        ),
      ),
      _buildPenaltyType(),
    ],
  );

  Widget _buildPenaltyType() => Text(
    'Strafe ${event.penaltyTypeString}',
    style: TextStyles.gameEventType,
    textAlign: TextAlign.right,
  );

  Widget _buildPenaltyReason() {
    if (event.penaltyReasonString != null &&
        event.penaltyReasonString!.isNotEmpty) {
      return Text(
        '${event.penaltyReasonString}',
        style: TextStyles.gameEventPenaltyReason,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.right,
      );
    } else {
      return SizedBox(width: 0);
    }
  }
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
