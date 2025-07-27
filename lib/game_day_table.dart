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

class SportGamesTable extends StatelessWidget {
  final List<GameResultRow> games;

  const SportGamesTable({Key? key, required this.games}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(2.5), // homeTeamName
          1: FlexColumnWidth(1.0), // homeTeamLogo
          2: FlexColumnWidth(1.5), // result
          3: FlexColumnWidth(1.0), // guestTeamLogo
          4: FlexColumnWidth(2.5), // guestTeamName
        },
        border: _createBorder(),
        children:
            // Game rows
            games.map((game) => _buildGameRow(game)).toList(),
      ),
    );
  }

  TableRow _buildGameRow(GameResultRow game) {
    return TableRow(
      children: [
        // Home Team Name (right aligned)
        Container(
          padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
          child: Text(
            game.homeTeamName,
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),

        // Home Team Logo (centered)
        Container(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          child: Center(child: _buildTeamLogo(game.homeTeamLogo)),
        ),

        // Result (centered)
        Container(
          padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
          child: Text(
            game.result,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade700,
            ),
          ),
        ),

        // Guest Team Logo (centered)
        Container(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          child: Center(child: _buildTeamLogo(game.guestTeamLogo)),
        ),

        // Guest Team Name (left aligned)
        Container(
          padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
          child: Text(
            game.guestTeamName,
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
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

  TableBorder _createBorder() {
    final side = BorderSide(color: Colors.grey.shade300, width: 1);

    return TableBorder(
      top: BorderSide.none,
      right: BorderSide.none,
      bottom: BorderSide.none,
      left: BorderSide.none,
      horizontalInside: side,
      verticalInside: BorderSide.none,
      borderRadius: BorderRadius.zero,
    );
  }
}
