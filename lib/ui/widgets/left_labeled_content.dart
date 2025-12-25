import 'package:flutter/material.dart';

abstract class LeftLabeledContent extends StatelessWidget {
  final String labelText;
  final double labelHeight;

  const LeftLabeledContent({
    super.key,
    required this.labelText,
    required this.labelHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left side: Group name column (rotated 90°)
          _buildGroupNameLabel(labelText, labelHeight),

          // Right side: Team table
          Expanded(child: buildContent()),
        ],
      ),
    );
  }

  Widget buildContent();

  Widget _buildGroupNameLabel(String name, double height) {
    return Container(
      width: 20.0,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.0),
          bottomLeft: Radius.circular(8.0),
        ),
      ),
      child: Center(
        child: RotatedBox(
          quarterTurns: 3, // 270 degrees (90 degrees counterclockwise)
          child: Text(
            name,
            style: TextStyle(
              fontSize: 11.0,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
