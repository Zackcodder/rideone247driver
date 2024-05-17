import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/extensions/build_context_extensions.dart';
import 'spacing.dart';

class AppElevatedButton extends StatelessWidget {
  const AppElevatedButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.backgroundColor,
    this.foregroundColor,
  })  : _size = const Size(92, 36),
        isLarge = false,
        icon = null;

  const AppElevatedButton.large({
    super.key,
    required this.onPressed,
    required this.text,
    this.backgroundColor,
    this.foregroundColor,
    this.icon,
  })  : _size = const Size(350, 60),
        isLarge = true;

  const AppElevatedButton.medium({
    super.key,
    required this.onPressed,
    required this.text,
    this.backgroundColor,
    this.foregroundColor,
    this.icon,
  })  : _size = const Size(350, 45),
        isLarge = true;

  const AppElevatedButton.tiny({
    super.key,
    required this.onPressed,
    required this.text,
    this.backgroundColor,
    this.foregroundColor,
  })  : _size = const Size(50, 40),
        isLarge = true,
        icon = null;

  final VoidCallback onPressed;
  final String text;
  final Size _size;
  final bool isLarge;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        minimumSize: Size(_size.width.w, _size.height.h),
        textStyle: isLarge
            ? context.textTheme.bodyMedium!.copyWith(color: foregroundColor)
            : context.textTheme.bodySmall!.copyWith(color: foregroundColor),
      ),
      onPressed: onPressed,
      child: FittedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text),
            if (icon != null) ...[
              const HorizontalSpacing(5),
              Icon(icon),
            ],
          ],
        ),
      ),
    );
  }
}
