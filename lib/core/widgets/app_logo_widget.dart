import 'package:flutter/material.dart';
import '../constants/app_assets.dart';
import '../constants/app_colors.dart';

class AppLogoWidget extends StatelessWidget {
  final double width;
  final double height;

  const AppLogoWidget({
    super.key,
    this.width = 160,
    this.height = 80,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppAssets.routeLogoText,
      width: width,
      height: height,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: AppColors.surface,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primary, width: 2),
        ),
        child: const Icon(
          Icons.play_arrow_rounded,
          color: AppColors.primary,
          size: 48,
        ),
      ),
    );
  }
}

