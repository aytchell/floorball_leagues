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
  List<TableItem> items = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() {
    items =
        widget.league.gameDayTitles.map((gdt) => gdt.title).map((title) => TableItem(
            title: title,
            content: 'Something content',
        )).toList();
    });
  }

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
