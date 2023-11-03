import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_on_driver/core/constants/assets.dart';
import 'package:ride_on_driver/core/constants/colors.dart';
import 'package:ride_on_driver/core/extensions/build_context_extensions.dart';
import 'package:ride_on_driver/core/extensions/widget_extensions.dart';
import 'package:ride_on_driver/screens/home_screen.dart';
import 'package:ride_on_driver/widgets/check_widget.dart';
import 'package:ride_on_driver/widgets/custom_switch.dart';
import 'package:ride_on_driver/widgets/spacing.dart';

class TripCompletedScreen extends StatelessWidget {
  const TripCompletedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.lightGrey,
        title: const Text('RIDEON247'),
        leading: UnconstrainedBox(
          child: Image.asset(
            Assets.assetsImagesDriverProfile,
            width: 40.w,
          ).clip(radius: 100),
        ),
        actions: [
          ValueListenableBuilder(
              valueListenable: isActiveNotifier,
              builder: (context, isActive, _) {
                return CustomSwitch(
                  value: isActive,
                  onChanged: (value) => isActiveNotifier.value = value,
                );
              }),
          const HorizontalSpacing(10),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            const Spacer(),
            const CheckWidget(),
            const VerticalSpacing(30),
            Text(
              'Nice Ride',
              style: context.textTheme.bodyLarge,
            ),
            const VerticalSpacing(10),
            Text(
              'Trip Completed',
              style: context.textTheme.bodyMedium!.copyWith(
                color: AppColors.grey,
              ),
            ),
            const Spacer(),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: AppColors.green,
                  size: 15,
                ),
                const HorizontalSpacing(10),
                Text(
                  'GO BACK HOME',
                  style: context.textTheme.bodyMedium!.copyWith(color: AppColors.green),
                ).onTap(context.popToHome),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
