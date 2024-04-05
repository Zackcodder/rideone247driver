// ignore_for_file: prefer_single_quotes

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../model/trip.dart';

class SocketService {
  final String baseUrl = 'https://rideon247endpoints-uqexm.ondigitalocean.app';
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
  Future<Trip?> listenForRideRequest() async {
    print('listening for trip request');
    Completer<Trip?> completer = Completer<Trip?>();
    socket.on("RIDE_REQUEST", (data) {
      print('Received Ride Request: $data');

      try {
        // Parse the JSON data into a Dart map
        Map<String, dynamic> rideRequest = json.decode(data);

        // Create a Trip object from the parsed data
        Trip newRequest = Trip.fromJson(rideRequest);

        // Complete the Future with the Trip object
        completer.complete(newRequest);
      } catch (e) {
        // Handle any errors during parsing
        completer.completeError(e);
      }
    });

    return completer.future;
  }

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

  Future<Trip?> acceptRideRespond() async {
    print('Printing the acceptance response from the socket');
    Completer<Trip?> completer1 = Completer<Trip?>();
    socket.on("ACCEPTED_REQUEST", (data) {
      print('result from acceptance');
      print(data);
      try {
        /// Parse the JSON data into a Dart map
        Map<String, dynamic> acceptedRideRequest = json.decode(data);

        /// Create a Trip object from the parsed data
        Trip newAcceptedRideRequest = Trip.fromJson(acceptedRideRequest);

        /// Complete the Future with the Trip object
        completer1.complete(newAcceptedRideRequest);
      } catch (e) {
        /// Handle any errors during parsing
        completer1.completeError(e);
      }
    });

    return completer1.future;
  }

  startTrip({required String id, required String tripId}) {
    print('starting trip in socket');
    socket.emit("START_TRIP", {
      'id':
          // '65aa5dbab2e8f20021fcac83',
          id,
      'tripId':
          // '9653b8ed-16f2-4416-8ba8-1ed46abe0b0d',
          tripId,
    });
    print('response of started trip in socket');
    listenForSuccess();
  }

  endTrip({required String id, required String tripId}) {
    print('sending ending trip in socket');
    socket.emit("END_TRIP", {
      'id':
          // '65aa5dbab2e8f20021fcac83',
          id,
      'tripId':
          // '8924a142-6963-4386-a9bc-67ef8289acf5'
          tripId,
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

  // Create a single completer
  // Completer<dynamic>? _completer;
  // Method to listen for "SUCCESS" event
  // Future<dynamic> listenForSuccess() {
  //   print("listening for success");
  //
  //   // Only create the completer if it hasn't been created yet
  //   _completer ??= Completer<dynamic>();
  //
  //   // Only register the event listener if it hasn't been registered yet
  //   if (!_completer!.isCompleted) {
  //     // Define a callback function to handle the SUCCESS event
  //     void successHandler(data) {
  //       print(data);
  //       // Resolve the completer with the received data
  //       _completer!.complete(data);
  //     }
  //
  //     // Register the event listener for the SUCCESS event
  //     socket.on("SUCCESS", successHandler);
  //   }
  //
  //   // Return the future from the completer
  //   return _completer!.future;
  // }
  // Future<dynamic> listenForSuccess() {
  //   print("listening for success");
  //
  //   Completer<dynamic> completer = Completer<dynamic>();
  //   socket.on("SUCCESS", (data) {
  //     print(data);
  //     // Resolve the completer with the received data
  //     completer.complete(data);
  //
  //     // print("sucess getting trip data: $data");
  //     // Handle success as needed
  //   });
  //
  //   // Return the future from the completer
  //   return completer.future;
  // }

  listenForError() {
    socket.on("ERROR", (data) {
      print("Error getting trip data: $data");
    });
  }
}
