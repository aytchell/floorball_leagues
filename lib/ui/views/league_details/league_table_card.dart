import 'package:floorball/api/models/game_operation_league.dart';
import 'package:flutter/material.dart';
import 'package:floorball/ui/app_text_styles.dart';
import 'package:floorball/ui/widgets/team_logo.dart';
import 'package:floorball/ui/widgets/expandable_card.dart';
import 'package:floorball/api/models/league_table_row.dart';
import 'package:floorball/api/models/scorer.dart';
import 'package:floorball/api/models/game.dart';
import 'package:floorball/ui/views/team_details/team_details_page.dart';

class ExpandableLeagueTableCard extends StatelessWidget {
  final String leagueName;
  final String title;
  final GameOperationLeague league;
  final List<LeagueTableRow> teamEntries;
  final List<Scorer> scorers;
  final List<Game> games;
  final bool isExpanded;
  final VoidCallback onTap;

  const ExpandableLeagueTableCard({
    Key? key,
    required this.leagueName,
    required this.title,
    required this.league,
    required this.teamEntries,
    required this.scorers,
    required this.games,
    required this.isExpanded,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // If no team entries, show simple non-expandable card
    if (teamEntries.isEmpty) {
      return _buildEmptyCard();
    }

    // Otherwise show expandable card
    return ExpandableCard(
      title: title,
      isExpanded: isExpanded,
      onTap: onTap,
      child: _buildTableContent(),
    );
  }

  Widget _buildEmptyCard() {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4.0),
      elevation: 2,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: AppTextStyles.gameDayTitleCollapsed),
            Text(
              'Noch keine Tabelle vorhanden',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14.0,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableContent() {
    if (teamEntries.isEmpty) {
      return Container(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            'Tabelle wird geladen...',
            style: TextStyle(color: Colors.grey[600], fontSize: 14.0),
          ),
        ),
      );
    }

    return Builder(
      builder: (context) => Column(
        children: teamEntries
            .map((entry) => _buildTableRow(context, entry))
            .toList(),
      ),
    );
  }

  Widget _buildTableRow(BuildContext context, LeagueTableRow entry) {
    return InkWell(
      onTap: () => _navigateToTeamDetails(context, entry),
      borderRadius: BorderRadius.circular(6.0),
      child: Container(
        margin: EdgeInsets.only(bottom: 8.0),
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.0),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            // Position
            Container(
              width: 30.0,
              child: Text(
                '${entry.position}.',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),

            SizedBox(width: 12.0),

            // Team logo
            TeamLogo(uri: entry.teamLogoSmallUri, height: 25, width: 25),

            SizedBox(width: 12.0),

            // Team name
            Expanded(
              child: Text(
                entry.teamName,
                style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis,
              ),
            ),

            Text(
              '${entry.points} Pkt',
              style: TextStyle(
                fontSize: 12.0,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToTeamDetails(BuildContext context, LeagueTableRow entry) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TeamDetailsPage(
          league: league,
          teamEntry: entry,
          teamGames: games
              .where((g) => _isTeamInvolved(g, entry.teamName))
              .toList(),
        ),
      ),
    );
  }

  bool _isTeamInvolved(Game game, String teamName) {
    return (teamName == game.homeTeamName) || (teamName == game.guestTeamName);
  }
}
