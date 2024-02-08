

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


  DriverProvider( String token, String id) {
    _socketService.initSocket(id, token);
    _socketService.socket.on("DRIVER_LOCATION_UPDATED", (data) {
      print('res from updating driver location $data');
    });
    listenForDriverLocationUpdates();
    notifyListeners();
  }

  ///update driver location
  updateLocation(
        {required String id, required String role, required String lat, required String lon}) async {
    final position = await _geoLocationService.getCurrentPosition(asPosition: false);
    _socketService.socket.emit("UPDATE_LOCATION", {
        'id': id,
        'role': 'DRIVER',
      lat: position[0].toString(),
      lon: position[1].toString(),
      });
    print('this is the driver location update in the provider $id');
    print('this is the driver location update in the provider $lon');
    notifyListeners();
    }

  /// Listen for driver location updates via socket
  listenForDriverLocationUpdates() {
    _driverService.startLocationUpdates();
  }

}