// ignore_for_file: prefer_single_quotes

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../model/trip.dart';

class SocketService {
  final String baseUrl = 'https://rideon247-production.up.railway.app';
  static final SocketService _singleton = SocketService._internal();

  String? _token;
  // String? _id;
  late IO.Socket socket;

  factory SocketService() {
    return _singleton;
  }

  SocketService._internal();

  initSocket(String _token, String _id) {
    print('starting socket class');
    try {
      socket = IO.io(baseUrl, <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
        'query': 'token=$_token',
      });
      print('this is the token gotten: $_token');

      socket.connect();
      listenForRideRequest();
      acceptRideRespond();
      print('socket working');
    } catch (e) {
      print("Error initializing socket: $e");
      // Handle the error appropriately (e.g., show a message to the user)
    }
  }

  void disconnectSocket() {
    socket.disconnect();
    _acceptedRequestController.close();
    _rideRequestController.close();
  }

  authenticate() {
    print('auth in socket');
    socket.emit("AUTH", {'token': 'Bearer $_token'});
    print('socket working with toke $_token');

  }

  ///Driver location update
  updateLocation( {required String id,required String role, required String lat,required String lon}) {
    socket.emit("UPDATE_LOCATION", {
      'id': id,
      'role': role,
      'lat': lat,
      'lon': lon,
    }
    );
    print('this is from the driver socket location class');
    print('ID: $id');
    print('driver role in socket: $role');
    print('Latitude: $lat');
    print('Longitude: $lon');
    driverLocationUpdate();
  }

  ///Driver location update response
  driverLocationUpdate() {
    socket.on("DRIVER_LOCATION_UPDATED", (data) {
      print('this is the result from the driver location $data');
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
  // listenForRideRequest(){
  //   print('listening for trip request');
  //   socket.on("RIDE_REQUEST", (data) {
  //     print('trip request data $data');
  //   });
  // }
  ///

  StreamController<Trip> _rideRequestController = StreamController<Trip>.broadcast();

  Stream<Trip> get rideRequestStream => _rideRequestController.stream;

  void listenForRideRequest() {
    print('listening for trip request');
    socket.on("RIDE_REQUEST", (data) {
      print('Received Ride Request: $data');

      try {
        // Parse the JSON data into a Dart map
        Map<String, dynamic> rideRequest = json.decode(data);

        // Create a Trip object from the parsed data
        Trip newRequest = Trip.fromJson(rideRequest);

        // Add the new request to the stream
        _rideRequestController.add(newRequest);
      } catch (e) {
        // Handle any errors during parsing
        print('Error parsing ride request: $e');
      }
    });
  }

  ///

  acceptRide({required String id, required String lon, required String lat, required String tripId}) {
    print('starting accetp trip in socket');
    socket.emit("REQUEST_ACCEPTED", {
      'id': id,
      'lon': lon,
      'lat': lat,
      'tripId': tripId,
    });
    // print('printing  response in socket');
    // acceptRideRespond();
    // print('printing error response in socket');
    // listenForError();
  }
  ///accept trip request
  ///
  StreamController<Trip> _acceptedRequestController = StreamController<Trip>.broadcast();

  Stream<Trip> get acceptedRequestStream => _acceptedRequestController.stream;

  acceptRideRespond() {
    print('listening for accepted ride request');
    socket.on("ACCEPTED_REQUEST", (data) {
      print('Received Accepted Ride Request: $data');

      try {
        // Parse the JSON data into a Dart map
        Map<String, dynamic> acceptedRideRequest = json.decode(data);

        // Create a Trip object from the parsed data
        Trip newAcceptedRequest = Trip.fromJson(acceptedRideRequest);

        // Add the new accepted request to the stream
        _acceptedRequestController.add(newAcceptedRequest);
      } catch (e) {
        // Handle any errors during parsing
        print('Error parsing accepted ride request: $e');
      }
    });
  }

  ///
  // Future<Trip?> acceptRideRespond() async {
  //   print('Printing the acceptance response from the socket');
  //   Completer<Trip?> completer1 = Completer<Trip?>();
  //   socket.on("ACCEPTED_REQUEST", (data) {
  //     print('result from acceptance');
  //     print(data);
  //     try {
  //       /// Parse the JSON data into a Dart map
  //       Map<String, dynamic> acceptedRideRequest = json.decode(data);
  //
  //       /// Create a Trip object from the parsed data
  //       Trip newAcceptedRideRequest = Trip.fromJson(acceptedRideRequest);
  //
  //       /// Complete the Future with the Trip object
  //       completer1.complete(newAcceptedRideRequest);
  //     } catch (e) {
  //       /// Handle any errors during parsing
  //       completer1.completeError(e);
  //     }
  //   });
  //
  //   return completer1.future;
  // }

  startTrip({required String id, required String tripId}) {
    print('starting trip in socket');
    socket.emit("START_TRIP", {
      'id': id,
      'tripId': tripId,
    });
    print('response of started trip in socket');
    listenForSuccess();
  }

  endTrip({required String id, required String tripId}) {
    print('sending ending trip in socket');
    socket.emit("END_TRIP", {
      'id': id,
      'tripId': tripId,
    });
    listenForTripEnd();
  }

  listenForTripEnd() {
    socket.on("TRIP_ENDED", (data) {
      print('printing ending trip in socket');
      print(data);
      // Handle trip completion as needed
    });
  }

  ///listen for success
  listenForSuccess(){
    print("listening for success in socket");
    socket.on("SUCCESS", (data) {
      print("success data fromm socket: $data");
    });
  }

  listenForError() {
    socket.on("ERROR", (data) {
      print("Error getting trip data: $data");
    });
  }
}
