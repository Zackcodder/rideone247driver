import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';

class GeoLocatorService with ChangeNotifier {
  // double _latitude;
  // double _longitude;

  // double get latitude => _latitude ?? 0.0;
  // double get longitude => _longitude ?? 0.0;

  // GeoLocatorService() {
  //   _latitude = 0.0;
  //   _longitude = 0.0;
  //   _getCurrentLocation();
  // }

  // Future<void> _getCurrentLocation() async {
  //   try {
  //     Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high,
  //     );

  //     _latitude = position.latitude;
  //     _longitude = position.longitude;
  //     notifyListeners();
  //   } catch (e) {
  //     print("Error getting location: $e");
  //   }
  // }

  // permission setting
  bool? serviceEnabled;
  LocationPermission? permission;

  bool get hasPermission =>
      serviceEnabled == true &&
      (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse);

  Future<void> checkPermission() async {
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    permission = await Geolocator.checkPermission();
  }

  Future<void> requestPermission() async {
    permission = await Geolocator.requestPermission();
  }

  Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
  }

  Future<Object?> getCurrentPosition({
    bool forceUseCurrentLocation = true,
    bool asPosition = true,
  }) async {
    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled!) {
        Fluttertoast.showToast(
          fontSize: 18,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.red.withOpacity(0.7),
          msg: 'Location service disabled. Please enable it.',
          gravity: ToastGravity.BOTTOM,
          textColor: Colors.white,
        );
        return null;
      }

      await checkPermission();
      if (permission == LocationPermission.denied) {
        await requestPermission();
        if (permission == LocationPermission.denied) {
          Fluttertoast.showToast(
            fontSize: 18,
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.red.withOpacity(0.7),
            msg: 'Location permission denied.',
            gravity: ToastGravity.BOTTOM,
            textColor: Colors.white,
          );
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Fluttertoast.showToast(
          fontSize: 18,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.red.withOpacity(0.7),
          msg: 'Location permission denied.',
          gravity: ToastGravity.BOTTOM,
          textColor: Colors.white,
        );
        await openLocationSettings();
        return null;
      }

      Position? position;
      if (forceUseCurrentLocation) {
        position = await Geolocator.getCurrentPosition();
      } else {
        position = await Geolocator.getLastKnownPosition();
        position ??= await Geolocator.getCurrentPosition();
      }
      return asPosition ? position : [position.latitude, position.longitude];
    } catch (e) {
      print("Error getting location: $e");
      return null;
    }
  }

  Stream<Position> getPositionStream() {
    return Geolocator.getPositionStream();
  }
  // You can add other methods here for handling location-related functionalities
}
