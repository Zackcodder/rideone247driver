import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../core/constants/colors.dart';
import '../core/extensions/build_context_extensions.dart';

class SimpleUnderlineTextfield extends StatelessWidget {
  const SimpleUnderlineTextfield(
      {super.key, required this.hintText, this.title, this.suffixSvgPath});
  final String? title;
  final String hintText;
  final String? suffixSvgPath;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null)
          Row(
            children: [
              Text(
                title!,
                style: context.textTheme.bodyMedium,
              ),
              if (suffixSvgPath != null) ...[
                const Spacer(),
                SvgPicture.asset(suffixSvgPath!, width: 25.w)
              ],
            ],
          ),
        TextField(
          style: context.textTheme.bodySmall!.copyWith(
            color: AppColors.black,
          ),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
            hintText: hintText,
            suffixIconConstraints: const BoxConstraints(
              maxWidth: 20,
              maxHeight: 20,
            ),
            hintStyle:
                context.textTheme.bodySmall!.copyWith(color: AppColors.black.withOpacity(0.5)),
          ),
        ),
      ],
    );
  }
}
