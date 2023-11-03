import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_on_driver/core/constants/colors.dart';
import 'package:ride_on_driver/core/extensions/build_context_extensions.dart';
import 'package:ride_on_driver/core/extensions/widget_extensions.dart';
import 'package:ride_on_driver/core/painters_clippers/vertical_dot_line.dart';
import 'package:ride_on_driver/model/trip.dart';
import 'package:ride_on_driver/widgets/currency_widget.dart';
import 'package:ride_on_driver/widgets/spacing.dart';

class TripCard extends StatelessWidget {
  const TripCard({super.key, required this.model, this.onTap});
  final Trip model;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
        ),
        padding: EdgeInsets.all(15.w),
        margin: EdgeInsets.only(bottom: 10.h),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.location_on,
                    color: AppColors.black,
                    size: 20.w,
                  ),
                  CustomPaint(
                    size: Size(1, 30.h),
                    painter: const DashedLineVerticalPainter(
                      color: AppColors.black,
                    ),
                  ),
                  Icon(
                    Icons.send_outlined,
                    color: AppColors.black,
                    size: 20.w,
                  ).rotate(-0.6),
                ],
              ),
              const HorizontalSpacing(10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    model.start,
                    style: context.textTheme.bodySmall,
                  ),
                  const VerticalSpacing(10),
                  Text(
                    model.end,
                    style: context.textTheme.bodySmall,
                  ),
                ],
              ).expand(),
              const HorizontalSpacing(10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    model.date,
                    style: context.textTheme.bodySmall,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      5,
                      (index) => Icon(
                        Icons.star,
                        color: index < model.rating ? AppColors.yellow : AppColors.grey,
                        size: 15.w,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 50.w,
                    height: 20.h,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: CurrencyWidget(price: model.cost),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
