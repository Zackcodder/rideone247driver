import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ride_on_driver/provider/authprovider.dart';
import 'package:ride_on_driver/screens/home_screen.dart';
import 'package:ride_on_driver/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/constants/strings.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('auth_token');
  final String? driverName = prefs.getString('drive_name');
  final String? driverLastName = prefs.getString('drive_lastname');
  final String? driverEmail = prefs.getString('driver_email');
  // final int? walletBalance = prefs.getInt('wallet_balance');
  runApp(MyApp(
    token,
    driverName,
    driverEmail,
    driverLastName,
  ));
}

class MyApp extends StatelessWidget {
  final String? initialToken;
  final String? initialdriverName;
  final String? initialdriverLastName;
  // final int? initialwalletBalance;
  final String? initialdriverEmail;
  const MyApp(this.initialToken, this.initialdriverEmail,
      this.initialdriverLastName, this.initialdriverName,
      // this.initialwalletBalance,
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
                initialdriverEmail,
                initialToken,
                initialdriverLastName,
                // initialwalletBalance as int,
              ),
            )
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
