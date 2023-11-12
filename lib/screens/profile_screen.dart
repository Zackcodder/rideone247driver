import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:ride_on_driver/core/constants/assets.dart';
import 'package:ride_on_driver/core/constants/colors.dart';
import 'package:ride_on_driver/core/extensions/build_context_extensions.dart';
import 'package:ride_on_driver/core/extensions/list_extensions.dart';
import 'package:ride_on_driver/core/extensions/widget_extensions.dart';
import 'package:ride_on_driver/core/painters_clippers/profile_clipper.dart';
import 'package:ride_on_driver/provider/authprovider.dart';
import 'package:ride_on_driver/screens/login_screen.dart';
import 'package:ride_on_driver/screens/profile_edit_screen.dart';
import 'package:ride_on_driver/widgets/currency_widget.dart';
import 'package:ride_on_driver/widgets/spacing.dart';
import 'package:ride_on_driver/widgets/trip_list_viewer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadDriverDataFromSharedPreference();
  }

  num? _walletBalance;
  loadDriverDataFromSharedPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _walletBalance = prefs.getInt('wallet_balance') as num;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    var wallet = authProvider.walletBalance;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ClippedView(),
            Card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  [
                    SvgPicture.asset(Assets.assetsSvgsEarnedToday),
                    Text(
                      'Earned Today',
                      style: context.textTheme.bodySmall,
                    ),
                    CurrencyWidget(price: wallet!),
                  ].toColumn(
                    crossAxisAlignment: CrossAxisAlignment.center,
                  ),
                  [
                    SvgPicture.asset(Assets.assetsSvgsYouOwn),
                    Text(
                      'You Owe',
                      style: context.textTheme.bodySmall,
                    ),
                    const CurrencyWidget(price: 0),
                  ].toColumn(
                    crossAxisAlignment: CrossAxisAlignment.center,
                  )
                ],
              ),
            ).padHorizontal(20.w),
            const VerticalSpacing(20),
            const TripListViewer().expand(),
          ],
        ),
      ),
    );
  }
}

class ClippedView extends StatefulWidget {
  const ClippedView({super.key});

  @override
  State<ClippedView> createState() => _ClippedViewState();
}

class _ClippedViewState extends State<ClippedView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadDriverDataFromSharedPreference();
  }

  String? _driverName;
  String? _driverLastName;
  loadDriverDataFromSharedPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _driverLastName = prefs.getString('driver_lastname');
      _driverName = prefs.getString('driver_name');
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return ClipPath(
      clipper: ProfileClipper(),
      child: Container(
        height: 300.h,
        color: AppColors.black,
        child: Column(
          children: [
            const VerticalSpacing(20),
            AppBar(
              backgroundColor: AppColors.black,
              title: Text(
                'PROFILE',
                style: context.textTheme.bodyMedium!.copyWith(
                  color: Colors.white,
                ),
              ),
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: context.pop,
              ),
              actions: [
                IconButton(
                  onPressed: () => context.pushReplacement(const LoginScreen()),
                  icon: const Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),
                ),
                const HorizontalSpacing(10),
              ],
            ),
            const VerticalSpacing(20),
            ListTile(
              onTap: () {
                context.push(const ProfileEditScreen());
              },
              contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
              leading: Image.asset(Assets.assetsImagesDriverProfile)
                  .clip(radius: 100),
              trailing: const Icon(
                Icons.settings,
                color: Colors.white,
              ),
              title: Text(
                '$_driverName ',
                style: context.textTheme.bodyMedium!.copyWith(
                  color: Colors.white,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '134 Completed Trips',
                    style: context.textTheme.bodySmall!.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      5,
                      (index) => Icon(
                        Icons.star,
                        color: index < 4 ? AppColors.yellow : AppColors.grey,
                        size: 15.w,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
