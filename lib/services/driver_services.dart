import 'dart:async';
import 'package:http/http.dart' as http;
import 'geo_locator_service.dart';
import 'socket_service.dart';

class DriverService {
  final GeoLocationService _geoLocationService = GeoLocationService();
  final SocketService _socketService = SocketService();
  final String baseUrl = 'https://rideon247-production.up.railway.app';


  updateDriverLiveStatus() async {
    final position = await _geoLocationService.getCurrentPosition(asPosition: false);

    final response = await http.get(Uri.parse(
        '$baseUrl?CurrentLongitude=${position[1]}&CurrentLatitude=${position[0]}'));
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
          updateDriverLiveStatus();
          updateLocation();
        });
  }

  /// Call this method to stop the periodic location updates.
  void stopLocationUpdates() {
    locationUpdateTimer?.cancel();
  }

  /// Update location using socket
   updateLocation() async {
    final position = await _geoLocationService.getCurrentPosition(asPosition: false);

    // String? id = Provider.of<AuthProvider>(context, listen: false).id;
    // _socketService.socket.emit("UPDATE_LOCATION", {
    //   'id': id,
    //   'role': 'DRIVER',
    //   lat: position[0].toString(),
    //   lon: position[1].toString(),
    // });
    _socketService.updateLocation(
      id:
      //id!,
      '65aa5dbab2e8f20021fcac83', // Provide the driver ID
      role: 'DRIVER',
      lat: position[0].toString(),
      lon: position[1].toString(),
    );
     print('this is from the driver service class');
     print('Driver Id: $id');
     print('Latitude: ${position[0]}');
     print('Longitude: ${position[1]}');
     _socketService.driverLocationUpdate();

  }

  ///user rating



}
