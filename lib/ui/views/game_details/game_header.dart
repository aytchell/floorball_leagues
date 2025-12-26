import 'package:floorball/api/models/detailed_game.dart';
import 'package:floorball/ui/app_text_styles.dart';
import 'package:floorball/ui/widgets/team_logo.dart';
import 'package:flutter/material.dart';

class DetailedGameHeader extends StatelessWidget {
  final DetailedGame game;

  const DetailedGameHeader({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            // Home team
            _buildTeam(game.homeLogoUri, game.homeTeamName),

            // Score/Time
            Expanded(
              child: Column(
                children: [
                  if (game.ended || game.started)
                    Text(
                      game.resultString ?? '- : -',
                      style: AppTextStyles.gameCardResultFont.copyWith(
                        fontSize: 24,
                        color: game.started && !game.ended
                            ? Colors.pink
                            : Colors.black,
                      ),
                    )
                  else
                    Text(
                      '${game.startTime ?? '??:??'} Uhr',
                      style: AppTextStyles.gameCardResultFont,
                    ),

                  const SizedBox(height: 4),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getGameStatusColor(game),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getGameStatusText(game),
                      style: TextStyle(
                        color: Colors.grey[50],
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Guest team
            _buildTeam(game.guestLogoUri, game.guestTeamName),
          ],
        ),
      ],
    );
  }

  Expanded _buildTeam(Uri? logoUri, String teamName) {
    return Expanded(
      child: Column(
        children: [
          TeamLogo(uri: logoUri, height: 48, width: 48),
          const SizedBox(height: 8),
          Text(
            teamName,
            style: AppTextStyles.gameCardTeamFont,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getGameStatusColor(DetailedGame game) {
    if (game.ended) return Colors.green;
    if (game.started) return Colors.orange;
    return Colors.blue;
  }

  String _getGameStatusText(DetailedGame game) {
    if (game.ended) return 'Beendet';
    if (game.started) return 'Läuft';
    return 'Geplant';
  }
}
