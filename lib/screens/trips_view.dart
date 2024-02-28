import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ride_on_driver/core/constants/colors.dart';
import 'package:ride_on_driver/core/extensions/build_context_extensions.dart';
import 'package:ride_on_driver/core/extensions/widget_extensions.dart';
import 'package:ride_on_driver/dummy_data/active_trips.dart';
import 'package:ride_on_driver/screens/home_screen.dart';
import 'package:ride_on_driver/screens/trip_completed.dart';
import 'package:ride_on_driver/widgets/app_elevated_button.dart';
import 'package:ride_on_driver/widgets/map_widget.dart';
import 'package:ride_on_driver/widgets/trip_card.dart';

import '../core/painters_clippers/vertical_dot_line.dart';
import '../provider/ride_request_provider.dart';
import '../widgets/spacing.dart';

class TripsView extends StatefulWidget {
  const TripsView({super.key});

  @override
  State<TripsView> createState() => _TripsViewState();
}

class _TripsViewState extends State<TripsView> {
  initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    // ImageConfiguration imageConfiguration = createLocalImageConfiguration(context, size: const Size(2, 2));
    // Provider.of<RideRequestProvider>(context, listen: false).acceptRideRequestResponse();
    final rideDetails =
    Provider.of<RideRequestProvider>(context, listen: false);
    return Stack(
      children: [
        const MapWidget(),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Container(
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     borderRadius: BorderRadius.circular(10.r),
            //   ),
            //   padding: EdgeInsets.all(15.w),
            //   margin: EdgeInsets.only(bottom: 10.h),
            //   child: IntrinsicHeight(
            //     child: Row(
            //       children: [
            //         Column(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           children: [
            //             ///start trip location icon
            //             Icon(
            //               Icons.location_on,
            //               color: AppColors.black,
            //               size: 20.w,
            //             ),
            //             ///line
            //             CustomPaint(
            //               size: Size(1, 30.h),
            //               painter: const DashedLineVerticalPainter(
            //                 color: AppColors.black,
            //               ),
            //             ),
            //             ///destination icon
            //             Icon(
            //               Icons.send_outlined,
            //               color: AppColors.black,
            //               size: 20.w,
            //             ).rotate(-0.6),
            //           ],
            //         ),
            //         const HorizontalSpacing(10),
            //         ///trip start and end location
            //         Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //           children: [
            //             Text(
            //              ' model.paymentMethod',
            //               style: context.textTheme.bodySmall,
            //             ),
            //             const VerticalSpacing(10),
            //             Text(
            //               'model.id',
            //               style: context.textTheme.bodySmall,
            //             ),
            //           ],
            //         ).expand(),
            //         const HorizontalSpacing(10),
            //         ///trip cost, date and rating
            //         Column(
            //           crossAxisAlignment: CrossAxisAlignment.end,
            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //           children: [
            //             ///trip date
            //             Text(
            //               'date',
            //               style: context.textTheme.bodySmall,
            //             ),
            //             ///trip rating
            //             Row(
            //               mainAxisSize: MainAxisSize.min,
            //               children: List.generate(
            //                 5,
            //                     (index) => Icon(
            //                   Icons.star,
            //                   color: Colors.yellow,
            //                   //index < model.rating ? AppColors.yellow : AppColors.grey,
            //                   size: 15.w,
            //                 ),
            //               ),
            //             ),
            //             ///trip cost
            //             SizedBox(
            //               width: 50.w,
            //               height: 20.h,
            //               child: Align(
            //                 alignment: Alignment.centerRight,
            //                 child: const Text('#4000'),
            //                 //CurrencyWidget(price: model.cost),
            //               ),
            //             ),
            //           ],
            //         )
            //       ],
            //     ),
            //   ),
            // ),
            // TripCard(model: activeTripList.first),
            const SizedBox(),
            AppElevatedButton.medium(
              onPressed: () async {
                rideDetails.endRiderTrip(rideDetails.driverId??'',  rideDetails.acceptedTripId ?? '');
                print('printing from the end trip button the driver id ${rideDetails.driverId}');
                print('printing from the end trip button the trip id ${rideDetails.acceptedTripId}');
                context.push(const TripCompletedScreen());
                isRideActiveNotifier.value = false;
                setState(() {

                });
              },
              text: 'TAP TO COMPLETE',
              icon: Icons.trending_flat_rounded,
              backgroundColor: AppColors.black,
              foregroundColor: AppColors.yellow,
            )
          ],
        ).padAll(20.w),
      ],
    );
  }
}
