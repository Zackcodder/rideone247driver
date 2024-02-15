import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_on_driver/core/extensions/build_context_extensions.dart';
import 'package:ride_on_driver/screens/home_screen.dart';
import 'package:ride_on_driver/widgets/ride_request_box.dart';
import 'package:ride_on_driver/widgets/trip_list_viewer.dart';

import '../provider/ride_request_provider.dart';

class RequestsView extends StatelessWidget {
  const RequestsView({super.key, required this.tabController});
  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    final rideDetails =
    Provider.of<RideRequestProvider>(context, listen: false);
    return TripListViewer(
      onCardTap: () => showBottonSheet(context),
    );
  }

  void showBottonSheet(BuildContext context) {
    final rideDetails =
    Provider.of<RideRequestProvider>(context, listen: false);
    showModalBottomSheet(
      context: context,
      barrierColor: Colors.transparent,
      elevation: 0,
      backgroundColor: Colors.transparent,
      builder: (context) => RideRequestBox(
        price: 456,
        onAccept: () async{
          /// Call acceptTripRequest function when the button is pressed
          rideDetails.acceptRideRequest(
              rideDetails.tripId ??'', // Assuming driverId is used as the id
              rideDetails.tripLat ??'',
              rideDetails.tripLng??'',
              rideDetails.driverTripId ??''
          );
          print('this is a trip lat in ui: ${rideDetails.tripLat??''}');
          print('this is a trip lng in ui: ${rideDetails.tripLng??''}');
          print('this is a trip id in ui: ${rideDetails.tripId ??''}');
          print('this is a trip driver in ui: ${rideDetails.driverTripId ??''}');
          context.pop();
          isRideActiveNotifier.value = true;
        },
        buttonText: 'Accept',
      ),
    );
  }
}
