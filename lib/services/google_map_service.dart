import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapService with ChangeNotifier {
  GoogleMapController? mapController;
  Set<Marker> markers = {};
  Set<Circle> circles = {};
  LatLng initialCameraPosition = LatLng(0.0, 0.0);

  GoogleMapService() {
    // Default to a specific location if the initial position is not available yet
    _updateInitialCameraPosition();
  }

  // on map create for all needed feature
  onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    // You can perform additional initialization here if needed

    // final position = await currentPosition;

    // mapController?.animateCamera(
    //     CameraUpdate.newLatLng(convertPositionToLatLng(position)));
  }

  //markers
  addMarker(LatLng position, String markerId, String title) {
    markers.add(
      Marker(
        markerId: MarkerId(markerId),
        position: position,
        infoWindow: InfoWindow(title: title),
      ),
    );
    notifyListeners();
  }

  //circle
  addCircle(LatLng center, double radius, String circleId) {
    circles.add(
      Circle(
        circleId: CircleId(circleId),
        center: center,
        radius: radius,
        fillColor: Colors.blue.withOpacity(0.2),
        strokeColor: Colors.blue,
        strokeWidth: 2,
      ),
    );
    notifyListeners();
  }

  Future<void> _updateInitialCameraPosition() async {
    try {
      final position = await Geolocator.getCurrentPosition();
      // ignore: unnecessary_null_comparison
      if (position != null) {
        initialCameraPosition = LatLng(position.latitude, position.longitude);
        notifyListeners();
      }
    } catch (e) {
      print("Error getting current position: $e");
    }
  }

  CameraPosition getInitialCameraPosition(double zoom) {
    return CameraPosition(
      target: initialCameraPosition,
      zoom: zoom,
    );
  }

  // Add other methods as needed for your Google Map functionality
}
