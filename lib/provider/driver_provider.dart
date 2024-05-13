import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ride_on_driver/model/rides_histories_model.dart';
import 'package:ride_on_driver/services/driver_services.dart';

import '../core/constants/colors.dart';
import '../model/account_profile_model.dart';
import '../model/login_model.dart';

class DriverProvider with ChangeNotifier {
  final DriverService _driverService = DriverService();

  ///user rating
  double? _userRate;
  double? get userRate => _userRate;
  setDriverRating(double rating) {
    _userRate = rating;
    notifyListeners();
  }
  userRating(
    String docId,
    String docModel,
    String rating,
    String comment,
    String token,
  ) async {
    try {
      final responseData = await _driverService.rateUser(
        docId,
        docModel,
        rating,
        comment,
        token,
      );

      final ratingResponse = DriverModel.fromJson(responseData);
      print(responseData);
      if (ratingResponse.message == 'success') {
        throw Fluttertoast.showToast(
            fontSize: 18,
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: AppColors.green.withOpacity(0.7),
            msg: ratingResponse.message,
            gravity: ToastGravity.BOTTOM,
            textColor: AppColors.black);
      }
    } catch (e) {
      print('error from rating user by driver $e');
    }
  }

  ///ride histories
  List<RidesHistories>? allRideHistory;

  fetchRideHistory(String token) async {
    print('oya ooo');
    try {
      allRideHistory = await _driverService.getRideHistory(token);
      print('ahhhh');
      notifyListeners();
    } catch (error) {
      // Handle error
      print('Error fetching ride history: $error');
    }
  }

  ///driver profile
  DriverInformation? driverInformation;
  bool _profileLoading = false;
  bool get profileLoading => _profileLoading;

   fetchDriverProfile(String token) async {
    try {
      _profileLoading = true;
      notifyListeners();

      var response = await DriverService().getDriverProfile(token);
      driverInformation = DriverInformation.fromJson(response);

      _profileLoading = false;
      notifyListeners();
    } catch (e) {
      _profileLoading = false;
      notifyListeners();

      Fluttertoast.showToast(
        fontSize: 18,
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.red.withOpacity(0.7),
        msg: e.toString(),
        gravity: ToastGravity.BOTTOM,
        textColor: Colors.white,
      );
    }
  }
}
