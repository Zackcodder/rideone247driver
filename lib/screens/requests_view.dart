import 'package:flutter/material.dart';
import 'package:ride_on_driver/core/extensions/build_context_extensions.dart';
import 'package:ride_on_driver/screens/home_screen.dart';
import 'package:ride_on_driver/widgets/ride_request_box.dart';
import 'package:ride_on_driver/widgets/trip_list_viewer.dart';

class RequestsView extends StatelessWidget {
  const RequestsView({super.key, required this.tabController});
  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return TripListViewer(
      onCardTap: () => showBottonSheet(context),
    );
  }

  void showBottonSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      barrierColor: Colors.transparent,
      elevation: 0,
      backgroundColor: Colors.transparent,
      builder: (context) => RideRequestBox(
        price: 456,
        onAccept: () {
          context.pop();
          isRideActiveNotifier.value = true;
        },
        buttonText: 'Accept',
      ),
    );
  }
}
