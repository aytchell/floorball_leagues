import 'package:flutter/material.dart';

/// StripedTableRow wraps a child and applies alternating background colors
/// and an optional top border for rows after the first. Useful for table-like
/// lists to improve readability.
class StripedTableRow extends StatelessWidget {
  final int index; // zero-based row index
  final Widget child;
  final void Function()? onTap;
  final EdgeInsetsGeometry padding;
  final Color? evenColor;
  final Color? oddColor;
  final Color? borderColor;

  const StripedTableRow({
    super.key,
    required this.index,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    this.evenColor,
    this.oddColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final isEven = index % 2 == 0;
    final bg = isEven
        ? (evenColor ?? Colors.grey.shade50)
        : (oddColor ?? Colors.grey[50]);
    final border = index > 0
        ? Border(
            top: BorderSide(
              color: borderColor ?? Colors.grey.shade300,
              width: 0.5,
            ),
          )
        : null;

    final container = Container(
      decoration: BoxDecoration(color: bg, border: border),
      padding: padding,
      child: child,
    );

    return (onTap == null)
        ? container
        : InkWell(onTap: onTap, child: container);
  }
}
