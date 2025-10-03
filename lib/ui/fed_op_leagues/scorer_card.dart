import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:collection/collection.dart';
import '../../api/models/scorer.dart';
import '../app_text_styles.dart';
import '../widgets/expandable_card.dart';

class ExpandableScorerCard extends StatelessWidget {
  final String title;
  final List<Scorer> scorers;
  final bool isExpanded;
  final VoidCallback onTap;

  const ExpandableScorerCard({
    Key? key,
    required this.title,
    required this.scorers,
    required this.isExpanded,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // If no scorers, show simple non-expandable card
    if (scorers.isEmpty) {
      return _buildEmptyCard();
    }

    // Otherwise show expandable card
    return ExpandableCard(
      title: title,
      isExpanded: isExpanded,
      onTap: onTap,
      child: _buildScorerListContent(),
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
              'Noch keine Scorer vorhanden',
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

  Widget _buildScorerListContent() {
    return Column(
      children: scorers
          .mapIndexed((index, scorer) => _buildScorerRow(index, scorer))
          .toList(),
    );
  }

  Widget _buildScorerRow(int index, Scorer scorer) {
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

          // Player name and team name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  scorer.fullName,
                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.0),
                Text(
                  scorer.teamName,
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.normal,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Points
          Text(
            '${scorer.points} Pkt',
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
