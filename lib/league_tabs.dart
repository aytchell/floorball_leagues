import 'package:flutter/material.dart';
import 'api_models/game_operations.dart';

class LeagueTabs extends StatefulWidget {
  final GameOperationLeague league;

  const LeagueTabs({
    Key? key,
    required this.league,
  }) : super(key: key);

  @override
  _LeagueTabsState createState() => _LeagueTabsState();
}

class _LeagueTabsState extends State<LeagueTabs> {
  // Track which item is currently expanded (null means none expanded)
  int? expandedIndex;

  // Sample data - you can replace this with your own data
  final List<TableItem> items = [
    TableItem(
      title: "Product Details",
      content: "This section contains detailed information about our products, including specifications, pricing, and availability.",
    ),
    TableItem(
      title: "Customer Support",
      content: "Our customer support team is available 24/7 to help you with any questions or issues you may have. Contact us via phone, email, or chat.",
    ),
    TableItem(
      title: "Shipping Information",
      content: "We offer fast and reliable shipping worldwide. Standard delivery takes 3-5 business days, while express delivery takes 1-2 business days.",
    ),
    TableItem(
      title: "Returns & Refunds",
      content: "We accept returns within 30 days of purchase. Items must be in original condition. Refunds are processed within 5-7 business days.",
    ),
    TableItem(
      title: "Account Settings",
      content: "Manage your profile, update payment methods, change notification preferences, and customize your experience here.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.league.name),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(8.0),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          final isExpanded = expandedIndex == index;

          return ExpandableCard(
            item: item,
            isExpanded: isExpanded,
            onTap: () {
              setState(() {
                // Toggle expansion: if already expanded, collapse it, otherwise expand it
                expandedIndex = isExpanded ? null : index;
              });
            },
          );
        },
      ),
    );
  }
}

// Separate Card widget
class ExpandableCard extends StatelessWidget {
  final TableItem item;
  final bool isExpanded;
  final VoidCallback onTap;

  const ExpandableCard({
    Key? key,
    required this.item,
    required this.isExpanded,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4.0),
      elevation: 2,
      child: Column(
        children: [
          // Button/Header
          InkWell(
            onTap: onTap,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: isExpanded ? Colors.blue[50] : Colors.white,
                borderRadius: isExpanded 
                    ? BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(4),
                      )
                    : BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isExpanded ? Colors.blue[700] : Colors.black87,
                    ),
                  ),
                  Icon(
                    isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: isExpanded ? Colors.blue[700] : Colors.grey[600],
                  ),
                ],
              ),
            ),
          ),
          // Expandable content
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: isExpanded ? null : 0,
            child: isExpanded
                ? Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(4),
                        bottomRight: Radius.circular(4),
                      ),
                    ),
                    child: Text(
                      item.content,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        height: 1.5,
                      ),
                    ),
                  )
                : SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

// Data model for table items
class TableItem {
  final String title;
  final String content;

  TableItem({
    required this.title,
    required this.content,
  });
}
