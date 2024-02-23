

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PolylinePointService{
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  List<LatLng> decodePolyPoints(String encodedPoint) {
    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> results = polylinePoints.decodePolyline(encodedPoint);

    polylineCoordinates.clear();
    if(results.isNotEmpty){
      for(var points in results){
        polylineCoordinates.add(LatLng(points.latitude, points.longitude),
        );
      }
    }
    return polylineCoordinates;
  }
}