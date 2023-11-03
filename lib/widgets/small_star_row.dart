import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/extensions/build_context_extensions.dart';
import 'spacing.dart';

class SmallStarRow extends StatelessWidget {
  const SmallStarRow({super.key, required this.starColor, required this.rating});
  final Color starColor;
  final double rating;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.star,
          color: starColor,
          size: 15.w,
        ),
        const HorizontalSpacing(5),
        Text(
          rating.toString(),
          style: context.textTheme.bodySmall!.copyWith(
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }
}
