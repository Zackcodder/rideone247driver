import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_on_driver/core/constants/assets.dart';
import 'package:ride_on_driver/core/constants/colors.dart';
import 'package:ride_on_driver/core/extensions/build_context_extensions.dart';
import 'package:ride_on_driver/core/extensions/widget_extensions.dart';
import 'package:ride_on_driver/screens/chat_screen.dart';
import 'package:ride_on_driver/screens/home_screen.dart';
import 'package:ride_on_driver/widgets/currency_widget.dart';
import 'package:ride_on_driver/widgets/icon_text_button.dart';

class RiderBox extends StatelessWidget {
  const RiderBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.h,
      margin: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.black,
        borderRadius: BorderRadius.all(
          Radius.circular(10.r),
        ),
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Image.asset(Assets.assetsImagesDriverProfile).clip(radius: 100),
            title: Text(
              'Trevor Philips',
              style: context.textTheme.bodyMedium!.copyWith(
                color: Colors.white,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '134 Completed Trips',
                  style: context.textTheme.bodySmall!.copyWith(
                    color: Colors.white,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    5,
                    (index) => Icon(
                      Icons.star,
                      color: index < 4 ? AppColors.yellow : AppColors.grey,
                      size: 15.w,
                    ),
                  ),
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconTextButton(
                  icon: Icons.question_answer_rounded,
                  text: 'Chat',
                  onPressed: () {
                    context.push(const ChatScreen());
                  },
                  iconColor: AppColors.black,
                  textColor: Colors.black,
                  backgroundColor: AppColors.yellow,
                ),
              ],
            ),
          ),
          Divider(color: AppColors.lightGrey.withOpacity(0.5)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Icons.question_answer,
                color: Colors.white,
                size: 25.w,
              ),
              Icon(
                Icons.close,
                color: Colors.white,
                size: 25.w,
              ).onTap(() {
                isRideActiveNotifier.value = false;
              }),
            ],
          ).padHorizontal(20),
          Divider(color: AppColors.lightGrey.withOpacity(0.5)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '4.2 mi',
                style: context.textTheme.bodySmall!.copyWith(
                  color: Colors.white,
                ),
              ),
              const CurrencyWidget(price: 800, color: Colors.white),
              Text(
                '14:20',
                style: context.textTheme.bodySmall!.copyWith(
                  color: Colors.white,
                ),
              ),
              Text(
                'Cash',
                style: context.textTheme.bodySmall!.copyWith(
                  color: Colors.white,
                ),
              ),
            ],
          ).padHorizontal(20).expand(),
        ],
      ),
    );
  }
}
