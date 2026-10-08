import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../app/theme/app_colors.dart';

class AppImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;

  const AppImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final fallbackBg = isDark ? Colors.grey.shade800 : Colors.grey.shade200;
    final fallbackIconColor = isDark ? Colors.white54 : Colors.grey.shade500;

    if (imageUrl.isEmpty || !imageUrl.startsWith('http')) {
      return Container(
        width: width,
        height: height,
        color: fallbackBg,
        child: Icon(Icons.sports_soccer, color: fallbackIconColor),
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => Container(
        width: width,
        height: height,
        color: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
      ),
      errorWidget: (context, url, error) => Container(
        width: width,
        height: height,
        color: fallbackBg,
        child: Icon(Icons.error_outline, color: fallbackIconColor),
      ),
    );
  }
}
