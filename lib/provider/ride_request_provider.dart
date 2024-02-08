import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../model/trip.dart';
import '../services/socket_service.dart';
import 'authprovider.dart';

class RideRequestProvider with ChangeNotifier {
  bool _rideRequestLoading = false;
  bool get rideRequestLoading => _rideRequestLoading;

  final SocketService _socketService = SocketService();
  List<Trip> _rideRequests = [];

  RideRequestProvider(String token, String id) {
    listenForRideRequests();
    _socketService.initSocket(token, id);
  }

  List<Trip> get rideRequests => _rideRequests;
  bool get hasRideRequests => _rideRequests.isNotEmpty;

  ///updating driver online status
  updateDriverStatus(BuildContext context,String id, bool availability) async {
    _socketService.driverOnlineStatus(
      id: id,
      availability: availability,
    );
    print('this is the status $availability');
    print('this is the id $id');
    _socketService.listenForSuccess();
    notifyListeners();
  }

  /// trip request
  Timer? checkForRideRequestTimer;

  String? get tripId => _tripId;
  String? _tripId;
  String? get tripLat => _tripLat;
  String? _tripLat;
  String? get tripLng => _tripLng;
  String? _tripLng;
  String? get driverTripId => _driverTripId;
  String? _driverTripId;

  listenForRideRequests() async {
    print('starting another wahala ');

    checkForRideRequestTimer = Timer.periodic(const Duration(seconds: 55), (timer) async {
      print('starting another wahala haha haha ha');

      try {
        // Listen for ride requests and handle them
        Trip? newRequest = await _socketService.listenForRideRequest();

        if (newRequest != null) {
          // Handle the ride request data, for example, add it to a list
          _rideRequests.add(newRequest);
          _tripId = newRequest.id;
          _tripLat = newRequest.dropOffLon.toString();
          _tripLng = newRequest.pickUpLat.toString();
          _driverTripId = newRequest.driverId;
          print('this is a trip lat: ${newRequest.dropOffLon}');
          print('this is a trip lng: ${newRequest.pickUpLat}');
          print('this is a trip id: ${newRequest.id}');
          print('this is a trip driver: ${newRequest.driverId}');

          // Notify listeners that the ride requests list has been updated
          notifyListeners();
        }
      } catch (e) {
        // Handle any errors
        print('Error processing ride request data: $e');
      }
    });
  }

  ///accept rider request
  acceptRideRequest(String id, String lon, String lat, String tripId) async{
    print('starting accetp trip in provider');
    _socketService.acceptRide(id: id, lon: lon, lat: lat, tripId: tripId);
    print('printing accet response in provider');
    _socketService.listenForSuccess();
    notifyListeners();
  }

  ///start trip
  startRide( String id,  String tripId) async{
    print('starting ride in provider');
    _socketService.startTrip(id: id, tripId: tripId);
    print('starting ride respoinse in provider');
    _socketService.listenForSuccess();
    notifyListeners();
  }

}
