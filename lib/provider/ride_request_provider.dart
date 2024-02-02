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
  //driver trip
  Timer? checkForRideRequestTimer;
  listenForRideRequests() async {
    print('staring another wahala ');
    checkForRideRequestTimer =
        Timer.periodic(const Duration(seconds: 5), (timer) async{
      print('staring another wahala haha haha ha');

      /// Listen for ride requests and handle them
      // _socketService.listenForRideRequest();

      /// Listen for ride requests and handle them
      final data = await _socketService.listenForRideRequest();

      if (data != null) {
        // Handle the ride request data, for example, add it to a list
        Trip newRequest = Trip.fromJson(data);
        _rideRequests.add(newRequest);

        // Notify listeners that the ride requests list has been updated
        notifyListeners();
      }
        });
    // notifyListeners();
  }

  ///updating driver online status
  updateDriverStatus(BuildContext context,String id, bool availability) async {
    _socketService.driverOnlineStatus(
      id: id,
      availability: availability,
    );
    print('this is the status $availability');
    print('this is the id $id');
    _socketService.listenForSuccess();
  }
  // updateDriverStatus(BuildContext context,String id, bool availability) async {
  //   String? id = Provider.of<AuthProvider>(context, listen: false).id;
  //   _socketService.driverOnlineStatus(
  //     id:  id!,
  //     availability: true,
  //   );
  //   print('this is the status $availability');
  //   print('this is the id $id');
  // }
}
