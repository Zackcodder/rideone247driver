
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  final String baseUrl = 'https://rideon247endpoints-uqexm.ondigitalocean.app';
  static final SocketService _singleton = SocketService._internal();
  String? userToken;

  late IO.Socket socket;

  factory SocketService() {
    return _singleton;
  }

  SocketService._internal();

  void initSocket(String userToken) {
    print('starting socket class');
    try {
      socket = IO.io('$baseUrl?token=$userToken', <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      });

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

  void authenticate() {
    print('auth in socket');
    socket.emit("AUTH", {'token': 'Bearer $userToken'});
    print('socket working with toke $userToken');
  }

  void updateLocation({
    required String id,
    required String role,
    required String lat,
    required String lon,
  }) {
    socket.emit("UPDATE_LOCATION", {
      'id': id,
      'role': role,
      'lat': lat,
      'lon': lon,
    });
  }

  void acceptRide({
    required String id,
    required String lon,
    required String lat,
    required String tripId
  }) {
    socket.emit("REQUEST_ACCEPTED", {
      'id': id,
      'lon': lon,
      'lat': lat,
      'tripId': tripId,
    });
  }

  void startTrip({
    required String id,
    required String tripId
  }) {
    socket.emit("START_TRIP", {
      'id': id,
      'tripId': tripId,
    });
  }

  void endTrip({
    required String id,
    required String tripId
  }) {
    socket.emit("END_TRIP", {
      'id': id,
      'tripId': tripId,
    });
  }

  void listenForErrors() {
    socket.on("ERROR", (data) {
      print(data);
      // Handle errors as needed
    });
  }

  void listenForSuccess() {
    socket.on("SUCCESS", (data) {
      print(data);
      // Handle success as needed
    });
  }

  void listenForRideRequest() {
    socket.on("RIDE_REQUEST", (data) {
      print(data);
      // Handle ride requests as needed
    });
  }

  void listenForTripEnd() {
    socket.on("TRIP_ENDED", (data) {
      print(data);
      // Handle trip completion as needed
    });
  }
}