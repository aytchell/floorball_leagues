import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../api_models/game_day.dart';
import '../app_text_styles.dart';

class GameResultSlice {
  final Game game;

  GameResultSlice({required this.game});

  String? get homeTeamName => game.homeTeamName;
  String? get homeTeamLogo => game.homeTeamSmallLogo;
  String? get guestTeamName => game.guestTeamName;
  String? get guestTeamLogo => game.guestTeamSmallLogo;

  bool get hasStarted => game.started ?? false;
  bool get hasEnded => game.ended ?? false;
  String get time => game.time ?? '??:??';
  String get result => game.resultString ?? '- : -';
}

class GameCard extends StatelessWidget {
  final GameResultSlice game;

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
                  _buildTeamRow(game.homeTeamLogo, game.homeTeamName),

                  SizedBox(height: 8.0),

                  // Guest team
                  _buildTeamRow(game.guestTeamLogo, game.guestTeamName),
                ],
              ),
            ),

            SizedBox(width: 16.0),

            // Right side: Result (vertically centered)
            Expanded(flex: 1, child: _buildGameResult(game)),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamRow(String? logoPath, String? teamName) {
    return Row(
      children: [
        _buildTeamLogo(logoPath),
        SizedBox(width: 12.0),
        _buildTeamName(teamName),
      ],
    );
  }

  Widget _buildGameResult(GameResultSlice game) {
    final TextStyle textStyle = AppTextStyles.gameCardResultFont;

    if (game.hasEnded) {
      return Container(
        alignment: Alignment.center,
        child: Text(game.result, style: textStyle, textAlign: TextAlign.center),
      );
    } else if (game.hasStarted) {
      return Container(
        alignment: Alignment.center,
        child: Text(
          game.result,
          style: textStyle.copyWith(color: Colors.pink),
          textAlign: TextAlign.center,
        ),
      );
    } else {
      return Container(
        alignment: Alignment.center,
        child: Text(
          '${game.time} Uhr',
          style: textStyle,
          textAlign: TextAlign.center,
        ),
      );
    }
  }

  Widget _buildTeamLogo(String? logoPath) {
    final logoHost = 'https://saisonmanager.de';
    final placeholderLogo = 'assets/images/logo_placeholder.svg';

    if (logoPath != null) {
      return Image.network(
        '${logoHost}${logoPath!}',
        width: 32,
        height: 32,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholderLogo();
        },
      );
    } else {
      return SvgPicture.asset(
        placeholderLogo,
        width: 32,
        height: 32,
        fit: BoxFit.contain,
        colorFilter: ColorFilter.mode(Colors.grey[500]!, BlendMode.srcIn),
        placeholderBuilder: (context) => _buildPlaceholderLogo(),
      );
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

  Widget _buildTeamName(String? teamName) {
    if (teamName != null) {
      return Expanded(
        child: Text(
          teamName!,
          style: AppTextStyles.gameCardTeamFont,
          overflow: TextOverflow.ellipsis,
        ),
      );
    } else {
      return Expanded(
        child: Text(
          'Noch nicht bekannt',
          style: AppTextStyles.gameCardTeamFont.copyWith(color: Colors.grey),
          overflow: TextOverflow.ellipsis,
        ),
      );
    }
  }
}
