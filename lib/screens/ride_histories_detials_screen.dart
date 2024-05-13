import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_on_driver/core/constants/colors.dart';
import 'package:ride_on_driver/core/extensions/build_context_extensions.dart';
import 'package:ride_on_driver/core/extensions/widget_extensions.dart';
import 'package:ride_on_driver/model/rides_histories_model.dart';

import '../core/constants/assets.dart';
import '../core/painters_clippers/vertical_dot_line.dart';
import '../widgets/app_elevated_button.dart';
import '../widgets/currency_widget.dart';
import '../widgets/map_widget.dart';
import '../widgets/spacing.dart';

class RidesHistoriesDetailsScreen extends StatefulWidget {
  final RidesHistories singleTrip;
  const RidesHistoriesDetailsScreen(this.singleTrip, {Key? key})
      : super(key: key);

  @override
  State<RidesHistoriesDetailsScreen> createState() =>
      _RidesHistoriesDetailsScreenState();
}

class _RidesHistoriesDetailsScreenState
    extends State<RidesHistoriesDetailsScreen> {
  late final Uint8List image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trip History',
            style: context.textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                fontFamily: 'SFPRODISPLAYREGULAR')),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      backgroundColor: AppColors.lightGrey,
      body: ListView(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(
            color: AppColors.grey.withOpacity(0.7),
          ),

          ///google map
          const SizedBox(
            height: 159,
            child: MapWidget(),
          ),
          const VerticalSpacing(10),

          ///driver details
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ///Driver name
              Column(
                children: [
                  Text('Driver',
                      style: context.textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          fontFamily: 'SFPRODISPLAYREGULAR')),
                  Text(
                      '${widget.singleTrip.driver.firstName} ${widget.singleTrip.driver.lastName}',
                      style: context.textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          fontFamily: 'SFPRODISPLAYREGULAR'))
                ],
              ),

              /// driver car plate number
              Column(
                children: [
                  Text('Plate Number',
                      style: context.textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          fontFamily: 'SFPRODISPLAYREGULAR')),
                  Text(widget.singleTrip.driver.vehicleDetails.numberPlate,
                      style: context.textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          fontFamily: 'SFPRODISPLAYREGULAR'))
                ],
              ),

              /// car model and type
              Column(
                children: [
                  Text('Car Type',
                      style: context.textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          fontFamily: 'SFPRODISPLAYREGULAR')),
                  Text(
                      '${widget.singleTrip.driver.vehicleDetails.model} ${widget.singleTrip.driver.vehicleDetails.make}',
                      style: context.textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          fontFamily: 'SFPRODISPLAYREGULAR'))
                ],
              ),

              ///car color
              Column(
                children: [
                  Text('Car Color',
                      style: context.textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          fontFamily: 'SFPRODISPLAYREGULAR')),
                  Text(widget.singleTrip.driver.vehicleDetails.color,
                      style: context.textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          fontFamily: 'SFPRODISPLAYREGULAR'))
                ],
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(
                  color: AppColors.grey.withOpacity(0.7),
                ),

                ///pickup and destination name
                Row(
                  children: [
                    /// pickup and destination icon
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
                          // Icons.electric_bike,
                          color: AppColors.black,
                          size: 20.w,
                        ).rotate(-0.6),
                      ],
                    ),
                    const HorizontalSpacing(10),

                    /// pickup and destination names
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.singleTrip.pickUpName,
                          style: context.textTheme.bodyMedium,
                        ),
                        Text(
                          widget.singleTrip.rider.openingTime,
                          style: context.textTheme.bodySmall,
                        ),
                        const VerticalSpacing(10),
                        Text(
                          widget.singleTrip.dropOffName,
                          style: context.textTheme.bodyMedium,
                        ),
                        Text(
                          '10:20am',
                          style: context.textTheme.bodySmall,
                        ),
                      ],
                    ).expand(),
                    const HorizontalSpacing(10),
                  ],
                ),
                Divider(
                  color: AppColors.grey.withOpacity(0.7),
                ),

                ///payment summary
                const Text('Payment Summary'),
                const VerticalSpacing(10),

                ///fare
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Fare',
                        style: context.textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                            fontFamily: 'SFPRODISPLAYREGULAR')),
                    CurrencyWidget(
                      price: widget.singleTrip.fare ?? 0,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    )
                  ],
                ),
                const VerticalSpacing(10),

                ///booking fee
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Booking Fee',
                        style: context.textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                            fontFamily: 'SFPRODISPLAYREGULAR')),
                    const CurrencyWidget(
                      price: 1500,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    )
                  ],
                ),
                const VerticalSpacing(10),

                ///discount
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Discount',
                        style: context.textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                            fontFamily: 'SFPRODISPLAYREGULAR')),
                    const CurrencyWidget(
                      price: 0,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    )
                  ],
                ),
                const VerticalSpacing(10),
                Divider(
                  color: AppColors.grey.withOpacity(0.7),
                ),
                const VerticalSpacing(10),

                ///total amount
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('TOTAL',
                        style: context.textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            fontFamily: 'SFPRODISPLAYREGULAR')),
                    const CurrencyWidget(
                      price: 7890.00,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    )
                  ],
                ),
                const VerticalSpacing(10),

                ///payment method
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.money_rounded),
                        // Image.asset(Assets.assetsSvgsPaymentMethod),
                        Text(widget.singleTrip.paymentMethod,
                            style: context.textTheme.bodyMedium!.copyWith(
                                fontWeight: FontWeight.w400,
                                fontSize: 13,
                                fontFamily: 'SFPRODISPLAYREGULAR')),
                      ],
                    ),
                    const CurrencyWidget(
                      price: 6500,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    )
                  ],
                ),
                const VerticalSpacing(30),
                //
                // AppElevatedButton.large(
                //     onPressed: () {}, text: 'Download Receipt')
              ],
            ),
          ).expand()
        ],
      ),
    );
  }
}
