import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as https;
import 'package:fluttertoast/fluttertoast.dart';

class AuthService {
  final String baseUrl = 'https://rideon247-production.up.railway.app';
  //login function
  signIn(String email, String password) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
      };
      var response = await https.post(
        Uri.parse('$baseUrl/api/drivers/login'),
        body: jsonEncode({'loginId': email, 'password': password}),
        headers: headers,
      );
      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200 && responseData['message'] == 'success') {
        Fluttertoast.showToast(
            fontSize: 18,
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.red.withOpacity(0.7),
            msg: responseData['message'],
            gravity: ToastGravity.BOTTOM,
            textColor: Colors.white);
        return responseData;
      } else {
        throw Fluttertoast.showToast(
            fontSize: 18,
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.red.withOpacity(0.7),
            msg: responseData['message'],
            gravity: ToastGravity.BOTTOM,
            textColor: Colors.white);
      }
    } catch (e) {
      print('error login in');
      print(e);
    }
  }

  //signup function
  signUp(String firstName, String lastName, String phone, String email,
      String password, String gender, String role) async {
    final headers = {
      'Content-Type': 'application/json',
    };
    var response = await https.post(
      Uri.parse('$baseUrl/api/users'),
      body: jsonEncode({
        'firstName': firstName,
        'lastName': lastName,
        'phone': phone,
        'email': email,
        'password': password,
        'gender': gender,
        'role': role
      }),
      headers: headers,
    );
    final responseData = jsonDecode(response.body);
    if (response.statusCode == 200 && responseData['message'] == 'success') {
      Fluttertoast.showToast(
          fontSize: 18,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.green.withOpacity(0.7),
          msg: responseData['message'],
          gravity: ToastGravity.BOTTOM,
          textColor: Colors.white);
      return responseData;
    } else {
      throw Fluttertoast.showToast(
          fontSize: 18,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.red.withOpacity(0.7),
          msg: responseData['message'],
          gravity: ToastGravity.BOTTOM,
          textColor: Colors.white);
    }
  }

  //sending of otp
  sendOtp(String otp) async {
    final headers = {
      'Content-Type': 'application/json',
    };
    var response = await https.post(
      Uri.parse('$baseUrl/api/users/verify'),
      body: jsonEncode({
        'otp': otp,
      }),
      headers: headers,
    );
    final responseData = jsonDecode(response.body);
    print('this is the response &responseData');
    if (response.statusCode == 200 && responseData['message'] == 'success') {
      Fluttertoast.showToast(
          fontSize: 18,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.green.withOpacity(0.7),
          msg: responseData['message'],
          gravity: ToastGravity.BOTTOM,
          textColor: Colors.white);
      return responseData;
    } else {
      throw Fluttertoast.showToast(
          fontSize: 18,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.red.withOpacity(0.7),
          msg: responseData['message'],
          gravity: ToastGravity.BOTTOM,
          textColor: Colors.white);
    }
  }

  //forget password
  forgetPassword(String email) async {
    final headers = {
      'Content-Type': 'application/json',
    };
    var response = await https.post(
      Uri.parse('$baseUrl/api/users/forgot-password'),
      body: jsonEncode({
        'email': email,
      }),
      headers: headers,
    );
    final responseData = jsonDecode(response.body);
    print('this is the response &responseData');
    if (response.statusCode == 200 && responseData['message'] == 'success') {
      Fluttertoast.showToast(
          fontSize: 18,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.green.withOpacity(0.7),
          msg: responseData['message'],
          gravity: ToastGravity.BOTTOM,
          textColor: Colors.white);
      return responseData;
    } else {
      throw Fluttertoast.showToast(
          fontSize: 18,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.red.withOpacity(0.7),
          msg: responseData['message'],
          gravity: ToastGravity.BOTTOM,
          textColor: Colors.white);
    }
  }

  //reset password
  resetPassword(String otp, String newPassword) async {
    final headers = {
      'Content-Type': 'application/json',
    };
    var response = await https.post(
      Uri.parse('$baseUrl/api/users/reset-password'),
      body: jsonEncode({'otp': otp, 'newPassword': newPassword}),
      headers: headers,
    );
    final responseData = jsonDecode(response.body);
    print('this is the response &responseData');
    if (response.statusCode == 200 && responseData['message'] == 'success') {
      Fluttertoast.showToast(
          fontSize: 18,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.green.withOpacity(0.7),
          msg: responseData['message'],
          gravity: ToastGravity.BOTTOM,
          textColor: Colors.white);
      return responseData;
    } else {
      throw Fluttertoast.showToast(
          fontSize: 18,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.red.withOpacity(0.7),
          msg: responseData['message'],
          gravity: ToastGravity.BOTTOM,
          textColor: Colors.white);
    }
  }
}
