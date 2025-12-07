import 'package:floorball/api/blocs/federations_cubit.dart';
import 'package:floorball/api/blocs/leagues_cubit.dart';
import 'package:floorball/routes.dart';
import 'package:floorball/selected_season_cubit.dart';
import 'package:flutter/material.dart';

import 'package:floorball/api/models/season_info.dart';
import 'package:floorball/api/models/federation.dart';
import 'package:floorball/api/models/league.dart';
import 'package:floorball/ui/main_app_scaffold.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

final log = Logger('LeaguesListPage');

final TextStyle blackTextStyle = TextStyle(
  color: Color.fromARGB(255, 0, 0, 0),
  fontSize: 16,
  fontWeight: FontWeight.w700,
);

final TextStyle textStyle = TextStyle(
  color: Color.fromARGB(255, 97, 97, 97),
  fontSize: 16,
  fontWeight: FontWeight.w600,
);

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
    int? id,
    Federation? federation,
    List<League> leagues,
  ) {
    return MainAppScaffold(
      title: federation?.name ?? 'Ligen',
      showBackButton: true,
      body: _buildBody(context, leagues),
    );
  }

  Widget _buildBody(BuildContext context, List<League> leagues) {
    if (leagues.isNotEmpty) {
      return _buildLeaguesList(context, leagues);
    } else {
      return _buildNothingFoundInfo(context);
    }
  }

  Widget _buildLeaguesList(BuildContext context, List<League> leagues) {
    return ListView.builder(
      padding: EdgeInsetsGeometry.symmetric(vertical: 32.0, horizontal: 24.0),
      itemCount: leagues.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: TextButton(
            onPressed: () => LeagueDetailsPageRoute(
              leagueId: leagues[index].id,
              leagueName: leagues[index].name,
            ).push(context),
            style: TextButton.styleFrom(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.zero,
            ),
            child: _highlightYouthSelector(leagues[index].name),
          ),
        );
      },
    );
  }

  static final regEx = RegExp(r'^(.*)(U\d{1,2}|Herren|Damen)(.*)$');

  Widget _highlightYouthSelector(String text) {
    final match = regEx.firstMatch(text);

    if (match == null) {
      return Text(text, style: textStyle);
    } else {
      return Text.rich(
        TextSpan(
          children: [
            TextSpan(text: match.group(1), style: textStyle),
            TextSpan(text: match.group(2), style: blackTextStyle),
            TextSpan(text: match.group(3), style: textStyle),
          ],
        ),
      );
    }
  }

  Widget _buildNothingFoundInfo(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today, size: 64, color: Colors.grey[400]),
            SizedBox(height: 16),
            Text(
              'Keine Ligen verfügbar',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
