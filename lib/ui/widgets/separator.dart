import 'package:floorball/ui/theme/global_colors.dart';
import 'package:flutter/cupertino.dart';

class Separator extends StatelessWidget {
  final double height;

  const Separator({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      color: FloorballColors.mainHeaderGray,
    );
  }
}
