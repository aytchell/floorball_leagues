import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TeamLogo extends StatelessWidget {
  final Uri? uri;
  final double height;
  final double width;

  final _placeholderLogo = 'assets/images/logo_placeholder.svg';

  const TeamLogo({
    required this.uri,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    if (uri != null) {
      return Image.network(
        uri.toString(),
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
    return SvgPicture.asset(
      _placeholderLogo,
      width: width,
      height: height,
      fit: BoxFit.contain,
      colorFilter: ColorFilter.mode(Colors.grey[500]!, BlendMode.srcIn),
    );
  }
}
