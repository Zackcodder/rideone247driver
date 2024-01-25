

import 'package:flutter/cupertino.dart';
import 'package:ride_on_driver/services/driver_services.dart';

import '../services/socket_service.dart';

class DriverProvider with ChangeNotifier{
  final SocketService _socketService = SocketService();
  final DriverService _driverService = DriverService();

  DriverProvider(String token) {
    // Initialize the socket service and listen for ride requests
    _socketService.initSocket(token);
    _socketService.listenForRideRequest((data) {
      // Handle the incoming ride request data
      print('Ride Request Received: $data');
    });
    listenForDriverLocationUpdates();
  }

  // Listen for driver location updates via socket
  listenForDriverLocationUpdates() {
    _driverService.startLocationUpdates();
    _socketService.driverLocationUpdate();
  }

}