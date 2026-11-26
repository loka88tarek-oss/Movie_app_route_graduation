import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/core/constants/app_colors.dart';

class MovieNetImage extends StatelessWidget {
  const MovieNetImage({
    super.key,
    required this.url,
    required this.height,
    required this.radius,
  });

  final String? url;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: CachedNetworkImage(
        imageUrl: url ?? '',
        width: double.infinity,
        height: height,
        fit: BoxFit.cover,
        placeholder:
            (_, __) =>
                Container(height: height, color: AppColors.surfaceVariant),
        errorWidget:
            (_, __, ___) => Container(
              height: height,
              color: AppColors.surfaceVariant,
              child: const Icon(Icons.broken_image, color: Colors.white38),
            ),
      ),
    );
  }
}
