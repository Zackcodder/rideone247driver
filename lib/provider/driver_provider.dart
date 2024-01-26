

import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ride_on_driver/services/driver_services.dart';

import '../services/geo_locator_service.dart';
import '../services/socket_service.dart';
import 'authprovider.dart';

class DriverProvider with ChangeNotifier{
  final SocketService _socketService = SocketService();
  final DriverService _driverService = DriverService();
  final GeoLocationService _geoLocationService = GeoLocationService();


  DriverProvider(String id) {
    _socketService.initSocket(id);
    // Initialize the socket service and listen for ride requests
    // _socketService.listenForRideRequest((data) {
    //   // Handle the incoming ride request data
    //   print('Ride Request Received: $data');
    // });
    _socketService.socket.on("DRIVER_LOCATION_UPDATED", (data) {
      print('res from updating driver location $data');
    });
    listenForDriverLocationUpdates();
  }

  ///update driver location
  updateLocation(
        {required String id,
          required BuildContext context,
        required String role,
        required String lat,
        required String lon}) async {

    String? id = Provider.of<AuthProvider>(context, listen: false).id;
    final position = await _geoLocationService.getCurrentPosition(asPosition: false);
    _socketService.socket.emit("UPDATE_LOCATION", {
        'id': id,
        'role': 'DRIVER',
      lat: position[0].toString(),
      lon: position[1].toString(),
      });
    }

  // Listen for driver location updates via socket
  listenForDriverLocationUpdates() {
    _driverService.startLocationUpdates();
    _socketService.driverLocationUpdate();
    _socketService.listenForSuccess();
  }

}