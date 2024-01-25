import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ride_on_driver/provider/authprovider.dart';
import 'package:ride_on_driver/provider/driver_provider.dart';
import 'package:ride_on_driver/provider/map_provider.dart';
import 'package:ride_on_driver/provider/ride_request_provider.dart';
import 'package:ride_on_driver/screens/home_screen.dart';
import 'package:ride_on_driver/screens/login_screen.dart';
import 'package:ride_on_driver/services/geo_locator_service.dart';
import 'package:ride_on_driver/services/google_map_service.dart';
import 'package:ride_on_driver/services/socket_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'core/constants/strings.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? driverName = prefs.getString('drive_name');
  final String? driverLastName = prefs.getString('drive_lastname');
  final String? driverEmail = prefs.getString('driver_email');
  final String? token = prefs.getString('auth_token');
  final int? walletBalance = prefs.getInt('wallet_balance');
  runApp(MyApp(driverName, driverEmail, driverLastName, token, walletBalance));
}

class MyApp extends StatelessWidget {
  final String? initialdriverName;
  final String? initialdriverLastName;
  final String? initialdriverEmail;
  final String? initialToken;
  final int? initialwalletBalance;

  const MyApp(
      this.initialdriverName,
      this.initialdriverLastName,
      this.initialdriverEmail,
      this.initialToken,
      this.initialwalletBalance,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('this is from the main class $initialdriverName ');
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      useInheritedMediaQuery: true,
      ensureScreenSize: true,
      builder: (_, __) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => AuthProvider(
                initialdriverName,
                initialdriverLastName,
                initialdriverEmail,
                initialToken,
                initialwalletBalance,
              ),
            ),
            ChangeNotifierProvider(create: (context) => MapView()),
        ChangeNotifierProvider(create: (context) => RideRequestProvider(initialToken ?? '')),
        ChangeNotifierProvider(create: (context) => DriverProvider(initialToken ?? '')),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: AppStrings.appName,
            theme: AppTheme.lightTheme,
            home:
                initialToken != null ? const HomeScreen() : const LoginScreen(),
          ),
        );
      },
    );
  }
}
