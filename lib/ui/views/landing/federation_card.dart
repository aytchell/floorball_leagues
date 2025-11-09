import 'package:flutter/material.dart';
import 'package:floorball/api/models/federation.dart';
import 'package:floorball/ui/app_text_styles.dart';
import 'package:floorball/ui/widgets/cached_network_image.dart';

class FederationCard extends StatelessWidget {
  final Federation federation;
  final VoidCallback onTap;

  const FederationCard({
    super.key,
    required this.federation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: Colors.grey[50],
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
                child: federation.logoUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: federation.logoUrl,
                          fit: BoxFit.contain,
                          showProgress: true,
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: Colors.grey[600],
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
                    federation.name,
                    style: AppTextStyles.federationName,
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
