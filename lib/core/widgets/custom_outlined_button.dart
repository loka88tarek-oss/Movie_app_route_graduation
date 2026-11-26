import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class CustomOutlinedButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final Widget? icon;
  final Color borderColor;
  final Color textColor;
  final Color? backgroundColor;
  final double height;
  final double? width;
  final BorderRadiusGeometry? borderRadius;

  const CustomOutlinedButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.icon,
    this.borderColor = AppColors.primary,
    this.textColor = AppColors.textPrimary,
    this.backgroundColor,
    this.height = 54,
    this.width = double.infinity,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = borderRadius ?? BorderRadius.circular(15);

    return SizedBox(
      width: width,
      height: height,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.transparent,
          foregroundColor: textColor,
          side: BorderSide(color: borderColor, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: effectiveRadius,
          ),
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        child: icon != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  icon!,
                  const SizedBox(width: 10),
                  Text(title),
                ],
              )
            : Text(title),
      ),
    );
  }
}

