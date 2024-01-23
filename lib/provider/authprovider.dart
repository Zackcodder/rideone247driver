import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ride_on_driver/model/login_model.dart';
import 'package:ride_on_driver/model/signup_model.dart';
import 'package:ride_on_driver/screens/login_screen.dart';
import 'package:ride_on_driver/services/authentication_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ride_on_driver/screens/home_screen.dart';

import '../screens/mail_sent_screen.dart';
import '../services/socket_service.dart';

class AuthProvider with ChangeNotifier {
  bool _signInLoading = false;
  bool get signInLoading => _signInLoading;
  bool _signUpLoading = false;
  bool get signUpLoading => _signUpLoading;
  DriverModel? _driver;
  DriverModel? get driver => _driver;
  SignUpResponse? _driverSignUp;
  SignUpResponse? get driverSignUp => _driverSignUp;
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
  final SocketService _socketService = SocketService();

  setError(String message) {
    _error = message;
    notifyListeners();
  }

  setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  //load the token and user name from the storage

  AuthProvider(String? driverName, String? driverLastName, String? driverEmail,
      String? token, int? walletBalance) {
    _driverName = driverName;
    _driverLastName = driverLastName;
    _driverEmail = driverEmail;
    _token = token;
    _walletBalance = walletBalance;
  }

  //save the driver information data
  saveDriverData(String driverName, String driverLastName, String driverEmail,
      String token, int walletBalance) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('driver_name', driverName);
    await prefs.setString('driver_lastname', driverLastName);
    await prefs.setString('driver_email', driverEmail);
    await prefs.setString('auth_token', token);
    await prefs.setInt('wallet_balance', walletBalance);
    notifyListeners();
  }

  //login function
  signIn(BuildContext context, String email, String password) async {
    try {
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
        print(_driverLastName);
        _walletBalance = loginResponse.data.userDetails.walletBalance;



        print('driver wallet balance $_walletBalance');

        _token = loginResponse.data.token;
        print(_token);
        // Initialize the socket with the user token
        _socketService.initSocket(_token!);

        // Authenticate the socket connection
        _socketService.authenticate();
        await saveDriverData( _driverName!, _driverLastName!,_driverEmail!,_token!, _walletBalance!);
        _signInLoading = false;
        //navigate to home page
        Future.delayed(Duration.zero, () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        });
      } else {
        print('error');
        setError(responseData['message']);
        _signInLoading = false;
      }
    }catch(e){
      print('printing the eroor in provide login $e');
    }
  }

  //SignUp
  signUp(BuildContext context, String firstName, String lastName, String phone,
      String email, String password, String gender, String role) async {
    print('signing method in provider service');
    _signUpLoading = true;
    final responseData = await _authService.signUp(
        firstName, lastName, phone, email, password, gender, role);

    final signUpResponse = SignUpResponse.fromJson(responseData);
    print(responseData);
    if (signUpResponse.message == 'success') {
      //navigate to home page
      Future.delayed(Duration.zero, () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      });
      _signUpLoading = false;
    } else {
      print('error');
      setError(responseData['message']);
      _signUpLoading = false;
    }
    _signUpLoading = false;
  }

  //sending of otp
  sendOtp(BuildContext context, String otp) async {
    final responseData = await _authService.sendOtp(otp);

    if (responseData['message'] == 'success') {
      // navigate to otp page
      Future.delayed(Duration.zero, () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      });
    } else {
      setError(responseData['message']);
    }
  }

  //forgot password
  forgotPassword(BuildContext context, String email) async {
    final responseData = await _authService.forgetPassword(email);

    if (responseData['message'] == 'success') {
      // navigate to mail screen page
      Future.delayed(Duration.zero, () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MailSentScreen()),
        );
      });
    } else {
      setError(responseData['message']);
    }
  }

  //reset password
  resetPassword(BuildContext context, String otp, String newPassword) async {
    final responseData = await _authService.resetPassword(otp, newPassword);

    if (responseData['message'] == 'success') {
      // navigate to login page
      Future.delayed(Duration.zero, () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      });
    } else {
      setError(responseData['message']);
    }
  }

  ///logout
   logout(BuildContext context) async {
    // Clear user-related data
    _driverName = null;
    _driverEmail = null;
    _driverLastName = null;
    _token = null;
    _walletBalance = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('driver_email');
    await prefs.remove('driver_name');
    await prefs.remove('driver_lastname');
    await prefs.remove('wallet_balance');

    // Disconnect the socket
    _socketService.disconnectSocket();
    ///navigate to login page
    Future.delayed(Duration.zero, () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });

    // Notify listeners
    notifyListeners();
  }
}
