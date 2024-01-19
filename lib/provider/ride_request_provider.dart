import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../model/trip.dart';

class RideRequestProvider with ChangeNotifier {
  bool _rideRequestLoading = false;
  bool get rideRequestLoading => _rideRequestLoading;
  final String baseUrl = 'https://rideon247endpoints-uqexm.ondigitalocean.app';
  late IO.Socket socket;

  List<Trip> _rideRequests = [];

  RideRequestProvider() {
    initSocket();
    listenForRideRequests();
  }

  List<Trip> get rideRequests => _rideRequests;
  bool get hasRideRequests => _rideRequests.isNotEmpty;

  void initSocket() {
    socket = IO.io("$baseUrl", <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.onConnect((_) {
      print('Driver Socket connected');
    });

    socket.connect();
  }

  void listenForRideRequests() {
    _rideRequestLoading = true;
    socket.on("RIDE_REQUEST", (data) {
      print('Received Ride Request: $data');



      // Convert data to a Trip object and add it to the list
      // Trip newRequest = Trip.fromJson(data);
      // _rideRequests.add(newRequest);

      // Notify listeners that the ride requests list has been updated
      notifyListeners();
      _rideRequestLoading = false;
    });
  }

  void acceptRide(String driverId, String tripId) {
    socket.emit("REQUEST_ACCEPTED", {
      'id': driverId,
      'lon': "driver_longitude",
      'lat': "driver_latitude",
      'tripId': tripId,
    });
  }

  void startTrip(String driverId, String tripId) {
    socket.emit("START_TRIP", {
      'id': driverId,
      'tripId': tripId,
    });
  }

  void endTrip(String driverId, String tripId) {
    socket.emit("END_TRIP", {
      'id': driverId,
      'tripId': tripId,
    });
  }

  void listenForTripEnd() {
    socket.on("TRIP_ENDED", (data) {
      print('Trip Ended: $data');

      // Add logic to handle the end of the trip
    });
  }
}
