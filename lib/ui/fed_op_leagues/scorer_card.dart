import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:collection/collection.dart';
import '../../api_models/scorer.dart';
import '../app_text_styles.dart';

class ExpandableScorerCard extends StatelessWidget {
  final String title;
  final List<ScorerEntry> scorerEntries;
  final bool isExpanded;
  final VoidCallback onTap;

  const ExpandableScorerCard({
    Key? key,
    required this.title,
    required this.scorerEntries,
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
              child: _buildScorerListContent(),
            )
          : SizedBox.shrink(),
    );
  }

  Widget _buildScorerListContent() {
    if (scorerEntries.isEmpty) {
      return Container(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            'Scorer werden geladen...',
            style: TextStyle(color: Colors.grey[600], fontSize: 14.0),
          ),
        ),
      );
    }

    return Column(
      children: scorerEntries
          .mapIndexed((index, entry) => _buildScorerRow(index, entry))
          .toList(),
    );
  }

  Widget _buildScorerRow(int index, ScorerEntry entry) {
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
              '${index + 1}.',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),

          SizedBox(width: 12.0),

          // Team logo
          _buildScorerLogo(),

          SizedBox(width: 12.0),

          // Team name
          Expanded(
            child: Text(
              entry.fullName,
              style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Points (optional - you can remove this if you only want position, logo, name)
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

  Widget _buildScorerLogo() {
    final placeholderLogo = 'assets/images/scorer_placeholder.svg';

    return SvgPicture.asset(
      placeholderLogo,
      width: 24,
      height: 24,
      fit: BoxFit.contain,
      colorFilter: ColorFilter.mode(Colors.grey[500]!, BlendMode.srcIn),
      placeholderBuilder: (context) => Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.sports_soccer, size: 14, color: Colors.grey.shade600),
      ),
    );
  }
}
