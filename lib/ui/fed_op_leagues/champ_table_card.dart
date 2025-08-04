import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../api_models/table.dart';
import '../app_text_styles.dart';

class ExpandableChampTableCard extends StatelessWidget {
  final String title;
  final List<GroupTable> groupTables;
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
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4.0),
      elevation: 2,
      child: Column(
        children: [_buildButtonLikeHeader(), _buildExpandableContent()],
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

  Widget _buildGroupTable(GroupTable group) {
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
          Expanded(child: _buildTeamTable(group.table)),
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

  Widget _buildTeamTable(List<TeamTableEntry> table) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: table.map((entry) => _buildTableRow(entry)).toList(),
      ),
    );
  }

  Widget _buildTableRow(TeamTableEntry entry) {
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
                color: _getPositionColor(entry.position),
              ),
            ),
          ),

          SizedBox(width: 8.0),

          // Team logo
          _buildTeamLogo(entry.teamLogoSmall),

          SizedBox(width: 8.0),

          // Team name
          Expanded(
            child: Text(
              entry.teamName,
              style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Points
          Text(
            '${entry.points}',
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

  Widget _buildTeamLogo(String? logoPath) {
    final logoHost = 'https://saisonmanager.de';
    final placeholderLogo = 'assets/images/logo_placeholder.svg';

    if (logoPath != null) {
      return Image.network(
        '${logoHost}${logoPath}',
        width: 20,
        height: 20,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholderLogo();
        },
      );
    } else {
      return SvgPicture.asset(
        placeholderLogo,
        width: 20,
        height: 20,
        fit: BoxFit.contain,
        colorFilter: ColorFilter.mode(Colors.grey[500]!, BlendMode.srcIn),
        placeholderBuilder: (context) => _buildPlaceholderLogo(),
      );
    }
  }

  Widget _buildPlaceholderLogo() {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.sports_soccer, size: 12, color: Colors.grey.shade600),
    );
  }

  Color _getPositionColor(int position) {
    // Championship group position colors - typically top 2 advance
    if (position <= 2) {
      return Colors.green.shade700; // Qualification positions
    } else if (position == 3) {
      return Colors.orange.shade700; // Playoff position
    } else {
      return Colors.grey.shade700; // Eliminated
    }
  }
}
