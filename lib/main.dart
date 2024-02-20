import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ride_on_driver/provider/authprovider.dart';
import 'package:ride_on_driver/provider/driver_provider.dart';
import 'package:ride_on_driver/provider/map_provider.dart';
import 'package:ride_on_driver/provider/ride_request_provider.dart';
import 'package:ride_on_driver/screens/home_screen.dart';
import 'package:ride_on_driver/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final String? id = prefs.getString('id');
  runApp(
      MyApp(driverName, driverEmail, driverLastName, token, walletBalance, id));
}

class MyApp extends StatelessWidget {
  static final GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();
  final String? initialdriverName;
  final String? initialdriverLastName;
  final String? initialdriverEmail;
  final String? initialToken;
  final int? initialwalletBalance;
  final String? initialId;

  const MyApp(
      this.initialdriverName,
      this.initialdriverLastName,
      this.initialdriverEmail,
      this.initialToken,
      this.initialwalletBalance,
      this.initialId,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('this is from the main class $initialId ');
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
                  initialId),
            ),
            ChangeNotifierProvider(create: (context) => MapView()),
            ChangeNotifierProvider(
                create: (context) =>
                    RideRequestProvider(initialToken ?? '', initialId ?? '')),
            ChangeNotifierProvider(
                create: (context) =>
                    DriverProvider(initialToken ?? '', initialId ?? '')),
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
