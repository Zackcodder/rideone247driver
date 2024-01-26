import 'dart:async';

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../model/trip.dart';
import '../services/socket_service.dart';

class RideRequestProvider with ChangeNotifier {
  bool _rideRequestLoading = false;
  bool get rideRequestLoading => _rideRequestLoading;

  final SocketService _socketService = SocketService();
  List<Trip> _rideRequests = [];

  RideRequestProvider(String token) {
    // Initialize the socket service and listen for ride requests
    _socketService.initSocket(token);
    // _socketService.listenForRideRequest((data) {
    //   // Handle the incoming ride request data
    //   print('Ride Request Received: $data');
    // });
    listenForRideRequests();
  }

  List<Trip> get rideRequests => _rideRequests;
  bool get hasRideRequests => _rideRequests.isNotEmpty;
  //driver trip
  Timer? checkForRideRequestTimer;
  listenForRideRequests() async{
    print('staring another whala ');
    checkForRideRequestTimer =
        Timer.periodic(const Duration(seconds: 5), (timer) {
          print('staring another whala hahahahaha');
          /// Listen for ride requests and handle them
          _socketService.listenForRideRequest((data) {
            Trip newRequest = Trip.fromJson(data);
            print('showing result of wahala $newRequest');
            _rideRequests.add(newRequest);

            /// Notify listeners that the ride requests list has been updated
            notifyListeners();
            _rideRequestLoading = false;
          });
          _socketService.listenForSuccess();

          /// Listen for socket errors
          _socketService.listenForError();
          });
  }
}
