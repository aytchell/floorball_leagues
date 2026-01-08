import 'package:floorball/api/models/league.dart';
import 'package:floorball/blocs/pinned_leagues_cubit.dart';
import 'package:floorball/routes.dart';
import 'package:floorball/ui/theme/text_styles.dart';
import 'package:floorball/ui/widgets/pin_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LeagueEntry extends StatelessWidget {
  final int seasonId;
  final int federationId;
  final League league;
  final bool isPinned;

  const LeagueEntry({
    super.key,
    required this.seasonId,
    required this.federationId,
    required this.league,
    required this.isPinned,
  });

  @override
  Widget build(BuildContext context) => ListTile(
    leading: _LeaguePinIndicator(
      seasonId: seasonId,
      federationId: federationId,
      leagueId: league.id,
      isPinned: isPinned,
    ),
    title: TextButton(
      onPressed: () => LeagueDetailsPageRoute(
        leagueId: league.id,
        leagueName: league.name,
      ).push(context),
      style: TextButton.styleFrom(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.zero,
      ),
      child: _highlightYouthSelector(league.name),
    ),
  );

  static final _regEx = RegExp(r'^(.*)(U\d{1,2}|Herren|Damen)(.*)$');

  Widget _highlightYouthSelector(String text) {
    final match = _regEx.firstMatch(text);

    if (match == null) {
      return Text(text, style: TextStyles.leaguesListLight);
    } else {
      return Text.rich(
        TextSpan(
          children: [
            TextSpan(text: match.group(1), style: TextStyles.leaguesListLight),
            TextSpan(text: match.group(2), style: TextStyles.leaguesListDark),
            TextSpan(text: match.group(3), style: TextStyles.leaguesListLight),
          ],
        ),
      );
    }
  }
}

class _LeaguePinIndicator extends PinIndicator {
  final int seasonId;
  final int federationId;
  final int leagueId;

  _LeaguePinIndicator({
    required this.seasonId,
    required this.federationId,
    required this.leagueId,
    required super.isPinned,
  }) : super(
         onPressedFactory: (context) {
           return () => BlocProvider.of<PinnedLeaguesCubit>(
             context,
           ).toggle(seasonId, federationId, leagueId);
         },
       );
}
