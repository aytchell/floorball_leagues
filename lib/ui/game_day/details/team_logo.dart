import 'package:flutter/material.dart';

class TeamLogo extends StatelessWidget {
  final String? logoPath;
  final double height;
  final double width;

  const TeamLogo({
    required this.logoPath,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    final logoHost = 'https://www.saisonmanager.de';

    if (logoPath != null) {
      return Image.network(
        '${logoHost}${logoPath}',
        width: width,
        height: height,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholderLogo();
        },
      );
    } else {
      return _buildPlaceholderLogo();
    }
  }

  Widget _buildPlaceholderLogo() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.sports_soccer, size: 28, color: Colors.grey.shade600),
    );
  }
}
