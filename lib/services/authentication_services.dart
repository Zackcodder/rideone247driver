import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as https;
import 'package:fluttertoast/fluttertoast.dart';

class AuthService {
  final String baseUrl = 'https://rideon247endpoints-uqexm.ondigitalocean.app';
  signIn(String email, String password) async {
    final headers = {
      'Content-Type': 'application/json',
    };
    var response = await https.post(
      Uri.parse('$baseUrl/api/users/login/driver'),
      body: jsonEncode({'loginId': email, 'password': password}),
      headers: headers,
    );
    final responseData = jsonDecode(response.body);
    if (response.statusCode == 200 && responseData['message'] == 'success') {
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
