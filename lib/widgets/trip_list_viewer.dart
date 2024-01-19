import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ride_on_driver/dummy_data/active_trips.dart';
import 'package:ride_on_driver/widgets/trip_card.dart';

import '../provider/ride_request_provider.dart';

class TripListViewer extends StatefulWidget {
  const TripListViewer({super.key, this.onCardTap});
  final Function()? onCardTap;

  @override
  State<TripListViewer> createState() => _TripListViewerState();
}

class _TripListViewerState extends State<TripListViewer> {
  @override
  Widget build(BuildContext context) {
    // Listen for ride requests using Provider
    final rideRequestProvider = Provider.of<RideRequestProvider>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        rideRequestProvider.rideRequests.isEmpty ?
            const Text('No Ride request at the moment') :
            rideRequestProvider.rideRequestLoading == true ?
                CircularProgressIndicator():
        Consumer<RideRequestProvider>(
            builder: (context, rideRequestProvider, child) {
          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            physics: const BouncingScrollPhysics(),
            itemCount: rideRequestProvider.rideRequests.length,
            itemBuilder: (context, index) {
              return TripCard(
                model: rideRequestProvider.rideRequests[index],
                onTap: widget.onCardTap,
              );
            },
          );
          }),
      ],
    );
}}
