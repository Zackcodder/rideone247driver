import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_on_driver/core/constants/colors.dart';
import 'package:ride_on_driver/core/extensions/build_context_extensions.dart';
import 'package:ride_on_driver/core/extensions/widget_extensions.dart';
import 'package:ride_on_driver/dummy_data/active_trips.dart';
import 'package:ride_on_driver/screens/home_screen.dart';
import 'package:ride_on_driver/screens/trip_completed.dart';
import 'package:ride_on_driver/widgets/app_elevated_button.dart';
import 'package:ride_on_driver/widgets/map_widget.dart';
import 'package:ride_on_driver/widgets/trip_card.dart';

class TripsView extends StatelessWidget {
  const TripsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const MapWidget(),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TripCard(model: activeTripList.first),
            AppElevatedButton.medium(
              onPressed: () {
                context.push(const TripCompletedScreen());
                isRideActiveNotifier.value = false;
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
