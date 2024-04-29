import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ride_on_driver/core/extensions/build_context_extensions.dart';
import 'package:ride_on_driver/core/extensions/widget_extensions.dart';
import 'package:ride_on_driver/widgets/spacing.dart';

import '../core/constants/colors.dart';
import '../core/painters_clippers/vertical_dot_line.dart';
import '../provider/ride_request_provider.dart';
import 'currency_widget.dart';

class TripListViewer extends StatefulWidget {
  const TripListViewer({super.key, this.onCardTap});
  final Function()? onCardTap;

  @override
  State<TripListViewer> createState() => _TripListViewerState();
}

class _TripListViewerState extends State<TripListViewer> {
  late RideRequestProvider _rideRequestProvider;
  @override
  void initState() {
    super.initState();
    _rideRequestProvider = Provider.of<RideRequestProvider>(context, listen: false);
    // _rideRequestProvider.listenForRideRequests();
  }

  @override
  Widget build(BuildContext context) {
    // final rideDetails = Provider.of<RideRequestProvider>(context, listen: false);
    return
      Consumer<RideRequestProvider>(
        builder: (context, rideRequestProvider, child) {
          if (rideRequestProvider.rideRequestLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (rideRequestProvider.hasRideRequests) {
            return ListView.builder(
              itemCount: rideRequestProvider.rideRequests.length,
              itemBuilder: (context, index) {
                final trip = rideRequestProvider.rideRequests[index];
                return GestureDetector(
                  onTap: widget.onCardTap,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    padding: EdgeInsets.all(15.w),
                    margin: EdgeInsets.only(bottom: 10.h, right: 10.w, left: 10.w),
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
                                trip.riderPickUpName,
                                style: context.textTheme.bodySmall,
                              ),
                              const VerticalSpacing(10),
                              Text(
                                trip.riderDestinationName,
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
                                trip.date,
                                style: context.textTheme.bodySmall,
                              ),
                              SizedBox(
                                width: 50.w,
                                height: 20.h,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: CurrencyWidget(price: trip.cost.toDouble()),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: Text('No ride requests at the moment.'),
            );
          }
        },
      );
  }
}
