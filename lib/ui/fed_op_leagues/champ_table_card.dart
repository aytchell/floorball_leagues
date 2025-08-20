import 'package:flutter/material.dart';
import '../../api_models/table.dart';
import '../app_text_styles.dart';
import '../widgets/team_logo.dart';

class ExpandableChampTableCard extends StatelessWidget {
  final String title;
  final List<ChampGroupTable> groupTables;
  final bool isExpanded;
  final VoidCallback onTap;

  const ExpandableChampTableCard({
    Key? key,
    required this.title,
    required this.groupTables,
    required this.isExpanded,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // If no group tables, show simple non-expandable card
    if (groupTables.isEmpty) {
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
              child: _buildTablesContent(),
            )
          : SizedBox.shrink(),
    );
  }

  Widget _buildTablesContent() {
    if (groupTables.isEmpty) {
      return Container(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            'Tabellen werden geladen...',
            style: TextStyle(color: Colors.grey[600], fontSize: 14.0),
          ),
        ),
      );
    }

    return Column(
      children: groupTables.map((group) => _buildGroupTable(group)).toList(),
    );
  }

  Widget _buildGroupTable(ChampGroupTable group) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left side: Group name column (rotated 90°)
          _buildGroupNameColumn(group.name, group.table.length),

          // Right side: Team table
          Expanded(child: _buildTeamTable(group.table, group.hidePoints)),
        ],
      ),
    );
  }

  Widget _buildGroupNameColumn(String name, int teamCount) {
    return Container(
      width: 20.0,
      height: (teamCount * 40.0) + 16.0, // Adjust height based on team count
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.0),
          bottomLeft: Radius.circular(8.0),
        ),
      ),
      child: Center(
        child: RotatedBox(
          quarterTurns: 3, // 270 degrees (90 degrees counterclockwise)
          child: Text(
            name,
            style: TextStyle(
              fontSize: 11.0,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildTeamTable(List<LeagueTableRow> table, bool hidePoints) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: table
            .map((entry) => _buildTableRow(entry, hidePoints))
            .toList(),
      ),
    );
  }

  Widget _buildTableRow(LeagueTableRow entry, bool hidePoints) {
    return Container(
      height: 36.0,
      margin: EdgeInsets.only(bottom: 4.0),
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Row(
        children: [
          // Position
          Container(
            width: 24.0,
            child: Text(
              '${entry.position}.',
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),

          SizedBox(width: 8.0),

          // Team logo
          TeamLogo(uri: entry.teamLogoSmallUri, height: 20, width: 20),

          SizedBox(width: 8.0),

          // Team name
          Expanded(
            child: Text(
              entry.teamName,
              style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            ),
          ),

          Text(
            hidePoints ? '' : '${entry.points}',
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
