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
      body: Container(
        ///background image
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.assetsImagesPatternBackground),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                ///passenger name
                Column(
                  children: [
                    Text('Passenger',
                        style: context.textTheme.bodySmall!.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            fontFamily: 'SFPRODISPLAYREGULAR')),
                    Text(
                        '${widget.singleTrip.rider.firstName} ${widget.singleTrip.rider.lastName}',
                        style: context.textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            fontFamily: 'SFPRODISPLAYREGULAR'))
                  ],
                ),

                /// trip rating
                Column(
                  children: [
                    Text('Rating',
                        style: context.textTheme.bodySmall!.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            fontFamily: 'SFPRODISPLAYREGULAR')),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: AppColors.yellow,
                        ),
                        Text('4.5',
                            style: context.textTheme.bodyMedium!.copyWith(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                fontFamily: 'SFPRODISPLAYREGULAR')),
                      ],
                    )
                  ],
                ),

                /// status
                Column(
                  children: [
                    Text('Status',
                        style: context.textTheme.bodySmall!.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            fontFamily: 'SFPRODISPLAYREGULAR')),
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        border: Border.all(
                          color: widget.singleTrip.status == 'ended'
                              ? AppColors.red
                              : AppColors.yellow,
                          width: 1.0,
                        ),
                      ),
                      child: Center(
                        child: Text(widget.singleTrip.status,
                            style: context.textTheme.bodyMedium!.copyWith(
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                color: widget.singleTrip.status == 'ended'
                                    ? AppColors.red
                                    : AppColors.green,
                                fontFamily: 'SFPRODISPLAYREGULAR')),
                      ),
                    ),
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
                            widget.singleTrip.createdAt.toLocal().toString(),
                            style: context.textTheme.bodySmall,
                          ),
                          const VerticalSpacing(10),
                          Text(
                            widget.singleTrip.dropOffName,
                            style: context.textTheme.bodyMedium,
                          ),
                          Text(
                            widget.singleTrip.createdAt.toLocal().toString(),
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
                      CurrencyWidget(
                        price: widget.singleTrip.fare ?? 0,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      )
                    ],
                  ),
                  const VerticalSpacing(10),

                  ///discount
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Text('Discount',
                  //         style: context.textTheme.bodyMedium!.copyWith(
                  //             fontWeight: FontWeight.w400,
                  //             fontSize: 13,
                  //             fontFamily: 'SFPRODISPLAYREGULAR')),
                  //     const CurrencyWidget(
                  //       price: 0,
                  //       fontSize: 13,
                  //       fontWeight: FontWeight.w400,
                  //     )
                  //   ],
                  // ),
                  // const VerticalSpacing(10),
                  // Divider(
                  //   color: AppColors.grey.withOpacity(0.7),
                  // ),
                  // const VerticalSpacing(10),

                  ///total amount
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('TOTAL',
                          style: context.textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              fontFamily: 'SFPRODISPLAYREGULAR')),
                      CurrencyWidget(
                        price: widget.singleTrip.fare ?? 0,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      )
                    ],
                  ),
                  const VerticalSpacing(10),

                  ///payment method
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Row(
                  //       children: [
                  //         const Icon(Icons.money_rounded),
                  //         // Image.asset(Assets.assetsSvgsPaymentMethod),
                  //         Text(widget.singleTrip.paymentMethod,
                  //             style: context.textTheme.bodyMedium!.copyWith(
                  //                 fontWeight: FontWeight.w400,
                  //                 fontSize: 13,
                  //                 fontFamily: 'SFPRODISPLAYREGULAR')),
                  //       ],
                  //     ),
                  //     const CurrencyWidget(
                  //       price: 6500,
                  //       fontSize: 13,
                  //       fontWeight: FontWeight.w400,
                  //     )
                  //   ],
                  // ),
                  // const VerticalSpacing(30),
                  //
                  AppElevatedButton.large(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      text: 'Done')
                ],
              ),
            ).expand()
          ],
        ),
      ),
    );
  }
}
