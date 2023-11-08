import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_on_driver/core/constants/colors.dart';
import 'package:ride_on_driver/core/extensions/build_context_extensions.dart';
import 'package:ride_on_driver/core/extensions/list_extensions.dart';
import 'package:ride_on_driver/core/extensions/widget_extensions.dart';
import 'package:ride_on_driver/core/overlays/dialogs.dart';
import 'package:ride_on_driver/widgets/app_elevated_button.dart';
import 'package:ride_on_driver/widgets/currency_widget.dart';
import 'package:ride_on_driver/widgets/spacing.dart';

class RideRequestBox extends StatelessWidget {
  const RideRequestBox(
      {super.key,
      required this.onAccept,
      required this.buttonText,
      required this.price});
  final Function() onAccept;
  final String buttonText;
  final int price;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160.h,
      margin: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.black,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50.r),
          topRight: Radius.circular(50.r),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              [
                Text('Distance',
                    style: context.textTheme.bodySmall!.copyWith(
                      color: Colors.grey,
                    )),
                Text('4.2 mi',
                    style: context.textTheme.bodySmall!.copyWith(
                      color: Colors.white,
                    )),
              ].toColumn(),
              [
                Text('Price',
                    style: context.textTheme.bodySmall!.copyWith(
                      color: Colors.grey,
                    )),
                CurrencyWidget(
                  price: price,
                  color: AppColors.white,
                  fontSize: 14.sp,
                ),
              ].toColumn(),
              [
                Text(
                  'ETA',
                  style: context.textTheme.bodySmall!.copyWith(
                    color: Colors.grey,
                  ),
                ),
                Text(
                  '14:20',
                  style: context.textTheme.bodySmall!.copyWith(
                    color: Colors.white,
                  ),
                ),
              ].toColumn(),
              [
                Text(
                  'Payment',
                  style: context.textTheme.bodySmall!.copyWith(
                    color: Colors.grey,
                  ),
                ),
                Text(
                  'Cash',
                  style: context.textTheme.bodySmall!.copyWith(
                    color: Colors.white,
                  ),
                ),
              ].toColumn(),
            ],
          ).expand(),
          Row(
            children: [
              AppElevatedButton.medium(
                onPressed: onAccept,
                text: buttonText,
                icon: Icons.trending_flat_rounded,
              ).expand(2),
              const HorizontalSpacing(10),
              AppElevatedButton.medium(
                onPressed: () => AppDialogs.showNegotialtionDialog(context),
                text: 'Negotiate',
                backgroundColor: AppColors.lightGrey,
              ).expand(),
            ],
          )
        ],
      ),
    );
  }
}
