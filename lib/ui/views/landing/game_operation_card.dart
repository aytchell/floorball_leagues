import 'package:flutter/material.dart';
import 'package:floorball/api/models/game_operation.dart';
import 'package:floorball/ui/app_text_styles.dart';
import 'package:floorball/ui/widgets/cached_network_image.dart';

class GameOperationCard extends StatelessWidget {
  final GameOperation gameOperation;
  final VoidCallback onTap;

  const GameOperationCard({
    super.key,
    required this.gameOperation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(8),
                child: gameOperation.logoUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: gameOperation.logoUrl,
                          fit: BoxFit.contain,
                          showProgress: true,
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          color: Colors.yellow, //Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: Colors.black, //Colors.grey[600],
                        ),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    gameOperation.name,
                    style: AppTextStyles.gameOperationName,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
