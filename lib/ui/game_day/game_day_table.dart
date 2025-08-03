import 'package:flutter/material.dart';
import 'game_card.dart';

class GameSubdayRows {
  final Widget info;
  final List<GameResultSlice> games;

  GameSubdayRows({required this.info, required this.games});
}

class SportGamesTable extends StatelessWidget {
  final List<GameSubdayRows> subdays;

  const SportGamesTable({Key? key, required this.subdays}) : super(key: key);

  List<Widget> _buildSubday(GameSubdayRows sub) {
    List<Widget> list = [];
    list.add(sub.info);
    list.addAll(sub.games.map((game) => GameCard(game: game)).toList());
    return list;
  }

  @override
  Widget build(BuildContext context) {
    var allRows = subdays
        .map((sub) => _buildSubday(sub))
        .expand((it) => it)
        .toList();

    return Container(
      padding: EdgeInsets.all(4.0),
      child: Column(children: allRows),
    );
  }
}
