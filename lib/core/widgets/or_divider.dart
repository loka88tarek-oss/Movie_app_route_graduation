import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class OrDivider extends StatelessWidget {
  final String text;
  final Color dividerColor;
  final Color textColor;

  const OrDivider({
    super.key,
    this.text = 'OR',
    this.dividerColor = AppColors.divider,
    this.textColor = AppColors.textHint,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: dividerColor, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(child: Divider(color: dividerColor, thickness: 1)),
      ],
    );
  }
}

