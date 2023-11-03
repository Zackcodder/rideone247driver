import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/extensions/build_context_extensions.dart';
import 'spacing.dart';

class IconTextButton extends StatelessWidget {
  const IconTextButton({
    super.key,
    required this.onPressed,
    required this.iconColor,
    required this.textColor,
    required this.text,
    required this.icon,
    this.backgroundColor,
  });

  final String text;
  final IconData icon;
  final Function() onPressed;
  final Color iconColor;
  final Color textColor;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 5.w,
          vertical: 8.h,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.w),
          color: backgroundColor,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20.w,
              color: iconColor,
            ),
            const HorizontalSpacing(5),
            Text(
              text,
              style: context.textTheme.bodyMedium!.copyWith(color: textColor),
            ),
          ],
        ),
      ),
    );
  }
}
