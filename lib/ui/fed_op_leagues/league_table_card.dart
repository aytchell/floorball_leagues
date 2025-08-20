import 'package:flutter/material.dart';
import '../app_text_styles.dart';
import '../widgets/team_logo.dart';
import '../../api/models/league_table_row.dart';

class ExpandableLeagueTableCard extends StatelessWidget {
  final String title;
  final List<LeagueTableRow> teamEntries;
  final bool isExpanded;
  final VoidCallback onTap;

  const ExpandableLeagueTableCard({
    Key? key,
    required this.title,
    required this.teamEntries,
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
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4.0),
      elevation: 2,
      child: Column(
        children: [_buildButtonLikeHeader(), _buildExpandableContent()],
      ),
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

  Widget _buildButtonLikeHeader() {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: isExpanded ? Colors.blue[50] : Colors.white,
          borderRadius: isExpanded
              ? BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                )
              : BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: isExpanded
                  ? AppTextStyles.gameDayTitleExpanded
                  : AppTextStyles.gameDayTitleCollapsed,
            ),
            Icon(
              isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: isExpanded ? Colors.blue[700] : Colors.grey[600],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableContent() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: isExpanded ? null : 0,
      child: isExpanded
          ? Container(
              width: double.infinity,
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(4),
                  bottomRight: Radius.circular(4),
                ),
              ),
              child: _buildTableContent(),
            )
          : SizedBox.shrink(),
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

    return Column(
      children: teamEntries.map((entry) => _buildTableRow(entry)).toList(),
    );
  }

  Widget _buildTableRow(LeagueTableRow entry) {
    return Container(
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
          TeamLogo(uri: entry.teamLogoSmallUri, height: 24, width: 24),

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
    );
  }
}
