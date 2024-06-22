import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ride_on_driver/core/extensions/build_context_extensions.dart';
import 'package:ride_on_driver/provider/authprovider.dart';
import 'package:ride_on_driver/provider/driver_provider.dart';
import 'package:ride_on_driver/provider/history_provider.dart';
import 'package:ride_on_driver/provider/map_provider.dart';
import 'package:ride_on_driver/provider/nav_bar_provider.dart';
import 'package:ride_on_driver/provider/ride_request_provider.dart';
import 'package:ride_on_driver/screens/authentication_screens/login_screen.dart';
import 'package:ride_on_driver/screens/nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/constants/colors.dart';
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

class MyApp extends StatefulWidget {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  final String? initialdriverName;
  final String? initialdriverLastName;
  final String? initialdriverEmail;
  final String? initialToken;
  final int? initialwalletBalance;
  final String? initialId;

   MyApp(
      this.initialdriverName,
      this.initialdriverLastName,
      this.initialdriverEmail,
      this.initialToken,
      this.initialwalletBalance,
      this.initialId,
      {super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DateTime? _lastPressedAt;

  @override
  Widget build(BuildContext context) {
    // ImageConfiguration imageConfiguration = createLocalImageConfiguration(context, size: const Size(2, 2));

    print('this is from the main class ${widget.initialId} ');
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
                  widget.initialdriverName,
                  widget.initialdriverLastName,
                  widget.initialdriverEmail,
                  widget.initialToken,
                  widget.initialwalletBalance,
                  widget.initialId),
            ),
            ChangeNotifierProvider(create: (context) => MapView()),
            ChangeNotifierProvider(
                create: (context) => RideRequestProvider(
                    widget.initialToken ?? '', widget.initialId ?? '', ImageConfiguration)),
            ChangeNotifierProvider(create: (context) => DriverProvider()),
            ChangeNotifierProvider(create: (context) => OrderHistoryProvider()),
            ChangeNotifierProvider(create: (context) => NavbarProvider())
          ],
          child: WillPopScope(
            onWillPop: () async {
              final now = DateTime.now();
              if (_lastPressedAt == null || now.difference(_lastPressedAt!) > const Duration(seconds: 5)) {
// Show the Snackbar or Toast message
                _lastPressedAt = now;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.transparent,
                    content: Text('Press back again to exit',
                        textAlign: TextAlign.center,
                        style: context.textTheme.bodySmall!
                            .copyWith(
                            color: AppColors.black,
                            fontWeight: FontWeight.bold)),
                    duration: Duration(seconds: 2),
                  ),
                );
                return false; // Prevent app from closing
              }
              return true; // Close the app
            },
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: AppStrings.appName,
              theme: AppTheme.lightTheme,
              navigatorKey: MyApp.navigatorKey,
              home: widget.initialToken != null ?  const NavBar() : const LoginScreen(),
            ),
          ),
        );
      },
    );
  }
}