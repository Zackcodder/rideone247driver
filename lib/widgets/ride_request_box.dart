import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ride_on_driver/core/constants/colors.dart';
import 'package:ride_on_driver/core/extensions/build_context_extensions.dart';
import 'package:ride_on_driver/core/extensions/list_extensions.dart';
import 'package:ride_on_driver/core/extensions/widget_extensions.dart';
import 'package:ride_on_driver/core/overlays/dialogs.dart';
import 'package:ride_on_driver/widgets/app_elevated_button.dart';
import 'package:ride_on_driver/widgets/currency_widget.dart';
import 'package:ride_on_driver/widgets/spacing.dart';

import '../provider/ride_request_provider.dart';

class RideRequestBox extends StatefulWidget {
  const RideRequestBox(
      {super.key,
      required this.onAccept,
      required this.buttonText,
      required this.price});
  final Function() onAccept;
  final String buttonText;
  final int price;

  @override
  State<RideRequestBox> createState() => _RideRequestBoxState();
}

class _RideRequestBoxState extends State<RideRequestBox> {
  @override
  Widget build(BuildContext context) {
    final rideDetails =
    Provider.of<RideRequestProvider>(context, listen: false);
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
                Text(rideDetails.distance ?? 'calculating',
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
                  price: widget.price,
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
                  rideDetails.etaTimer ?? 'calculating',
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
                  rideDetails.paymentMethod ?? 'nil',
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
                onPressed: widget.onAccept,
                text: widget.buttonText,
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
