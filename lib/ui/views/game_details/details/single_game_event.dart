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
        _TeamLogoForEvent(logoUri: logoUri),
        const SizedBox(width: 24),
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
        // event type - 'Tor'
        // (in case of an 'Eigentor' this is written to the player's column)
        const SizedBox(
          width: 30,
          child: Text('Tor', style: TextStyles.gameEventType),
        ),
        const SizedBox(width: 8),
        _TimeOfEvent(event: event),
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
      _TeamLogoForEvent(logoUri: logoUri),
      // Spacer to push content to the right
      const Expanded(child: SizedBox()),
      const Text('Auszeit', style: TextStyles.gameEventType),
      const SizedBox(width: 8),
      _TimeOfEvent(event: event),
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
    return Row(
      children: [
        _TeamLogoForEvent(logoUri: logoUri),
        const SizedBox(width: 24),
        Text(penalizedPlayer, style: TextStyles.gameEventPenalizedPlayer),
        const Expanded(child: SizedBox()),
        SizedBox(
          width: 120, // Give it a fixed width for proper text wrapping
          child: _buildPenaltyReason(),
        ),
        const SizedBox(width: 8),
        _TimeOfEvent(event: event),
      ],
    );
  }

  Widget _buildPenaltyReason() => Column(
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
      const SizedBox(width: 8),
      _TimeOfEvent(event: event),
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
