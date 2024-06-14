import 'package:flutter/material.dart';

import '../core/constants/colors.dart';
import '../core/extensions/build_context_extensions.dart';

class AppTextButton extends StatelessWidget {
  const AppTextButton({super.key, required this.onPressed, required this.text, this.textColor,});
  final VoidCallback onPressed;
  final String text;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        overlayColor: WidgetStatePropertyAll(
          AppColors.yellow.withOpacity(0.4),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: context.textTheme.bodySmall!.copyWith(
          color: textColor,
        ),
      ),
    );
  }
}
