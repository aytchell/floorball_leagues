import 'package:floorball/ui/widgets/blinking_striped_row_container.dart';
import 'package:flutter/material.dart';

const greyedLineColor = Color.fromARGB(255, 251, 251, 251);

/// StripedTableRow wraps a child and applies alternating background colors
/// and an optional top border for rows after the first. Useful for table-like
/// lists to improve readability.
class StripedTableRow extends StatelessWidget {
  final int index; // zero-based row index
  final Widget child;
  final void Function()? onTap;
  final EdgeInsetsGeometry? padding;
  final Color? evenColor;
  final Color? oddColor;
  final Color? borderColor;
  final bool blink; // whether to animate the background color

  static const double _verticalPadding = 8.0;
  static const double verticalDefaultPadding = (2 * _verticalPadding);

  const StripedTableRow({
    super.key,
    required this.index,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 12,
      vertical: _verticalPadding,
    ),
    this.evenColor,
    this.oddColor,
    this.borderColor,
    this.blink = false,
  });

  @override
  Widget build(BuildContext context) {
    final isEven = index % 2 == 0;
    final bg = isEven
        ? (evenColor ?? Colors.white)
        : (oddColor ?? greyedLineColor);
    final border = index > 0
        ? Border(
            top: BorderSide(
              color: borderColor ?? Colors.grey.shade300,
              width: 0.5,
            ),
          )
        : null;

    final container = _buildContainer(bg, border, padding, child);

    return (onTap == null)
        ? container
        : InkWell(onTap: onTap, child: container);
  }

  Widget _buildContainer(
    Color bg,
    Border? border,
    EdgeInsetsGeometry? padding,
    Widget child,
  ) => (blink)
      ? BlinkingStripedRowContainer(
          bg: bg,
          border: border,
          padding: padding,
          child: child,
        )
      : Container(
          decoration: BoxDecoration(color: bg, border: border),
          padding: padding,
          child: child,
        );
}
