
import 'package:flutter/material.dart';
import 'package:ride_on_driver/model/login_model.dart';
import 'package:ride_on_driver/model/signup_model.dart';
import 'package:ride_on_driver/provider/driver_provider.dart';
import 'package:ride_on_driver/screens/login_screen.dart';
import 'package:ride_on_driver/services/authentication_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ride_on_driver/screens/home_screen.dart';

import '../screens/mail_sent_screen.dart';
import '../services/driver_services.dart';
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
  // String? _driverImage;
  // String? get driverImage => _driverImage;
  String? _error;
  String? get error => _error;
  String? _token;
  String? get token => _token;
  String? _id;
  String? get id => _id;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  int? _walletBalance;
  int? get walletBalance => _walletBalance;

  final AuthService _authService = AuthService();
  final SocketService _socketService = SocketService();
  final DriverService _driverService = DriverService();
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
      String? token, int? walletBalance, String? id) {
    _driverName = driverName;
    _driverLastName = driverLastName;
    _driverEmail = driverEmail;
    _token = token;
    _walletBalance = walletBalance;
    _id = id;
  }

  //save the driver information data
  saveDriverData(String driverName, String driverLastName, String driverEmail,
      String token, int walletBalance, String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('driver_name', driverName);
    await prefs.setString('driver_lastname', driverLastName);
    await prefs.setString('driver_email', driverEmail);
    await prefs.setString('auth_token', token);
    await prefs.setInt('wallet_balance', walletBalance);
    await prefs.setString('id', id);
    notifyListeners();
  }

  ///login function
  signIn(BuildContext context, String email, String password) async {
    try {
      print('signing method in provider service');
      _signInLoading = true;
      final responseData = await _authService.signIn(email, password);

      final loginResponse = DriverModel.fromJson(responseData);
      print(responseData);
      if (loginResponse.message == 'success') {
        print('data gotten');
        _driverName = loginResponse.data.driver.firstName;
        print(' driver name $_driverName');
        _driverEmail = loginResponse.data.driver.email;
        print(_driverEmail);
        _driverLastName = loginResponse.data.driver.lastName;
        print(_driverLastName);
        _walletBalance = loginResponse.data.driver.walletBalance;
        print('driver wallet balance $_walletBalance');
        _token = loginResponse.data.token;
        print(_token);
        _id = loginResponse.data.driver.id;
        print('driver id $_id');
        // _driverImage = loginResponse.data.userDetails.image;
        // print('driver id $_driverImage');
        /// Initialize the socket with the user token
        _socketService.initSocket(_token!, _id!);


        await saveDriverData( _driverName!, _driverLastName!,_driverEmail!,_token!, _walletBalance!, _id!);
        notifyListeners();
        _signInLoading = false;
        //navigate to home page
        if(_driverName !=null && _driverLastName != null &&_driverEmail!=null &&_token!=null && _walletBalance!=null && _id!=null) {
          Future.delayed(Duration.zero, () {
          /// Authenticate the socket connection
          _socketService.authenticate();

          /// Start location updates when user logs in
          _driverService.startLocationUpdates();


          ///start driver status
          // _socketService.driverOnlineStatus(id: _id!, availability: true);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        });
        }
      } else {
        _signInLoading = false;
        notifyListeners();
        print('error');
        setError(responseData['message']);
      }
    }catch(e){
    _signInLoading = false;
      print('printing the eroor in provide login $e');
      notifyListeners();
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
      notifyListeners();
    } else {
      _signUpLoading = false;
      print('error');
      setError(responseData['message']);
      notifyListeners();
    }
    _signUpLoading = false;
    notifyListeners();
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

    // Stop location updates when user logs out
    _driverService.stopLocationUpdates();
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
