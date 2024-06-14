import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../services/geo_locator_service.dart';
import '../services/google_map_service.dart';

class MapView extends ChangeNotifier {
  final GoogleMapService _googleMapService = GoogleMapService();
  final GeoLocationService _geoLocationService = GeoLocationService();
  // final RideRequestProvider _rideRequestProvider = RideRequestProvider(String as String token, String id);

  dynamic _currentPosition;
  get currentPosition async =>
      _currentPosition ??= await _geoLocationService.getCurrentPosition();

  convertPositionToLatLng(position) =>
      _googleMapService.convertPositionToLatLng(position);
  get circle => _googleMapService.mainPageCircles(_currentPosition);
  get marker => _googleMapService.markers;
  // ValueNotifier<Map<PolylineId, Polyline>> get polyline => GoogleMapService.polyLines;
  get polyline => _googleMapService.polyLines;
  LatLngBounds? get bounds => _googleMapService.bounds;
  /// user marker
  Future<void> updateDriverLocationMarker() async {
    await _googleMapService.updateDriverLocationMarker();
    notifyListeners();
  }

  void startLocationUpdates() {
    Timer.periodic(const Duration(seconds: 5), (timer) async {
      await updateDriverLocationMarker();
    });
  }

  @override
  notifyListeners();
}
