import 'package:flutter/material.dart';
import 'package:ride_on_driver/model/driver_model.dart';
import 'package:ride_on_driver/services/authentication_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ride_on_driver/screens/home_screen.dart';

class AuthProvider with ChangeNotifier {
  bool _signInLoading = false;
  bool get signInLoading => _signInLoading;
  DriverModel? _driver;
  DriverModel? get driver => _driver;
  String? _driverName;
  String? get driverName => _driverName;
  String? _driverEmail;
  String? get driverEmail => _driverEmail;
  String? _driverLastName;
  String? get driverLastName => _driverLastName;
  String? _error;
  String? get error => _error;
  String? _token;
  String? get token => _token;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  int? _walletBalance;
  int? get walletBalance => _walletBalance;

  final AuthService _authService = AuthService();

  setError(String message) {
    _error = message;
    notifyListeners();
  }

  setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  //load the token and user name from the storage

  AuthProvider(
    String? driverName,
    String? driverLastName,
    String? driverEmail,
    String? token,
  ) {
    _driverName = driverName;
    _driverEmail = driverEmail;
    _driverLastName = driverLastName;
    // _walletBalance = walletBalance;
    _token = token;
  }

  //save the driver information data
  saveDriverData(
    String driverEmail,
    String driverName,
    String driverLastName,
    String token,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    await prefs.setString('driver_email', driverEmail);
    await prefs.setString('driver_name', driverName);
    await prefs.setString('driver_lastname', driverLastName);
    // await prefs.setInt('wallet_balance', walletBalance);
    notifyListeners();
  }

  //login function
  signIn(BuildContext context, String email, String password) async {
    print('signing method in provider service');
    _signInLoading = true;
    final responseData = await _authService.signIn(email, password);

    final loginResponse = DriverModel.fromJson(responseData);
    print(responseData);
    if (loginResponse.message == 'success') {
      print('data gotten');
      _driverName = loginResponse.data.userDetails.firstName;
      print(' driver name $_driverName');
      _driverEmail = loginResponse.data.userDetails.email;
      print(_driverEmail);
      _driverLastName = loginResponse.data.userDetails.lastName;
      _walletBalance = loginResponse.data.userDetails.walletBalance;

      _token = loginResponse.data.token;
      print(_token);
      await saveDriverData(
        _driverEmail!,
        _driverName!,
        _token!,
        _driverLastName!,
      );
      //navigate to home page
      Future.delayed(Duration.zero, () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      });
      _signInLoading = false;
    } else {
      print('error');
      setError(responseData['message']);
      _signInLoading = false;
    }
    _signInLoading = false;
  }
}
