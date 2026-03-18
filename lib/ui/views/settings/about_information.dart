import 'package:flutter/material.dart';

class AboutInformation extends StatelessWidget {
  const AboutInformation({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('Über diese App'),
      subtitle: null,
      leading: const Icon(Icons.info_outline, size: 20),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        // TODO
      },
    );
  }
}
