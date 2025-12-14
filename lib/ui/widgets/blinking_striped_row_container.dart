import 'package:flutter/material.dart';

const _defaultBlinkColor = Color.fromARGB(255, 0xf8, 0xbb, 0xd0);

/// StripedTableRow wraps a child and applies alternating background colors
/// and an optional top border for rows after the first. Useful for table-like
/// lists to improve readability.
class BlinkingStripedRowContainer extends StatefulWidget {
  final Color bg;
  final Border? border;
  final EdgeInsetsGeometry? padding;
  final Color blinkColor;
  final Widget child;

  const BlinkingStripedRowContainer({
    super.key,
    required this.bg,
    this.border,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    this.blinkColor = _defaultBlinkColor,
    required this.child,
  });

  @override
  State<BlinkingStripedRowContainer> createState() => _StripedTableRowState();
}

class _StripedTableRowState extends State<BlinkingStripedRowContainer> {
  bool _showBlink = false;

  @override
  void initState() {
    super.initState();
    _startBlinking();
  }

  void _startBlinking() {
    // Delay briefly before starting, then toggle to pink
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() => _showBlink = true);
        // After showing pink, fade back to original color
        Future.delayed(const Duration(milliseconds: 800), () {
          if (mounted) {
            setState(() => _showBlink = false);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Use pink color when blinking, otherwise use the original background
    final background = _showBlink ? widget.blinkColor : widget.bg;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(color: background, border: widget.border),
      padding: widget.padding,
      child: widget.child,
    );
  }
}
