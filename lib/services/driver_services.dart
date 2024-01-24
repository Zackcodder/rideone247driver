import 'dart:async';
import 'package:http/http.dart' as http;
import 'geo_locator_service.dart';
import 'dart:convert' as convert;
import 'dart:convert';
import 'socket_service.dart'; // Import the SocketService class

class DriverService {
  final GeoLocationService _geoLocationService = GeoLocationService();
  final String baseUrl =
      'https://rideon247endpoints-uqexm.ondigitalocean.app';

  // Initialize the SocketService
  final SocketService _socketService = SocketService();

  // Update driver location
  updateDriverLiveStatus(bool online) async {
    final position = await _geoLocationService.getCurrentPosition(asPosition: false);

    String status = online ? 'online' : 'offline';
    final response = await http.get(Uri.parse(
        '$baseUrl?updatedriverstatus=$status&CurrentLongitude=${position[1]}&CurrentLatitude=${position[0]}'));
  }

  // Define a Timer variable to schedule the periodic updates.
  Timer? locationUpdateTimer;
  bool online = true;

  // Call this method to start updating the driver's location periodically.
  void startLocationUpdates() {
    // Start a repeating timer that calls the updateLocation method every 5 seconds.
    locationUpdateTimer =
        Timer.periodic(const Duration(seconds: 180), (timer) {
          updateDriverLiveStatus(online);
          updateLocation(); // Call the method to send location updates via socket
        });
  }

  // Call this method to stop the periodic location updates.
  void stopLocationUpdates() {
    locationUpdateTimer?.cancel();
  }

  // Update location using socket
  void updateLocation() async {
    final position = await _geoLocationService.getCurrentPosition(asPosition: false);
    _socketService.updateLocation(
      id: '12338447', // Provide the driver ID
      role: 'driver',
      lat: position[0].toString(),
      lon: position[1].toString(),
    );
  }

  // Listen for driver location updates via socket
  void listenForDriverLocationUpdates() {
    _socketService.driverLocationUpdate();
  }
}
