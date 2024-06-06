import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as https;
import 'package:ride_on_driver/core/constants/colors.dart';
import 'package:ride_on_driver/model/rides_histories_model.dart';
import 'geo_locator_service.dart';
import 'socket_service.dart';

class DriverService {
  final GeoLocationService _geoLocationService = GeoLocationService();
  final SocketService _socketService = SocketService();
  final String baseUrl = 'https://rideon247-production.up.railway.app';

  ///update driver location
  updateDriverLiveStatus() async {
    final position =
        await _geoLocationService.getCurrentPosition(asPosition: false);

    final response = await https.get(Uri.parse(
        '$baseUrl?CurrentLongitude=${position[1]}&CurrentLatitude=${position[0]}'));
  }

  /// Define a Timer variable to schedule the periodic updates.
  Timer? locationUpdateTimer;
  bool online = true;
  String? id;

  /// Call this method to start updating the driver's location periodically.
  startLocationUpdates(String driverId) {
    /// Start a repeating timer that calls the updateLocation method every 5 seconds.
    locationUpdateTimer = Timer.periodic(const Duration(seconds: 60), (timer) {
      updateDriverLiveStatus();
      updateLocation(driverId);
    });
  }

  /// Call this method to stop the periodic location updates.
  stopLocationUpdates() {
    locationUpdateTimer?.cancel();
  }

  /// Update location using socket

  updateLocation(String driverId) async {
    final position =
        await _geoLocationService.getCurrentPosition(asPosition: true);
    _socketService.updateLocation(
      id: driverId,
      role: 'DRIVER',
      lat: position[0].toString(),
      lon: position[1].toString(),
    );
    print('this is from the driver service class');
    print('Driver Id: $driverId');
    print('Latitude: ${position[0]}');
    print('Longitude: ${position[1]}');
    _socketService.driverLocationUpdate();
  }

  ///user rating
  rateUser(String docId, String docModel, String rating, String comment,
      String token) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      };
      var response = await https.post(
        Uri.parse('$baseUrl/api/review'),
        body: jsonEncode({
          'docId': docId,
          'docModel': docModel,
          'rating': rating,
          'comment': 'The ride was ok'
        }),
        headers: headers,
      );
      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200 && responseData['message'] == 'success') {
        Fluttertoast.showToast(
            fontSize: 18,
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: AppColors.green.withOpacity(0.7),
            msg: responseData['message'],
            gravity: ToastGravity.BOTTOM,
            textColor: AppColors.white);
        return responseData;
      } else {
        return;
      }
    } catch (e) {
      print('error login in');
      print(e);
    }
  }

  ///ride history
  Future<List<RidesHistories>> getRideHistory(String token) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    try {
      var response = await https.get(
        Uri.parse('$baseUrl/api/trips/history'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['message'] == 'success') {
          print('e chock sha');
          // Deserialize JSON response into List of Trip objects
          List<dynamic> tripListJson = responseData['data']['Trips'];
          print(tripListJson);
          print('hmmm');
          List<RidesHistories> tripList = tripListJson
              .map((json) => RidesHistories.fromJson(json))
              .toList();
          print('ahahahahah');
          return tripList;
        } else {
          throw Exception(responseData['message']);
        }
      } else {
        // Handle HTTP error
        throw Exception('Failed to load ride history');
      }
    } catch (error) {
      // Handle any other errors
      throw Exception('Failed to load ride history: $error');
    }
  }

  /// driver profile
  getDriverProfile(String token) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var response =
        await https.get(Uri.parse('$baseUrl/api/drivers'), headers: headers);
    final driverProfileResponseData = jsonDecode(response.body);
    print('this is the response $driverProfileResponseData');
    if (response.statusCode == 200 &&
        driverProfileResponseData['message'] == 'success') {
      return driverProfileResponseData;
    } else {
      throw Fluttertoast.showToast(
          fontSize: 18,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.red.withOpacity(0.7),
          msg: driverProfileResponseData['message'],
          gravity: ToastGravity.BOTTOM,
          textColor: Colors.white);
    }
  }
}
