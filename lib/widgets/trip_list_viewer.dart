import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_on_driver/dummy_data/active_trips.dart';
import 'package:ride_on_driver/widgets/trip_card.dart';

class TripListViewer extends StatelessWidget {
  const TripListViewer({super.key, this.onCardTap});
  final Function()? onCardTap;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      physics: const BouncingScrollPhysics(),
      itemCount: activeTripList.length,
      itemBuilder: (context, index) {
        return TripCard(
          model: activeTripList[index],
          onTap: onCardTap,
        );
      },
    );
  }
}
