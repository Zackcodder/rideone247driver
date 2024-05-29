import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PolylinePointService {
  List<LatLng> decodePolyPoints(String encodedPoints) {
    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPoints = polylinePoints.decodePolyline(encodedPoints);

    List<LatLng> polylineCoordinates = [];
    if (decodedPoints.isNotEmpty) {
      for (var point in decodedPoints) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }
    return polylineCoordinates;
  }

  // ///
  // List<LatLng> polylineCoordinates = [];
  // PolylinePoints polylinePoints = PolylinePoints();
  //
  // List<LatLng> decodePolyPoints(String encodedPoint) {
  //   List<PointLatLng> results = polylinePoints.decodePolyline(encodedPoint);
  //
  //   polylineCoordinates.clear();
  //   if (results.isNotEmpty) {
  //     for (var point in results) {
  //       polylineCoordinates.add(LatLng(point.latitude, point.longitude));
  //     }
  //   }
  //   return polylineCoordinates;
  // }

  ///
}
