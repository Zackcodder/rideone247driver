import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_on_driver/core/constants/colors.dart';
import 'package:ride_on_driver/core/extensions/build_context_extensions.dart';

class BlackContainer extends StatelessWidget {
  const BlackContainer({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.w),
      color: AppColors.black,
      child: Text(
        text,
        style: context.textTheme.bodySmall!.copyWith(
          color: AppColors.yellow,
        ),
      ),
    );
  }
}
