import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:multi_value_listenable_builder/multi_value_listenable_builder.dart';
import 'package:provider/provider.dart';
import 'package:ride_on_driver/core/constants/assets.dart';
import 'package:ride_on_driver/core/constants/colors.dart';
import 'package:ride_on_driver/core/extensions/build_context_extensions.dart';
import 'package:ride_on_driver/core/extensions/widget_extensions.dart';
import 'package:ride_on_driver/provider/authprovider.dart';
import 'package:ride_on_driver/provider/ride_request_provider.dart';
import 'package:ride_on_driver/screens/chat_screen.dart';
import 'package:ride_on_driver/screens/home_screen.dart';
import 'package:ride_on_driver/screens/trips_view.dart';
import 'package:ride_on_driver/widgets/currency_widget.dart';
import 'package:ride_on_driver/widgets/icon_text_button.dart';
import 'package:ride_on_driver/widgets/spacing.dart';

import '../screens/active_trip_detail_view.dart';
import 'app_elevated_button.dart';
import 'custom_tabbar.dart';

class RiderBox extends StatefulWidget {
  const RiderBox({super.key});

  @override
  State<RiderBox> createState() => _RiderBoxState();
}

class _RiderBoxState extends State<RiderBox>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  late final TabController tabController;
  late final ValueNotifier<TabItem> currentTabNotifier;
  List<TabItem> tabs = [const TabItem('Active'), const TabItem('Requests')];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    currentTabNotifier = ValueNotifier(tabs.last);
    tabController = TabController(initialIndex: 1, length: 2, vsync: this);
  }
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    tabController.dispose();
    super.dispose();
  }
  bool _acceptRequest = false;
  @override
  Widget build(BuildContext context) {
    final rideDetails =
    Provider.of<RideRequestProvider>(context, listen: false);
    return WillPopScope(
      onWillPop: () async {
        if (tabController.index == 0) return true;

        currentTabNotifier.value = tabs[tabController.index - 1];

        tabController.animateTo(tabController.index - 1,
            duration: const Duration(milliseconds: 300));
        return false;
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: 200.h,
            margin: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 10.h),
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: AppColors.black,
              borderRadius: BorderRadius.all(
                Radius.circular(10.r),
              ),
            ),
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Image.asset(Assets.assetsImagesDriverProfile).clip(radius: 100),
                  title: Text(
                    'Trevor Philips',
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
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconTextButton(
                        icon: Icons.question_answer_rounded,
                        text: 'Chat',
                        onPressed: () {
                          context.push(const ChatScreen());
                        },
                        iconColor: AppColors.black,
                        textColor: Colors.black,
                        backgroundColor: AppColors.yellow,
                      ),
                    ],
                  ),
                ),
                Divider(color: AppColors.lightGrey.withOpacity(0.5)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.question_answer,
                      color: Colors.white,
                      size: 25.w,
                    ),
                    Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 25.w,
                    ).onTap(() {
                      isRideActiveNotifier.value = false;
                    }),
                  ],
                ).padHorizontal(20),
                Divider(color: AppColors.lightGrey.withOpacity(0.5)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '4.2 mi',
                      style: context.textTheme.bodySmall!.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    const CurrencyWidget(price: 800, color: Colors.white),
                    Text(
                      '14:20',
                      style: context.textTheme.bodySmall!.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Cash',
                      style: context.textTheme.bodySmall!.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ).padHorizontal(20).expand(),
              ],
            ),
          ),

          _acceptRequest != true ?
              ///accept trip button
          AppElevatedButton.large(
            onPressed: () async {

              // Call acceptTripRequest function when the button is pressed
              rideDetails.acceptRideRequest(
                rideDetails.tripId ??'', // Assuming driverId is used as the id
                rideDetails.tripLat ??'',
                rideDetails.tripLng??'',
                rideDetails.driverTripId ??''
              );

              print('this is a trip lat in ui: ${rideDetails.tripLat??''}');
              print('this is a trip lng in ui: ${rideDetails.tripLng??''}');
              print('this is a trip id in ui: ${rideDetails.tripId ??''}');
              print('this is a trip driver in ui: ${rideDetails.driverTripId ??''}');
              setState(() {
                _acceptRequest = true;
              });
            },
            text: 'Accept Trip',
          ) :

              /// start trip button
          AppElevatedButton.large(
            onPressed: ()  {
              rideDetails.startRide(
                  rideDetails.tripId ??'',
                  rideDetails.driverTripId ??'');
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
            text: 'Start Trip',
          ),

          const VerticalSpacing(10),
        ],
      ),
    );
  }
}
