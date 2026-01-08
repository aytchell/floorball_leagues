import 'package:collection/collection.dart';
import 'package:floorball/api/models/federation.dart';
import 'package:floorball/api/models/league.dart';
import 'package:floorball/api/models/season_info.dart';
import 'package:floorball/blocs/federations_cubit.dart';
import 'package:floorball/blocs/leagues_cubit.dart';
import 'package:floorball/blocs/pinned_leagues_cubit.dart';
import 'package:floorball/blocs/selected_season_cubit.dart';
import 'package:floorball/routes.dart';
import 'package:floorball/ui/main_app_scaffold.dart';
import 'package:floorball/ui/theme/global_colors.dart';
import 'package:floorball/ui/theme/text_styles.dart';
import 'package:floorball/ui/widgets/pin_indicator.dart';
import 'package:floorball/utils/list_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

final log = Logger('LeaguesListPage');

class LeaguesListPage extends StatelessWidget {
  final int federationId;

  static const routePath = '/all_leagues';

  const LeaguesListPage({super.key, required this.federationId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectedSeasonCubit, SeasonInfo?>(
      builder: (_, season) {
        if (season != null) {
          BlocProvider.of<LeaguesCubit>(
            context,
          ).ensureLeaguesFor(season.id, federationId);
        }
        return BlocBuilder<AvailableFederationsCubit, AvailableFederations>(
          builder: (_, availableOps) => BlocBuilder<LeaguesCubit, LeaguesState>(
            builder: (_, leagues) {
              return _buildScaffold(
                context,
                season?.id,
                availableOps.get(federationId),
                leagues.leaguesOf(season?.id, federationId),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildScaffold(
    BuildContext context,
    int? seasonId,
    Federation? federation,
    List<League> leagues,
  ) {
    return MainAppScaffold(
      title: federation?.name ?? 'Ligen',
      showBackButton: true,
      body: _buildBody(context, seasonId, federation?.id, leagues),
    );
  }

  Widget _buildBody(
    BuildContext context,
    int? seasonId,
    int? federationId,
    List<League> leagues,
  ) {
    if (seasonId == null || federationId == null || leagues.isEmpty) {
      return _buildNothingFoundInfo(context);
    } else {
      //return _buildLeaguesList(context, leagues);
      return BlocBuilder<PinnedLeaguesCubit, PinnedLeagues>(
        builder: (_, state) => _buildLeaguesList(
          context,
          seasonId,
          federationId,
          _tagAndReorder(
            leagues,
            state.getPinnedLeagues(seasonId, federationId),
          ),
        ),
      );
    }
  }

  List<LeagueWithPin> _tagAndReorder(
    List<League> leagues,
    List<int> pinnedLeagueIds,
  ) {
    final List<LeagueWithPin> pinned = pinnedLeagueIds
        .mapNotNull(
          (id) => leagues.firstWhereOrNull((league) => league.id == id),
        )
        .map((league) => LeagueWithPin(league, true))
        .toList();
    final List<LeagueWithPin> unPinned = leagues
        .where((league) => !pinnedLeagueIds.contains(league.id))
        .map((league) => LeagueWithPin(league, false))
        .toList();
    pinned.addAll(unPinned);
    return pinned;
  }

  Widget _buildLeaguesList(
    BuildContext context,
    int seasonId,
    int federationId,
    List<LeagueWithPin> leagues,
  ) {
    return Container(
      color: FloorballColors.gray231,
      padding: EdgeInsetsGeometry.symmetric(vertical: 32.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('LIGEN', style: TextStyles.leaguesListHeader),
          SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: leagues.length,
              itemBuilder: (context, index) {
                final league = leagues[index].league;
                return ListTile(
                  leading: _LeaguePinIndicator(
                    seasonId: seasonId,
                    federationId: federationId,
                    leagueId: league.id,
                    isPinned: leagues[index].isPinned,
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
              },
            ),
          ),
        ],
      ),
    );
  }

  static final regEx = RegExp(r'^(.*)(U\d{1,2}|Herren|Damen)(.*)$');

  Widget _highlightYouthSelector(String text) {
    final match = regEx.firstMatch(text);

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

  Widget _buildNothingFoundInfo(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today, size: 64, color: Colors.black38),
            SizedBox(height: 16),
            Text('Keine Ligen verfügbar', style: TextStyles.genericLoadingData),
          ],
        ),
      ),
    );
  }
}

class LeagueWithPin {
  final League league;
  final bool isPinned;

  LeagueWithPin(this.league, this.isPinned);
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
