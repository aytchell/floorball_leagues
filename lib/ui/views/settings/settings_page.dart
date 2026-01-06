import 'package:floorball/ui/main_app_scaffold.dart';
import 'package:floorball/ui/theme/text_styles.dart';
import 'package:flutter/cupertino.dart';

class SettingsPage extends StatelessWidget {
  static const String routePath = '/settings';

  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainAppScaffold(
      title: 'Einstellungen',
      showBackButton: true,
      body: Text(
        'Keine Informationen verfügbar',
        style: TextStyles.genericNoData,
      ),
      isSettings: true,
    );
  }
}
