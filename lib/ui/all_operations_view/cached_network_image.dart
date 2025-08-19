import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CachedNetworkImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit? fit;
  final double? width;
  final double? height;
  final Widget? placeholder;
  final Widget? errorWidget;
  final bool showProgress;

  const CachedNetworkImage({
    Key? key,
    required this.imageUrl,
    this.fit,
    this.width,
    this.height,
    this.placeholder,
    this.errorWidget,
    this.showProgress = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FileResponse>(
      stream: DefaultCacheManager().getImageFile(imageUrl),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final fileResponse = snapshot.data!;

          if (fileResponse is FileInfo) {
            // Image is fully downloaded and cached
            return Image.file(
              fileResponse.file,
              fit: fit,
              width: width,
              height: height,
              errorBuilder: (context, error, stackTrace) {
                return errorWidget ?? _defaultErrorWidget();
              },
            );
          } else if (fileResponse is DownloadProgress && showProgress) {
            // Show download progress
            return _buildProgressIndicator(fileResponse);
          }
        }

        if (snapshot.hasError) {
          return errorWidget ?? _defaultErrorWidget();
        }

        // Initial loading state
        return placeholder ?? _defaultPlaceholder();
      },
    );
  }

  Widget _buildProgressIndicator(DownloadProgress progress) {
    return Container(
      width: width,
      height: height,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              value: progress.totalSize != null
                  ? progress.downloaded / progress.totalSize!
                  : null,
              strokeWidth: 3,
            ),
            if (progress.totalSize != null) ...[
              SizedBox(height: 8),
              Text(
                '${(progress.downloaded / 1024).toStringAsFixed(0)}/${(progress.totalSize! / 1024).toStringAsFixed(0)} KB',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _defaultPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[300],
      child: Center(child: CircularProgressIndicator(strokeWidth: 3)),
    );
  }

  Widget _defaultErrorWidget() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[300],
      child: Center(
        child: Icon(Icons.error_outline, color: Colors.grey[600], size: 40),
      ),
    );
  }
}
