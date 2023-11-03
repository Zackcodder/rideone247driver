import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../core/constants/assets.dart';
import '../core/constants/colors.dart';

class CheckWidget extends StatelessWidget {
  const CheckWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SvgPicture.asset(
          Assets.assetsSvgsCheck,
          width: 100.w,
        ),
        SvgPicture.asset(
          Assets.assetsSvgsCheck,
          width: 60.w,
        ),
        Icon(
          Icons.check_rounded,
          color: AppColors.green,
          size: 30.w,
        )
      ],
    );
  }
}
