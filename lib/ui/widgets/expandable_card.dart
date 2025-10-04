import 'package:flutter/material.dart';
import 'package:floorball/ui/app_text_styles.dart';

/// A reusable expandable card widget with animated expand/collapse behavior.
///
/// This widget provides a consistent header with title and expand/collapse icon,
/// and an animated content section that shows/hides based on [isExpanded].
class ExpandableCard extends StatelessWidget {
  /// The title displayed in the header
  final String title;

  /// Whether the card is currently expanded
  final bool isExpanded;

  /// Callback when the header is tapped
  final VoidCallback onTap;

  /// The content to display when expanded
  final Widget child;

  /// Optional custom header content to replace the default title + icon header
  final Widget? customHeader;

  /// Optional custom background color for expanded state
  final Color? expandedBackgroundColor;

  /// Optional custom background color for expanded content
  final Color? expandedContentBackgroundColor;

  const ExpandableCard({
    Key? key,
    required this.title,
    required this.isExpanded,
    required this.onTap,
    required this.child,
    this.customHeader,
    this.expandedBackgroundColor,
    this.expandedContentBackgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4.0),
      elevation: 2,
      child: Column(children: [_buildHeader(), _buildExpandableContent()]),
    );
  }

  Widget _buildHeader() {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: isExpanded
              ? (expandedBackgroundColor ?? Colors.blue[50])
              : Colors.white,
          borderRadius: isExpanded
              ? BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                )
              : BorderRadius.circular(4),
        ),
        child: customHeader ?? _buildDefaultHeader(),
      ),
    );
  }

  Widget _buildDefaultHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: isExpanded
              ? AppTextStyles.gameDayTitleExpanded
              : AppTextStyles.gameDayTitleCollapsed,
        ),
        Icon(
          isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
          color: isExpanded ? Colors.blue[700] : Colors.grey[600],
        ),
      ],
    );
  }

  Widget _buildExpandableContent() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: isExpanded ? null : 0,
      child: isExpanded
          ? Container(
              width: double.infinity,
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: expandedContentBackgroundColor ?? Colors.grey[50],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(4),
                  bottomRight: Radius.circular(4),
                ),
              ),
              child: child,
            )
          : SizedBox.shrink(),
    );
  }
}
