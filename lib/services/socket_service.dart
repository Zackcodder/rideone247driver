import 'package:ride_on_driver/provider/authprovider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  final String baseUrl = 'https://rideon247endpoints-uqexm.ondigitalocean.app';
  static final SocketService _singleton = SocketService._internal();

  String? _token;
  String? _id;
  late IO.Socket socket;

  factory SocketService() {
    return _singleton;
  }

  SocketService._internal();

  void initSocket(String _token, String _id) {
    print('starting socket class');
    try {
      socket = IO.io(baseUrl, <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
        'query': 'token=$_token',
      });
      print('this is the token gotten: $_token');

      socket.connect();
      print('socket working');
    } catch (e) {
      print("Error initializing socket: $e");
      // Handle the error appropriately (e.g., show a message to the user)
    }
  }

  void disconnectSocket() {
    socket.disconnect();
  }

  authenticate() {
    print('auth in socket');
    socket.emit("AUTH", {'token': 'Bearer $_token'});
    print('socket working with toke $_token');
  }

  updateLocation(
      {required String id,
      required String role,
      required String lat,
      required String lon}) {
    socket.emit("UPDATE_LOCATION", {
      'id': id,
      'role': role,
      'lat': lat,
      'lon': lon,
    });
  }

  acceptRide(
      {required String id,
      required String lon,
      required String lat,
      required String tripId}) {
    socket.emit("REQUEST_ACCEPTED", {
      'id': id,
      'lon': lon,
      'lat': lat,
      'tripId': tripId,
    });
  }

  startTrip({required String id, required String tripId}) {
    socket.emit("START_TRIP", {
      'id': id,
      'tripId': tripId,
    });
  }

  endTrip({required String id, required String tripId}) {
    socket.emit("END_TRIP", {
      'id': id,
      'tripId': tripId,
    });
  }

  listenForSuccess() {
    print("listening for success");
    socket.on("SUCCESS", (data) {
      print(data);
      // print("sucess getting trip data: $data");
      // Handle success as needed
    });
  }

  ///Driver location update
  driverLocationUpdate() {
    socket.on("DRIVER_LOCATION_UPDATED", (data) {
      print(data);
    });
  }

  ///update driver availability
  driverOnlineStatus({required String id, required bool availability}) {
    socket.emit(
      "UPDATE_AVAILABILITY",
      {'id': id, 'availability': availability},
    );
    print('printing from socket $id');
    print('printing from status socket $availability');
    listenForSuccess();
  }

  ///listen for ride request
  listenForRideRequest() {
    print('listneing for trip request');
    socket.on("RIDE_REQUEST", (data) {
      print('Received Ride Request: $data');
    });
  }
  // listenForRideRequest( Function(dynamic) callback) {
  //   print('listneing for trip request');
  //   socket.on("RIDE_REQUEST", (data) {
  //     print('Received Ride Request: $data');
  //     // Call the provided callback with the received data
  //     callback(data);
  //   });
  // }

  void listenForTripEnd() {
    socket.on("TRIP_ENDED", (data) {
      print(data);
      // Handle trip completion as needed
    });
  }

  listenForError() {
    socket.on("ERROR", (data) {
      print("Error getting trip data: $data");
    });
  }
}
