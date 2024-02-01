import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../provider/authprovider.dart';
import 'geo_locator_service.dart';
import 'dart:convert' as convert;
import 'socket_service.dart'; // Import the SocketService class

class DriverService {
  final GeoLocationService _geoLocationService = GeoLocationService();
  final SocketService _socketService = SocketService();
  final String baseUrl = 'https://rideon247endpoints-uqexm.ondigitalocean.app';
  updateDriverLiveStatus(bool online) async {
    final position = await _geoLocationService.getCurrentPosition(asPosition: false);

    String status = online ? 'online' : 'offline';
    final response = await http.get(Uri.parse(
        '$baseUrl?updatedriverstatus=$status&CurrentLongitude=${position[1]}&CurrentLatitude=${position[0]}'));
  }

  /// Define a Timer variable to schedule the periodic updates.
  Timer? locationUpdateTimer;
  bool online = true;
  String? id;

  /// Call this method to start updating the driver's location periodically.
   startLocationUpdates() {
    /// Start a repeating timer that calls the updateLocation method every 5 seconds.
    locationUpdateTimer =
        Timer.periodic(const Duration(seconds: 60), (timer) {
          updateDriverLiveStatus(online);
          updateLocation();
          _socketService.driverLocationUpdate();

          // _socketService.driverLocationUpdate();/// Call the method to send location updates via socket
        });
  }

  /// Call this method to stop the periodic location updates.
  void stopLocationUpdates() {
    locationUpdateTimer?.cancel();
  }

  /// Update location using socket
   updateLocation() async {
     // print('starting oooo');

     // String? id = Provider.of<AuthProvider>(context, listen: false).id;
    final position = await _geoLocationService.getCurrentPosition(asPosition: false);
    _socketService.updateLocation(
      id:
      //id!,
      // driverId,
      '65aa5dbab2e8f20021fcac83', // Provide the driver ID
      role: 'DRIVER',
      lat: position[0].toString(),
      lon: position[1].toString(),
    );
     // print('ID: $id');
     // print('Latitude: ${position[0]}');
     // print('Longitude: ${position[1]}');
     _socketService.driverLocationUpdate();

  }


}
