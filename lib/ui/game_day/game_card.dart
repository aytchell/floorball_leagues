import 'package:flutter/material.dart';
import '../app_text_styles.dart';

class GameResultRow {
  final String homeTeamName;
  final String homeTeamLogo; // URL or asset path
  final String result;
  final String guestTeamLogo; // URL or asset path
  final String guestTeamName;

  GameResultRow({
    required this.homeTeamName,
    required this.homeTeamLogo,
    required this.result,
    required this.guestTeamLogo,
    required this.guestTeamName,
  });
}

class GameCard extends StatelessWidget {
  final GameResultRow game;

  GameCard({Key? key, required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.0),
      elevation: 2,
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Left side: Team logos and names (stacked vertically)
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Home team
                  _buildTeamRow(
                    game.homeTeamLogo,
                    game.homeTeamName,
                    isHome: true,
                  ),

                  SizedBox(height: 8.0),

                  // Guest team
                  _buildTeamRow(
                    game.guestTeamLogo,
                    game.guestTeamName,
                    isHome: false,
                  ),
                ],
              ),
            ),

            SizedBox(width: 16.0),

            // Right side: Result (vertically centered)
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  game.result,
                  style: AppTextStyles.gameCardResultFont,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamRow(
    String logoPath,
    String teamName, {
    required bool isHome,
  }) {
    return Row(
      children: [
        // Team logo
        _buildTeamLogo(logoPath),

        SizedBox(width: 12.0),

        // Team name
        Expanded(
          child: Text(
            teamName,
            style: AppTextStyles.gameCardTeamFont,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildTeamLogo(String logoPath) {
    // Check if it's a network URL
    if (logoPath.startsWith('http')) {
      return Image.network(
        logoPath,
        width: 32,
        height: 32,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholderLogo();
        },
      );
    } else {
      // Fallback for simple team names or when no logo is available
      return _buildPlaceholderLogo();
    }
  }

  Widget _buildPlaceholderLogo() {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.sports_soccer, size: 20, color: Colors.grey.shade600),
    );
  }
}
