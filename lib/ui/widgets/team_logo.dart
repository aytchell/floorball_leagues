import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'cached_network_image.dart';

class TeamLogo extends StatelessWidget {
  final Uri? uri;
  final double height;
  final double width;

  static final _placeholderLogo = 'assets/images/logo_placeholder.svg';

  const TeamLogo({
    super.key,
    required this.uri,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: uri,
      fit: BoxFit.contain,
      width: width,
      height: height,
      errorWidget: (w, h) => _buildLogoReplacement(w, h),
    );
  }

  static Widget _buildLogoReplacement(double? width, double? height) {
    return SvgPicture.asset(
      _placeholderLogo,
      width: width,
      height: height,
      fit: BoxFit.contain,
      colorFilter: ColorFilter.mode(Colors.grey[500]!, BlendMode.srcIn),
    );
  }
}
