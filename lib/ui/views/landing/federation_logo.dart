import 'package:floorball/api/models/federation.dart';
import 'package:floorball/utils/let_extension.dart';
import 'package:flutter/material.dart';

class FederationLogo extends StatelessWidget {
  final Federation federation;

  const FederationLogo({super.key, required this.federation});

  @override
  Widget build(BuildContext context) =>
      _findStaticAsset(federation.shortName) ?? _imageNotFound();

  Widget _imageNotFound() => Container(
    decoration: BoxDecoration(
      color: Colors.grey[300],
      borderRadius: BorderRadius.circular(8),
    ),
    child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey[600]),
  );

  Widget? _findStaticAsset(String? shortName) =>
      shortName?.let(_mapShortNameToAssetPath)?.let(_getStaticAsset);

  String? _mapShortNameToAssetPath(String shortName) => shortName
      .let(_mapShortNameToBasename)
      ?.let((base) => 'assets/images/federations/$base');

  String? _mapShortNameToBasename(String shortName) {
    switch (shortName) {
      case 'FLV-SH':
        return 'flvsh.png';
      case 'FVB':
        return 'fvb.png';
      case 'FVBB':
        return 'fvbb.png';
      case 'FVBW':
        return 'fvbw.png';
      case 'FVD':
        return 'fvd.png';
      case 'FVH':
        return 'fvh.png';
      case 'FVNB':
        return 'fvnb.jpg';
      case 'NWFV':
        return 'nwfv.jpg';
      case 'SBK Ost':
        return 'ost.png';
      case 'rlpsaar':
        return 'rlpsaar.png';
    }
    return null;
  }

  Widget _getStaticAsset(String assetPath) =>
      Image.asset(assetPath, fit: BoxFit.contain);
}
