import 'package:floorball/api/models/league.dart';
import 'package:floorball/blocs/pinned_leagues_cubit.dart';
import 'package:floorball/ui/widgets/generic_league_name_entry.dart';
import 'package:floorball/ui/widgets/pin_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PinnableLeagueEntry extends StatelessWidget {
  final int seasonId;
  final int federationId;
  final League league;
  final bool isPinned;

  const PinnableLeagueEntry({
    super.key,
    required this.seasonId,
    required this.federationId,
    required this.league,
    required this.isPinned,
  });

  @override
  Widget build(BuildContext context) => GenericLeagueNameEntry(
    leagueId: league.id,
    leagueName: league.name,
    leadingChild: _LeaguePinIndicator(
      seasonId: seasonId,
      federationId: federationId,
      leagueId: league.id,
      isPinned: isPinned,
    ),
  );
}

class _LeaguePinIndicator extends FavoritesIndicator {
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
