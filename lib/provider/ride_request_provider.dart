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
    listenForRideRequests();
    _socketService.initSocket(token);
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
          _socketService.listenForRideRequest();
          // _socketService.listenForRideRequest((data) {
          //   // Handle the ride request data within RideRequestProvider
          //   Trip newRequest = Trip.fromJson(data);
          //   _rideRequests.add(newRequest);
          //
          //   // Notify listeners that the ride requests list has been updated
          //   notifyListeners();
          //   _rideRequestLoading = false;
          // });
          // _socketService.listenForSuccess();

          /// Listen for socket errors
          // _socketService.listenForError();
          });
    // notifyListeners();
  }
}
