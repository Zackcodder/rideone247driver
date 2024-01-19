import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'geo_locator_service.dart';

class GoogleMapService{
final GeoLocationService _geoLocationService = GeoLocationService();
//getting camera position
CameraPosition? cameraPosition;
CameraUpdate get cameraUpdate {
  return CameraUpdate.newCameraPosition(cameraPosition!);
}

/// returns camera position based on passed latitude and longitude
// CameraPosition cameraPos(LatLng pos) => CameraPosition(target: pos, zoom: 18);

LatLngBounds? bounds;
setBounds(LatLng southwest, LatLng northeast) =>
    bounds = LatLngBounds(southwest: southwest, northeast: northeast);

Future<LatLng?> get currentLocationLatLng async {
  final position = await _geoLocationService.getCurrentPosition();
  if (position != null) {
    return LatLng(position.latitude, position.longitude);
  }
  return null;
}

CameraUpdate get latlngBoundsUpdate =>
    CameraUpdate.newLatLngBounds(bounds!, 90);

static CameraPosition googlePlex =
const CameraPosition(target: LatLng(6.5244, 3.3792), zoom: 16);

convertPositionToLatLng(Position position) =>
    LatLng(position.latitude, position.longitude);

// for circles
final Set<Circle> _circles = <Circle>{};
addCircle(Circle circles) => _circles.add(circles);
clearCircles() => _circles.clear();
Set<Circle> mainPageCircles(Position? pos) => pos == null
    ? {}
    : {
  Circle(
      circleId: const CircleId('Current'),
      strokeColor: Colors.blue.withOpacity(0.2),
      strokeWidth: 1,
      radius: 150,
      center: convertPositionToLatLng(pos),
      fillColor: Colors.blue.withOpacity(0.2))
};

// for markers
Set<Marker> _markers = <Marker>{};
Set<Marker> get markers => _markers;
clearMarkers() => _markers.clear();
static const Marker userMarker = Marker(
  markerId: MarkerId('Rider'),
  infoWindow: InfoWindow(title: 'Rider'),
  icon: BitmapDescriptor.defaultMarker,
  position: LatLng(37.43296265331129, -122.08832357078792),
);

///for polylines
// static final PolylinePoints _polylinePoints = PolylinePoints();
// static final ValueNotifier<Map<PolylineId, Polyline>> _polyLines =
// ValueNotifier({});
// static ValueNotifier<Map<PolylineId, Polyline>> get polyLines => _polyLines;
// static createPolyLine(String polylineId, PointLatLng pickupLocation,
//     PointLatLng destinationLocation) async {
//   PolylineId pId = PolylineId(polylineId);
//
//   Polyline polyLine = Polyline(
//     polylineId: pId,
//     color: Colors.orange,
//     points:
//     await _getRouteBetweenLocations(pickupLocation, destinationLocation),
//     jointType: JointType.round,
//     width: 3,
//     startCap: Cap.roundCap,
//     endCap: Cap.roundCap,
//     geodesic: true,
//   );
//   _polyLines.value = {};
//   _polyLines.value = {pId: polyLine};
// }
//
// clearPolyLines() => _polyLines.value.clear();
//
// static Future<List<LatLng>> _getRouteBetweenLocations(
// PointLatLng pickupLocation, PointLatLng destinationLocation) async {
// PolylineResult result = await _polylinePoints.getRouteBetweenCoordinates(
// LocationService.mapKey,
// pickupLocation,
// destinationLocation,
// travelMode: TravelMode.driving,
// );
// List<LatLng> polylineCoordinates = [];
//
// if (result.points.isNotEmpty) {
// for (var point in result.points) {
// polylineCoordinates.add(LatLng(point.latitude, point.longitude));
// }
// }
// return polylineCoordinates;
// }
}
