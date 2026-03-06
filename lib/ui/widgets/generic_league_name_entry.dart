import 'package:floorball/routes.dart';
import 'package:floorball/ui/theme/text_styles.dart';
import 'package:flutter/material.dart';

class GenericLeagueNameEntry extends StatelessWidget {
  final int leagueId;
  final String leagueName;
  final Widget leadingChild;
  final Widget? trailingChild;

  const GenericLeagueNameEntry({
    super.key,
    required this.leagueId,
    required this.leagueName,
    required this.leadingChild,
    this.trailingChild,
  });

  @override
  Widget build(BuildContext context) => ListTile(
    leading: leadingChild,
    trailing: trailingChild,
    title: TextButton(
      onPressed: () => LeagueDetailsPageRoute(
        leagueId: leagueId,
        leagueName: leagueName,
      ).push(context),
      style: TextButton.styleFrom(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.zero,
      ),
      child: _highlightYouthSelector(leagueName),
    ),
  );

  static final _regEx = RegExp(r'^(.*)(U\d{1,2}|Herren|Damen)(.*)$');

  Widget _highlightYouthSelector(String text) {
    final match = _regEx.firstMatch(text);

    if (match == null) {
      return Text(text, style: TextStyles.leaguesListLight);
    } else {
      return Text.rich(
        TextSpan(
          children: [
            TextSpan(text: match.group(1), style: TextStyles.leaguesListLight),
            TextSpan(text: match.group(2), style: TextStyles.leaguesListDark),
            TextSpan(text: match.group(3), style: TextStyles.leaguesListLight),
          ],
        ),
      );
    }
  }
}
