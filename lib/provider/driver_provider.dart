import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ride_on_driver/services/driver_services.dart';

import '../core/constants/colors.dart';
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
            gravity: ToastGravity.TOP,
            textColor: AppColors.black);
      }
    } catch (e) {
      print('error from rating user by driver $e');
    }
  }
}
