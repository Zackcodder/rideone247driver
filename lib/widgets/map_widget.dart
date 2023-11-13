import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ride_on_driver/services/geo_locator_service.dart';
import 'package:ride_on_driver/services/google_map_service.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  State<MapWidget> createState() => MapWidgetState();
}

class MapWidgetState extends State<MapWidget> {
  final Completer<GoogleMapController> _controller = Completer();

  // static const CameraPosition _kLake = CameraPosition(
  //     bearing: 192.8334901395799,
  //     target: LatLng(37.43296265331129, -122.08832357078792),
  //     tilt: 59.440717697143555,
  //     zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    final googleMapService = context.read<GoogleMapService>();
    final geoLocatorService = context.read<GeoLocatorService>();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: googleMapService.getInitialCameraPosition(14.0),
        onMapCreated: googleMapService.onMapCreated,
        // (GoogleMapController controller) {
        //   _controller.complete(controller);
        // },
        mapToolbarEnabled: false,
        zoomControlsEnabled: true,
        markers: googleMapService.markers,
        circles: googleMapService.circles,
      ),
    );
  }

  // Future<void> _goToTheLake() async {
  //   final GoogleMapController controller = await _controller.future;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  // }
}
