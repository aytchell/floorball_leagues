import 'package:floorball/ui/theme/text_styles.dart';
import 'package:floorball/ui/views/settings/version_info.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

TextSpan _href(String text, String uriText) => TextSpan(
  text: text,
  style: TextStyles.aboutTextHref,
  recognizer: TapGestureRecognizer()
    ..onTap = () async {
      final uri = Uri.parse(uriText);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    },
);

final Widget _aboutText = RichText(
  text: TextSpan(
    style: TextStyles.aboutText,
    children: [
      const TextSpan(text: 'Diese App ist '),
      const TextSpan(
        text: 'keine offizielle App',
        style: TextStyles.aboutBoldText,
      ),
      const TextSpan(text: ' von Floorball Deutschland. Sie ist das '),
      const TextSpan(text: 'Hobby-Projekt eines einzelnen Entwicklers '),
      const TextSpan(text: '(vom FBC München 🥳). '),
      const TextSpan(text: 'Trotzdem nutzt diese App die Daten des '),
      _href('Saisonmanagers', 'https://www.saisonmanager.de/'),
      const TextSpan(text: ' (das ist abgesprochen).'),
      const TextSpan(text: '\n\nDie angezeigten Informationen sind also so '),
      const TextSpan(text: 'aktuell und korrekt und vollständig, wie sie der '),
      const TextSpan(text: 'Saisonmanager liefert. '),
      const TextSpan(text: '\n\nDiese App braucht keine besonderen '),
      const TextSpan(text: 'Berechtigungen und sammelt keine Daten in irgend'),
      const TextSpan(text: 'einer Form. Einzig aufgrund der Abfragen '),
      const TextSpan(text: 'wird die aktuelle IP-Adresse dieses Endgeräts '),
      const TextSpan(text: 'an den Saisonmanager geschickt (was dort damit '),
      const TextSpan(text: 'passiert, kann ich nicht sagen).'),
      const TextSpan(text: '\n\nFalls jemand Bugs findet oder Ideen hat '),
      const TextSpan(text: 'oder selbst Verbesserungen einbringen will, so '),
      const TextSpan(text: 'sei auf\n\n'),
      _href(
        'github.com/aytchell/floorball_leagues',
        'https://github.com/aytchell/floorball_leagues',
      ),
      const TextSpan(text: '\n\nverwiesen. Bitte behaltet aber im Hinterkopf,'),
      const TextSpan(text: ' dass das alles Freizeit ist.'),
    ],
  ),
);

class AboutInformation extends StatelessWidget {
  const AboutInformation({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('Über diese App'),
      subtitle: null,
      leading: const Icon(Icons.info_outline, size: 20),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () => _showAboutSheet(context),
    );
  }

  void _showAboutSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Padding(
          padding: const EdgeInsets.all(24.0),
          child: ListView(
            controller: scrollController,
            children: [
              const Text(
                'Über diese App',
                style: TextStyles.aboutSectionHeading,
              ),
              const SizedBox(height: 16),
              _aboutText,
              const SizedBox(height: 24),
              VersionInfo(),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  child: const Text('OK', style: TextStyles.aboutOkButton),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
