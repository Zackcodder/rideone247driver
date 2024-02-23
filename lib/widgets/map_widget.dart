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

  // List<LatLng> polylineCoordinates = [];
  //
  // Map<PolylineId, Polyline> polyLines = {};
  //
  // late MapView _mapViewProvider;
  //
  // @override
  // void initState() {
  //   super.initState();
  //   print('init state ran');
  //   ImageConfiguration imageConfiguration = createLocalImageConfiguration(context, size: const Size(2, 2));
  //   Provider.of<RideRequestProvider>(context, listen: false).displayDirectionsToPickup(imageConfiguration);
  //
  // }
  //
  // _polylineListener() async {
  //   print('This listener ran again');
  //   await Future.delayed(const Duration(milliseconds: 1));
  //   if (mounted) setState(() {});
  // }
  //
  // @override
  // void dispose() {
  //   _mapViewProvider.removeListener(_polylineListener);
  //   super.dispose();
  // }


  @override
  Widget build(BuildContext context) {
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
          ImageConfiguration imageConfiguration = createLocalImageConfiguration(context, size: const Size(2, 2));
          Provider.of<RideRequestProvider>(context, listen: false).acceptRideRequestResponse(imageConfiguration);
          final position = await mapProvider.currentPosition;
          mapController.animateCamera(CameraUpdate.newLatLng(
              mapProvider.convertPositionToLatLng(position)));
        },
      ),
    );
  }

}
