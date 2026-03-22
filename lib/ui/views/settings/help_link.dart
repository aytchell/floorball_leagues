import 'package:floorball/ui/theme/icons.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpLink extends StatelessWidget {
  static const _linkToDocuemntation =
      'https://github.com/aytchell/floorball_manager/doc/help.md';

  const HelpLink({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('Kurzanleitung (externe Webseite)'),
      subtitle: null,
      leading: Icon(FloorballIcons.aboutDocumentation, size: 20),
      trailing: const Icon(Icons.exit_to_app, size: 16),
      onTap: () async {
        final uri = Uri.parse(_linkToDocuemntation);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
    );
  }
}
