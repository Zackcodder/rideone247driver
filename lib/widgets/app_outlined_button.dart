import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/extensions/build_context_extensions.dart';

class AppOutlinedButton extends StatelessWidget {
  const AppOutlinedButton({
    super.key,
    required this.onPressed,
    required this.text,
  })  : _size = const Size(92, 36),
        isLarge = false;

  const AppOutlinedButton.large({
    super.key,
    required this.onPressed,
    required this.text,
  })  : _size = const Size(350, 60),
        isLarge = true;

  final VoidCallback onPressed;
  final String text;
  final Size _size;
  final bool isLarge;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        minimumSize: Size(_size.width.w, _size.height.h),
        textStyle: isLarge ? context.textTheme.bodyMedium : context.textTheme.bodySmall,
      ),
      onPressed: onPressed,
      child: FittedBox(
        child: Text(text),
      ),
    );
  }
}
