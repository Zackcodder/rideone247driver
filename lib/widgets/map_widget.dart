import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ride_on_driver/services/geo_locator_service.dart';
import 'package:ride_on_driver/services/google_map_service.dart';

import '../provider/map_provider.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  State<MapWidget> createState() => MapWidgetState();
}

class MapWidgetState extends State<MapWidget> {
  late GoogleMapController mapController;
  final Completer<GoogleMapController> _controller = Completer();
  // PolylinePoints _polylinePoints = PolylinePoints();

  // List<LatLng> polylineCoordinates = [];
  //
  // Map<PolylineId, Polyline> polyLines = {};
  //
  // late MapView _mapViewProvider;

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
        initialCameraPosition: GoogleMapService.googlePlex,
        onMapCreated: (GoogleMapController controller) async {
          _controller.complete(controller);
          mapController = controller;
          final position = await mapProvider.currentPosition;
          mapController.animateCamera(CameraUpdate.newLatLng(
              mapProvider.convertPositionToLatLng(position)));
        },
      ),
    );
  }

}
