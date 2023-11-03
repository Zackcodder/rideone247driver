import 'package:flutter/material.dart';

import '../core/constants/colors.dart';
import '../core/extensions/build_context_extensions.dart';

class AppTextButton extends StatelessWidget {
  const AppTextButton({super.key, required this.onPressed, required this.text});
  final VoidCallback onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        overlayColor: MaterialStatePropertyAll(
          AppColors.yellow.withOpacity(0.4),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: context.textTheme.bodySmall!.copyWith(
          color: AppColors.yellow,
        ),
      ),
    );
  }
}
