
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ride_on_driver/core/constants/colors.dart';
import 'package:ride_on_driver/core/extensions/build_context_extensions.dart';
import 'package:ride_on_driver/core/extensions/widget_extensions.dart';
import 'package:ride_on_driver/screens/home_screen.dart';
import 'package:ride_on_driver/screens/trip_completed.dart';
import 'package:ride_on_driver/widgets/app_elevated_button.dart';
import 'package:ride_on_driver/widgets/map_widget.dart';

import '../core/constants/assets.dart';
import '../provider/ride_request_provider.dart';
import '../widgets/currency_widget.dart';
import '../widgets/icon_text_button.dart';
import 'chat_screen.dart';

class TripsView extends StatefulWidget {
  const TripsView({super.key});

  @override
  State<TripsView> createState() => _TripsViewState();
}

class _TripsViewState extends State<TripsView> {
  late RideRequestProvider _rideRequestProvider;
  @override
  void initState() {
    super.initState();
    _rideRequestProvider =
        Provider.of<RideRequestProvider>(context, listen: false);
    _rideRequestProvider.listenForRideRequests();
  }

  @override
  Widget build(BuildContext context) {
    final rideDetails =
        Provider.of<RideRequestProvider>(context, listen: false);
    return Stack(
      children: [
        const MapWidget(),


        ///
        Positioned(
          bottom: 10,
          child: AppElevatedButton.medium(
            onPressed: () async {
              rideDetails.endRiderTrip(
                  rideDetails.driverId ?? '', rideDetails.acceptedTripId ?? '');
              print(
                  'printing from the end trip button the driver id ${rideDetails.driverId}');
              print(
                  'printing from the end trip button the trip id ${rideDetails.acceptedTripId}');
              context.push(const TripCompletedScreen());
              isRideActiveNotifier.value = false;
              setState(() {});
            },
            text: 'TAP TO COMPLETE',
            icon: Icons.trending_flat_rounded,
            backgroundColor: AppColors.black,
            foregroundColor: AppColors.yellow,
          ).padAll(20.w),
        ),
      ],
    );
  }
}
