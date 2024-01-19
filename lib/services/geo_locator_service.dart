import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';

class GeoLocationService {
  bool? serviceEnabled;
  LocationPermission? permission;

  // returns true if app has location permission
  bool get hasPermission =>
      serviceEnabled == true &&
          (permission == LocationPermission.always ||
              permission == LocationPermission.whileInUse);

// check if the user already granted permissions to acquire the device's location
  checkPermission() async {
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    permission = await Geolocator.checkPermission();
  }

// request permission to access the device's location
  requestPermission() async {
    permission = await Geolocator.requestPermission();
  }

// open location settings on user's device's
  openLocationSettings() async {
    // open location settings for android
    await Geolocator.openLocationSettings();
  }

// open app settings on user's device's
  openAppSettings() async {
    // open app settings for android
    await Geolocator.openAppSettings();
  }

  /// returns the position of the device
  /// forceUserCurrentLocation = false would get Last Known positon
  /// forceUserCurrentLocation = true would return current positon. This is slower
  getCurrentPosition({
    bool forceUseCurrentLocation = true,
    bool asPosition = true,
  }) async {
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled!) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      Fluttertoast.showToast(
          fontSize: 18,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.red.withOpacity(0.7),
          msg: 'Location service disable. Please enable',
          gravity: ToastGravity.BOTTOM,
          textColor: Colors.white);
      return null;
    }
    await checkPermission();
    if (permission == LocationPermission.denied) {
      await requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        Fluttertoast.showToast(
            fontSize: 18,
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.red.withOpacity(0.7),
            msg: 'Location permission denied',
            gravity: ToastGravity.BOTTOM,
            textColor: Colors.white);
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      // await Geolocator.openAppSettings();
      Fluttertoast.showToast(
          fontSize: 18,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.red.withOpacity(0.7),
          msg: 'location permission denied',
          gravity: ToastGravity.BOTTOM,
          textColor: Colors.white);
      await Geolocator.openLocationSettings();
      return null;
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position? position;

    if (forceUseCurrentLocation) {
      position = await Geolocator.getCurrentPosition();
    } else {
      position = await Geolocator.getLastKnownPosition();
      position ??= await Geolocator.getCurrentPosition();
    }
    if (asPosition) {
      return position;
    }
    return [position.latitude, position.longitude];
  }

  /// listens to locations. fired whenever there is a change
  Stream<Position> getPositionStream() {
    return Geolocator.getPositionStream();
  }

  //calculate driver distance
  double degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }

  Future<double> calculateDistance(
      double startLatitude,
      double startLongitude,
      double endLatitude,
      double endLongitude,
      ) async {
    const int earthRadius = 6371; // Radius of the Earth in kilometers
    double lat1 = degreesToRadians(
        startLatitude); // Using the radians method from math library
    double lon1 = degreesToRadians(
        startLongitude); // Using the radians method from math library
    double lat2 = degreesToRadians(
        endLatitude); // Using the radians method from math library
    double lon2 = degreesToRadians(
        endLongitude); // Using the radians method from math library

    double dlat = lat2 - lat1;
    double dlon = lon2 - lon1;

    double a =
        pow(sin(dlat / 2), 2) + cos(lat1) * cos(lat2) * pow(sin(dlon / 2), 2);
    double c = 2 * asin(sqrt(a));

    double distance = earthRadius * c;
    return distance; // Distance in kilometers
  }
}
