import 'package:flutter/material.dart';

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

class GameSubdayRows {
  final Widget info;
  final List<GameResultRow> games;

  GameSubdayRows({required this.info, required this.games});
}

class SportGamesTable extends StatelessWidget {
  final GameSubdayRows subday;

  const SportGamesTable({Key? key, required this.subday}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> list = [];
    list.add(subday.info);
    list.addAll(subday.games.map((game) => _buildGameCard(game)).toList());

    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(children: list),
    );
  }

  Widget _buildGameCard(GameResultRow game) {
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
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
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
            style: TextStyle(
              fontSize: 16,
              fontWeight: isHome ? FontWeight.w600 : FontWeight.w500,
              color: isHome ? Colors.black87 : Colors.black54,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildTeamLogo(String logoPath) {
    // Check if it's a network URL or asset path
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
    } else if (logoPath.startsWith('assets/')) {
      return Image.asset(
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
