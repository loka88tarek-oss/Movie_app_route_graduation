import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class CustomLoadingIndicator extends StatelessWidget {
  final Color color;
  final double? size;
  final double strokeWidth;

  const CustomLoadingIndicator({
    super.key,
    this.color = AppColors.primary,
    this.size,
    this.strokeWidth = 3.0,
  });

  @override
  Widget build(BuildContext context) {
    final indicator = CircularProgressIndicator(
      strokeWidth: strokeWidth,
      valueColor: AlwaysStoppedAnimation<Color>(color),
    );

    if (size != null) {
      return Center(
        child: SizedBox(
          width: size,
          height: size,
          child: indicator,
        ),
      );
    }

    return Center(child: indicator);
  }
}

