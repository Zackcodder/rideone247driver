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

  RideRequestProvider(String token, String id) {
    listenForRideRequests();
    acceptRideRequestResponse();
    _socketService.initSocket(token, id);
  }

  List<Trip> _rideRequests = [];
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
  String? get driverId => _driverId;
  String? _driverId;
  String? get paymentMethod => _paymentMethod;
  String? _paymentMethod;

  listenForRideRequests() async {
    print('starting another wahala ');

      try {
        /// Listen for ride requests and handle them
        Trip? newRequest = await _socketService.listenForRideRequest();

        if (newRequest != null) {
          // Handle the ride request data, for example, add it to a list
          _rideRequests.add(newRequest);
          _tripId = newRequest.tripId;
          _tripLat = newRequest.dropOffLon.toString();
          _tripLng = newRequest.pickUpLat.toString();
          _driverId = newRequest.driverId;
          _paymentMethod = newRequest.paymentMethod;
          print('this is a trip lat: ${newRequest.dropOffLon}');
          print('this is a trip lng: ${newRequest.pickUpLat}');
          print('this is a trip id: ${newRequest.tripId}');
          print('this is a driver id: ${newRequest.driverId}');
          print('this is a trip payment method: ${newRequest.paymentMethod}');

          // Notify listeners that the ride requests list has been updated
          notifyListeners();
        }
      } catch (e) {
        // Handle any errors
        print('Error processing ride request data: $e');
      }
  }

  ///accept rider request

  List<Trip> _rideAcceptedRequests = [];
  List<Trip> get rideAcceptedRequests => _rideAcceptedRequests;
  String? get acceptedTripId => _acceptedTripId;
  String? _acceptedTripId;
  String? get riderPaymentMethod => _riderPaymentMethod;
  String? _riderPaymentMethod;
  String? get riderName => _riderName;
  String? _riderName;
  double? get riderPickUpLat => _riderPickUpLat;
  double? _riderPickUpLat;
  double? get riderPickUpLon => _riderPickUpLon;
  double? _riderPickUpLon;
  double? get riderDestinationLat => _riderDestinationLat;
  double? _riderDestinationLat;
  double? get riderDestinationLon => _riderDestinationLon;
  double? _riderDestinationLon;

  acceptRideRequest(String id, String lon, String lat, String tripId) async{
    print('starting accetp trip in provider');
    _socketService.acceptRide(id: id, lon: lon, lat: lat, tripId: tripId);
    // acceptRideRequestResponse();
    // _socketService.listenForError();
    notifyListeners();
  }

  acceptRideRequestResponse() async{
    print('printing accept response in provider');
    try {
      /// Listen for ride acceptance and handle them
      Trip? newAcceptedRequest = await _socketService.acceptRideRespond();

      if (newAcceptedRequest != null) {
        // Handle the ride request data, for example, add it to a list
        _rideAcceptedRequests.add(newAcceptedRequest);
        _riderName = newAcceptedRequest.riderName;
        _acceptedTripId = newAcceptedRequest.riderTripId;
        _riderPaymentMethod = newAcceptedRequest.riderPaymentMethod;
        _riderPickUpLat = newAcceptedRequest.riderPickupLat;
        _riderPickUpLon = newAcceptedRequest.riderPickupLon;
        _riderDestinationLat = newAcceptedRequest.riderDropOffLat;
        _riderDestinationLon = newAcceptedRequest.riderDropOffLon;
        // Notify listeners that the ride requests list has been updated
        notifyListeners();

        print('this is a rider name: ${newAcceptedRequest.riderName}');
        print('this is a trip lng: ${newAcceptedRequest.riderPickupLon}');
        print('this is a rider trip id: ${newAcceptedRequest.riderTripId}');
        print('this is a rider payment method: ${newAcceptedRequest.riderPaymentMethod}');

      }
    } catch (e) {
      // Handle any errors
      print('Error processing ride request data: $e');
    }
  }

  ///start trip
  startRide( String id,  String tripId) async{
    print('starting ride in provider');
    _socketService.startTrip(id: id, tripId: tripId);
    print('starting ride respoinse in provider');
    _socketService.listenForSuccess();
    _socketService.listenForError();
    notifyListeners();
  }

  endRiderTrip(String id,  String tripId) async{
    print('ending trip from provider');
    _socketService.endTrip(id: id, tripId: tripId);
    print('printing the success response for end trip in provider');
    _socketService.listenForTripEnd();
    print('printing the error response for end trip in provider');
    _socketService.listenForError();
    notifyListeners();
  }

  resetApp() async{
    _riderName = '';
    _acceptedTripId = '';
    _riderPaymentMethod = '';
    _riderPickUpLat =0.0;
    _riderPickUpLon = 0.0;
    _riderDestinationLat = 0.0;
    _riderDestinationLon = 0.0;
    _tripId = '';
    _tripLat = '';
    _tripLng ='';
    _driverId = '';
    _paymentMethod = '';
    _rideRequests = [];
    _rideAcceptedRequests = [];
    notifyListeners();
  }

}
