import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ride_on_driver/services/geo_locator_service.dart';
import 'package:ride_on_driver/services/google_map_service.dart';

import '../main.dart';
import '../provider/map_provider.dart';
import '../provider/ride_request_provider.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  State<MapWidget> createState() => MapWidgetState();
}

class MapWidgetState extends State<MapWidget> {
  late GoogleMapController mapController;
  final Completer<GoogleMapController> _controller = Completer();
  late RideRequestProvider _rideRequestProvider;
   GoogleMapService _googleMapService = GoogleMapService();

  @override
  void initState() {
    super.initState();
    _rideRequestProvider = Provider.of<RideRequestProvider>(context, listen: false);
    _rideRequestProvider.acceptRideRequestResponse();
    _googleMapService.markers;
  }


  @override
  Widget build(BuildContext context) {
    ImageConfiguration imageConfiguration = createLocalImageConfiguration(context, size: const Size(2, 2));
    Provider.of<RideRequestProvider>(context, listen: false).acceptRideRequestResponse();
    RideRequestProvider rideDetails = Provider.of<RideRequestProvider>(context);
    final mapProvider = Provider.of<MapView>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GoogleMap(
        myLocationButtonEnabled: false,
        myLocationEnabled: true,
        zoomGesturesEnabled: true,
        mapToolbarEnabled: false,
        zoomControlsEnabled: false,
        mapType: MapType.normal,
        markers: mapProvider.marker,
        circles: mapProvider.circle,
        polylines:
        // Set<Polyline>.of(mapProvider.polyline.value.values),
        mapProvider.polyline,
        initialCameraPosition: GoogleMapService.googlePlex,
        onMapCreated: (GoogleMapController controller) async {
          _controller.complete(controller);
          mapController = controller;
          // ImageConfiguration imageConfiguration = createLocalImageConfiguration(context, size: const Size(2, 2));
          // Provider.of<RideRequestProvider>(context, listen: false).acceptRideRequestResponse();
          final position = await mapProvider.currentPosition;
          mapController.animateCamera(CameraUpdate.newLatLng(
              mapProvider.convertPositionToLatLng(position)));
          setState(() {});
          rideDetails.displayDirectionForActivateTrip(imageConfiguration);
          // rideDetails.displayDirectionsToPickup(imageConfiguration);
        },
      ),
    );
  }

}
