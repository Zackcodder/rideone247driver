import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:multi_value_listenable_builder/multi_value_listenable_builder.dart';
import 'package:provider/provider.dart';
import 'package:ride_on_driver/core/constants/assets.dart';
import 'package:ride_on_driver/core/extensions/build_context_extensions.dart';
import 'package:ride_on_driver/core/extensions/widget_extensions.dart';
import 'package:ride_on_driver/provider/map_provider.dart';
import 'package:ride_on_driver/screens/active_trip_detail_view.dart';
import 'package:ride_on_driver/screens/profile_screen.dart';
import 'package:ride_on_driver/screens/requests_view.dart';
import 'package:ride_on_driver/screens/trip_completed.dart';
import 'package:ride_on_driver/services/driver_services.dart';
import 'package:ride_on_driver/widgets/app_logo.dart';
import 'package:ride_on_driver/widgets/custom_switch.dart';
import 'package:ride_on_driver/widgets/spacing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/colors.dart';
import '../provider/ride_request_provider.dart';
import '../widgets/app_elevated_button.dart';
import '../widgets/currency_widget.dart';
import '../widgets/custom_tabbar.dart';
import '../widgets/icon_text_button.dart';
import '../widgets/map_widget.dart';
import 'chat_screen.dart';
import 'trips_view.dart';

// ValueNotifier isActiveNotifier = ValueNotifier(true);
ValueNotifier<bool> isActiveNotifier = ValueNotifier<bool>(false);

ValueNotifier isRideActiveNotifier = ValueNotifier(false);

class HomeScreen extends StatefulWidget {
  static String id = 'home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  late final TabController tabController;
  late final ValueNotifier<TabItem> currentTabNotifier;
  List<TabItem> tabs = [const TabItem('Active'), const TabItem('Requests')];
  late RideRequestProvider _rideRequestProvider;
  // String? _id = Provider.of<AuthProvider>(context, listen: false).id;
  String? _id;

  loadDriverDataFromSharedPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _id = prefs.getString('id');
    });
  }

  DriverService _driverService = DriverService();

  @override
  initState() {
    super.initState();
    loadDriverDataFromSharedPreference();
    WidgetsBinding.instance.addObserver(this);
    currentTabNotifier = ValueNotifier(tabs.first);
    _driverService.startLocationUpdates();
    tabController = TabController(initialIndex: 0, length: 2, vsync: this);
    _rideRequestProvider =
        Provider.of<RideRequestProvider>(context, listen: false);
    _rideRequestProvider.updateDriverStatus(
        context, _id ?? '', isActiveNotifier.value);
    _rideRequestProvider =
        Provider.of<RideRequestProvider>(context, listen: false);
    _rideRequestProvider.listenForRideRequests();
    _rideRequestProvider.acceptRideRequestResponse();
    _rideRequestProvider.driverOnlineStatus();
    setState(() {});
  }

  @override
  didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      isActiveNotifier.dispose();
      setState(() {});
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    tabController.dispose();
    // isActiveNotifier.dispose();
    super.dispose();
  }

  bool _acceptRequest = false;
  bool _startTripRequest = false;
  @override
  Widget build(BuildContext context) {
    ImageConfiguration imageConfiguration =
        createLocalImageConfiguration(context, size: const Size(2, 2));
    RideRequestProvider rideDetails = Provider.of<RideRequestProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        if (tabController.index == 0) return true;

        currentTabNotifier.value = tabs[tabController.index - 1];

        tabController.animateTo(tabController.index - 1,
            duration: const Duration(milliseconds: 300));
        return false;
      },
      child: Scaffold(
        body: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: [
            const MapWidget(),

            ///online button
            Positioned(
              top: 60,
              child:

                  ///toggle button tp go online and off line
                  ValueListenableBuilder(
                      valueListenable: isActiveNotifier,
                      builder: (context, isActive, _) {
                        return CustomSwitch(
                            value: isActive,
                            onChanged: (value) async {
                              setState(() {
                                isActiveNotifier.value = value;
                                rideDetails.updateDriverStatus(
                                    context, _id!, value);
                              });
                              setState(() {});
                            }
                            // (value) => isActiveNotifier.value = value,
                            );
                      }),
            ),

            ///driver image
            Positioned(
              top: 50,
              right: 20,
              child:

                  ///driver image
                  UnconstrainedBox(
                child: Image.asset(
                  Assets.assetsImagesDriverProfile,
                  width: 40.w,
                ).clip(radius: 100),
              ).onTap(() => context.push(const ProfileScreen())),
            ),

            ///new trip request
            rideDetails.newTripRequest == true &&
                    rideDetails.acceptedNewTripRequest == false
                ? Positioned(
              bottom: 50,
              left: 10,
              right: 10,
              child: AnimatedSize(
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeIn,
                child: Container(
                  height: rideDetails.tripRequestSheetHeight,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ///user image, name, trip distance and min, trip cost
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          ///user image
                          UnconstrainedBox(
                            child: Image.asset(
                              Assets.assetsImagesDriverProfile,
                              width: 70.w,
                            ).clip(radius: 100),
                          ),

                          ///user name n trip info
                          Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                rideDetails.riderName ??
                                    'no name',
                                style: context
                                    .textTheme.bodySmall!
                                    .copyWith(
                                    color: AppColors.white),
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: AppColors.yellow,
                                    size: 15,
                                  ),
                                  Text('4.5',
                                      style: context
                                          .textTheme.bodySmall!
                                          .copyWith(
                                          color:
                                          AppColors.white,
                                          fontWeight:
                                          FontWeight
                                              .bold)),
                                ],
                              ),
                              Text(
                                  '${rideDetails.tripDistance} Kms away | ${rideDetails.etaTimer} mins',
                                  style: context
                                      .textTheme.bodySmall!
                                      .copyWith(
                                      color:
                                      AppColors.white)),
                            ],
                          ),

                          ///trp cost
                          Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              ///trip cost
                              SizedBox(
                                child: Align(
                                    alignment:
                                    Alignment.centerRight,
                                    child: CurrencyWidget(
                                      price: rideDetails.tripCost!
                                          .toInt(),
                                      color: AppColors.white,
                                      fontSize: 18,
                                    )
                                  // price: trip.cost),
                                ),
                              ),
                              Text('Trp Fee',
                                  style: context
                                      .textTheme.bodySmall!
                                      .copyWith(
                                      color: AppColors.white))
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),

                      ///trip details (pickup nad dest)
                      Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pickup from: ${rideDetails.riderPickUpLocationName}',
                            style: context.textTheme.bodySmall!
                                .copyWith(color: AppColors.white),
                          ),
                          Text(
                            'Dropoff at: ${rideDetails.riderDestinationLocationName}',
                            style: context.textTheme.bodySmall!
                                .copyWith(color: AppColors.white),
                          )
                        ],
                      ),
                      const Divider(
                        color: AppColors.grey,
                      ),

                      ///accept and reject trip button
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceEvenly,
                        children: [
                          ///accept button
                          AppElevatedButton.medium(
                            onPressed: () async {
                              setState(() {
                                // rideDetails.displayDirectionsToPickup(imageConfiguration);
                                /// Call acceptTripRequest function when the button is pressed
                                rideDetails.acceptRideRequest(
                                    rideDetails.driverId ?? '',
                                    rideDetails.tripLng ??
                                        '', // Assuming driverId is used as the id
                                    rideDetails.tripLat ?? '',
                                    rideDetails.tripId ?? '');
                              });
                              print(
                                  'this is a trip lat in ui: ${rideDetails.tripLat ?? ''}');
                              print(
                                  'this is a trip lng in ui: ${rideDetails.tripLng ?? ''}');
                              print(
                                  'this is a trip id in ui: ${rideDetails.tripId ?? ''}');
                              print(
                                  'this is a driver id ui: ${rideDetails.driverId ?? ''}');
                              context.pop();
                              isRideActiveNotifier.value = true;
                            },
                            text: 'Accept',
                            backgroundColor: AppColors.green,
                            foregroundColor: AppColors.yellow,
                          ).expand(),
                          const SizedBox(
                            width: 15,
                          ),

                          ///reject button
                          AppElevatedButton.medium(
                            onPressed: () async {
                              setState(() {});
                            },
                            text: 'Reject',
                            backgroundColor: AppColors.red,
                            foregroundColor: AppColors.yellow,
                          ).expand(),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )

                : rideDetails.newTripRequest == false &&
                        rideDetails.acceptedNewTripRequest == true
                    ?

                    ///accepted trip screen
            Positioned(
              bottom: 30,
              left: 10,
              right: 10,
              child: AnimatedSize(
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeIn,
                child: Container(
                  height: rideDetails
                      .acceptedTripRequestSheetHeight,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      ///user image, name, trip distance and min, trip cost
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.start,
                        children: [
                          ///user image
                          UnconstrainedBox(
                            child: Image.asset(
                              Assets
                                  .assetsImagesDriverProfile,
                              width: 70.w,
                            ).clip(radius: 100),
                          ),

                          const SizedBox(
                            width: 15,
                          ),

                          ///user name n trip infor
                          Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    rideDetails.riderName ??
                                        'no name',
                                    style: context
                                        .textTheme.bodySmall!
                                        .copyWith(
                                        color: AppColors
                                            .white),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  const Icon(
                                    Icons.star,
                                    color: AppColors.yellow,
                                    size: 15,
                                  ),
                                  Text('4.5',
                                      style: context.textTheme
                                          .bodySmall!
                                          .copyWith(
                                          color: AppColors
                                              .white,
                                          fontWeight:
                                          FontWeight
                                              .bold)),
                                ],
                              ),
                              Text(
                                  '${rideDetails.tripDistance} Kms away | ${rideDetails.etaTimer} mins',
                                  style: context
                                      .textTheme.bodySmall!
                                      .copyWith(
                                      color: AppColors
                                          .white)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),

                      const Divider(
                        color: AppColors.grey,
                      ),

                      ///call, chat and cancel buttons
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          ///chat
                          IconTextButton(
                            icon:
                            Icons.question_answer_rounded,
                            text: 'Chat',
                            onPressed: () {
                              context
                                  .push(const ChatScreen());
                            },
                            iconColor: AppColors.yellow,
                            textColor: Colors.white,
                            backgroundColor: AppColors.black,
                          ),

                          ///call
                          IconTextButton(
                            icon: Icons.wifi_calling,
                            text: 'Call',
                            onPressed: () {
                              context
                                  .push(const ChatScreen());
                            },
                            iconColor: AppColors.yellow,
                            textColor: Colors.white,
                            backgroundColor: AppColors.black,
                          ),

                          ///cancel
                          IconTextButton(
                            icon: Icons.cancel_outlined,
                            text: 'Cancel',
                            onPressed: () {
                              context
                                  .push(const ChatScreen());
                            },
                            iconColor: AppColors.yellow,
                            textColor: Colors.white,
                            backgroundColor: AppColors.black,
                          ),
                        ],
                      ),
                      const Divider(
                        color: AppColors.grey,
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      ///accept and reject trip button
                      _acceptRequest != true
                          ? AppElevatedButton.medium(
                        onPressed: () async {
                          setState(() {
                            _acceptRequest = true;
                          });
                        },
                        text: 'Arrived',
                        backgroundColor:
                        AppColors.green,
                        foregroundColor:
                        AppColors.white,
                      ).expand()
                          : _startTripRequest != true &&
                          _acceptRequest != true
                          ?

                      /// start trip button
                      AppElevatedButton.large(
                        onPressed: () async {
                          setState(() {
                            rideDetails
                                .displayDirectionForActivateTrip(
                                imageConfiguration);
                            rideDetails.startRide(
                              rideDetails
                                  .driverId ??
                                  '',
                              rideDetails
                                  .acceptedTripId ??
                                  '',
                            );
                            print(
                                'printing from the start trip button the driver id ${rideDetails.driverId}');
                            print(
                                'printing from the start trip button the trip id ${rideDetails.acceptedTripId}');
                            _startTripRequest =
                            true;
                            _acceptRequest = true;
                          });
                          // rideDetails.displayDirectionsToPickup(imageConfiguration);
                          // Navigator.pushReplacement(
                          //   context,
                          //   MaterialPageRoute(builder: (context) => const HomeScreen()),
                          // );
                          // setState(() {});
                        },
                        text: 'Start Trip',
                      ).expand()
                          :

                      ///end trip
                      AppElevatedButton.medium(
                        onPressed: () async {
                          rideDetails.endRiderTrip(
                              rideDetails
                                  .driverId ??
                                  '',
                              rideDetails
                                  .acceptedTripId ??
                                  '');
                          print(
                              'printing from the end trip button the driver id ${rideDetails.driverId}');
                          print(
                              'printing from the end trip button the trip id ${rideDetails.acceptedTripId}');
                          context.push(
                              const TripCompletedScreen());
                          isRideActiveNotifier
                              .value = false;
                          rideDetails.resetApp();
                          setState(() {});
                        },
                        text: 'TAP TO COMPLETE',
                        icon: Icons
                            .trending_flat_rounded,
                        backgroundColor:
                        AppColors.black,
                        foregroundColor:
                        AppColors.yellow,
                      ).expand(),
                    ],
                  ),
                ),
              ),
            )

                    : const SizedBox(),

          ],
        ),
      ),
    );
  }
}

// class OfflineView extends StatelessWidget {
//   const OfflineView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         color: Colors.white,
//       ),
//       child: Center(
//         child: Column(
//           children: [
//             const Spacer(),
//             SvgPicture.asset(Assets.assetsSvgsOffline),
//             Text(
//               'You are Currently Offline',
//               style: context.textTheme.titleSmall!.copyWith(
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(
//               width: 250.w,
//               child: Text(
//                 'please go online to get orders and do much more.',
//                 textAlign: TextAlign.center,
//                 style: context.textTheme.bodySmall,
//               ),
//             ),
//             const Spacer(),
//             const AppLogo(),
//             const VerticalSpacing(30),
//           ],
//         ),
//       ),
//     );
//   }
// }

///
// Center(
// child: Column(
// children: [
// const VerticalSpacing(20),
// ///toggle button for switching btw
// ///active trip and trip request screen
// MultiValueListenableBuilder(
// valueListenables: [currentTabNotifier, isRideActiveNotifier],
// builder: (context, values, _) {
// final currentTab = values[0] as TabItem;
// return CustomTabbar(
// tabs: tabs,
// selectedTab: currentTab,
// onTabSelected: (item) => {
// tabController.animateTo(
// tabs.indexOf(item),
// duration: const Duration(milliseconds: 300),
// ),
// currentTabNotifier.value = item,
// },
// );
// }),
// const VerticalSpacing(20),
// ///active trip, trip request screen and offline screen
// ValueListenableBuilder(
// valueListenable: isActiveNotifier,
// builder: (context, active, _) {
// return active
// ?
// /// Active trip screen and trip request screen
// TabBarView(
// controller: tabController,
// physics: const NeverScrollableScrollPhysics(),
// children: [
// ///active trip screen
// const TripsView(),
// ///trip request screen
// ValueListenableBuilder(
// valueListenable: isRideActiveNotifier,
// builder: (_, rideActive, __) {
// return rideActive
// ? const ActiveTripDetailView()
//     : RequestsView(
// tabController: tabController);
// },
// ),
// ],
// )
//     :
// ///offline screen
// const OfflineView();
// },
// ).expand()
// ],
// ),
// ),
// rider id: 655774a3bbb758002110f5ab
// "tripId":"979d0481-13d7-4edf-ab14-71197bab4460",

/// new request
// Consumer<RideRequestProvider>(
// builder: (context, rideRequestProvider, child) {
// return rideRequestProvider.hasRideRequests &&
// rideDetails.newTripRequest == true &&
// rideDetails.acceptedNewTripRequest == false
// ? Positioned(
// bottom: 50,
// left: 10,
// right: 10,
// child: AnimatedSize(
// duration: const Duration(milliseconds: 150),
// curve: Curves.easeIn,
// child: Container(
// height: rideDetails.tripRequestSheetHeight,
// padding: const EdgeInsets.all(15),
// decoration: BoxDecoration(
// color: Colors.black,
// borderRadius: BorderRadius.circular(10.r),
// ),
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// ///user image, name, trip distance and min, trip cost
// Row(
// mainAxisAlignment:
// MainAxisAlignment.spaceBetween,
// children: [
// ///user image
// UnconstrainedBox(
// child: Image.asset(
// Assets.assetsImagesDriverProfile,
// width: 70.w,
// ).clip(radius: 100),
// ),
//
// ///user name n trip info
// Column(
// crossAxisAlignment:
// CrossAxisAlignment.start,
// children: [
// Text(
// rideDetails.riderName ??
// 'no name',
// style: context
//     .textTheme.bodySmall!
//     .copyWith(
// color: AppColors.white),
// ),
// Row(
// children: [
// const Icon(
// Icons.star,
// color: AppColors.yellow,
// size: 15,
// ),
// Text('4.5',
// style: context
//     .textTheme.bodySmall!
//     .copyWith(
// color:
// AppColors.white,
// fontWeight:
// FontWeight
//     .bold)),
// ],
// ),
// Text(
// '${rideDetails.tripDistance} Kms away | ${rideDetails.etaTimer} mins',
// style: context
//     .textTheme.bodySmall!
//     .copyWith(
// color:
// AppColors.white)),
// ],
// ),
//
// ///trp cost
// Column(
// crossAxisAlignment:
// CrossAxisAlignment.start,
// children: [
// ///trip cost
// SizedBox(
// child: Align(
// alignment:
// Alignment.centerRight,
// child: CurrencyWidget(
// price: rideDetails.tripCost!
//     .toInt(),
// color: AppColors.white,
// fontSize: 18,
// )
// // price: trip.cost),
// ),
// ),
// Text('Trp Fee',
// style: context
//     .textTheme.bodySmall!
//     .copyWith(
// color: AppColors.white))
// ],
// )
// ],
// ),
// const SizedBox(
// height: 5,
// ),
//
// ///trip details (pickup nad dest)
// Column(
// crossAxisAlignment:
// CrossAxisAlignment.start,
// children: [
// Text(
// 'Pickup from: ${rideDetails.riderPickUpLocationName}',
// style: context.textTheme.bodySmall!
//     .copyWith(color: AppColors.white),
// ),
// Text(
// 'Dropoff at: ${rideDetails.riderDestinationLocationName}',
// style: context.textTheme.bodySmall!
//     .copyWith(color: AppColors.white),
// )
// ],
// ),
// const Divider(
// color: AppColors.grey,
// ),
//
// ///accept and reject trip button
// Row(
// mainAxisAlignment:
// MainAxisAlignment.spaceEvenly,
// children: [
// ///accept button
// AppElevatedButton.medium(
// onPressed: () async {
// setState(() {
// // rideDetails.displayDirectionsToPickup(imageConfiguration);
// /// Call acceptTripRequest function when the button is pressed
// rideDetails.acceptRideRequest(
// rideDetails.driverId ?? '',
// rideDetails.tripLng ??
// '', // Assuming driverId is used as the id
// rideDetails.tripLat ?? '',
// rideDetails.tripId ?? '');
// });
// print(
// 'this is a trip lat in ui: ${rideDetails.tripLat ?? ''}');
// print(
// 'this is a trip lng in ui: ${rideDetails.tripLng ?? ''}');
// print(
// 'this is a trip id in ui: ${rideDetails.tripId ?? ''}');
// print(
// 'this is a driver id ui: ${rideDetails.driverId ?? ''}');
// context.pop();
// isRideActiveNotifier.value = true;
// },
// text: 'Accept',
// backgroundColor: AppColors.green,
// foregroundColor: AppColors.yellow,
// ).expand(),
// const SizedBox(
// width: 15,
// ),
//
// ///reject button
// AppElevatedButton.medium(
// onPressed: () async {
// setState(() {});
// },
// text: 'Reject',
// backgroundColor: AppColors.red,
// foregroundColor: AppColors.yellow,
// ).expand(),
// ],
// )
// ],
// ),
// ),
// ),
// )
//     : const SizedBox();
// },
// )
///
/// accpet request
// Consumer<RideRequestProvider>(
// builder: (context, rideRequestProvider, child) {
// return rideDetails.acceptedNewTripRequest == true &&
// rideDetails.newTripRequest == false
// ? Positioned(
// bottom: 70,
// left: 10,
// right: 10,
// child: AnimatedSize(
// duration: const Duration(milliseconds: 150),
// curve: Curves.easeIn,
// child: Container(
// height: rideDetails
//     .acceptedTripRequestSheetHeight,
// padding: const EdgeInsets.all(15),
// decoration: BoxDecoration(
// color: Colors.black,
// borderRadius: BorderRadius.circular(10.r),
// ),
// child: Column(
// crossAxisAlignment:
// CrossAxisAlignment.start,
// children: [
// ///user image, name, trip distance and min, trip cost
// Row(
// mainAxisAlignment:
// MainAxisAlignment.start,
// children: [
// ///user image
// UnconstrainedBox(
// child: Image.asset(
// Assets
//     .assetsImagesDriverProfile,
// width: 70.w,
// ).clip(radius: 100),
// ),
//
// const SizedBox(
// width: 15,
// ),
//
// ///user name n trip infor
// Column(
// crossAxisAlignment:
// CrossAxisAlignment.start,
// children: [
// Row(
// children: [
// Text(
// rideDetails.riderName ??
// 'no name',
// style: context
//     .textTheme.bodySmall!
//     .copyWith(
// color: AppColors
//     .white),
// ),
// const SizedBox(
// width: 15,
// ),
// const Icon(
// Icons.star,
// color: AppColors.yellow,
// size: 15,
// ),
// Text('4.5',
// style: context.textTheme
//     .bodySmall!
//     .copyWith(
// color: AppColors
//     .white,
// fontWeight:
// FontWeight
//     .bold)),
// ],
// ),
// Text(
// '${rideDetails.tripDistance} Kms away | ${rideDetails.etaTimer} mins',
// style: context
//     .textTheme.bodySmall!
//     .copyWith(
// color: AppColors
//     .white)),
// ],
// ),
// ],
// ),
// const SizedBox(
// height: 5,
// ),
//
// const Divider(
// color: AppColors.grey,
// ),
//
// ///call, chat and cancel buttons
// Row(
// mainAxisAlignment:
// MainAxisAlignment.spaceBetween,
// children: [
// ///chat
// IconTextButton(
// icon:
// Icons.question_answer_rounded,
// text: 'Chat',
// onPressed: () {
// context
//     .push(const ChatScreen());
// },
// iconColor: AppColors.yellow,
// textColor: Colors.white,
// backgroundColor: AppColors.black,
// ),
//
// ///call
// IconTextButton(
// icon: Icons.wifi_calling,
// text: 'Call',
// onPressed: () {
// context
//     .push(const ChatScreen());
// },
// iconColor: AppColors.yellow,
// textColor: Colors.white,
// backgroundColor: AppColors.black,
// ),
//
// ///cancel
// IconTextButton(
// icon: Icons.cancel_outlined,
// text: 'Cancel',
// onPressed: () {
// context
//     .push(const ChatScreen());
// },
// iconColor: AppColors.yellow,
// textColor: Colors.white,
// backgroundColor: AppColors.black,
// ),
// ],
// ),
// const Divider(
// color: AppColors.grey,
// ),
// const SizedBox(
// height: 10,
// ),
//
// ///accept and reject trip button
// _acceptRequest != true
// ? AppElevatedButton.medium(
// onPressed: () async {
// setState(() {
// _acceptRequest = true;
// });
// },
// text: 'Arrived',
// backgroundColor:
// AppColors.green,
// foregroundColor:
// AppColors.white,
// ).expand()
//     : _startTripRequest != true &&
// _acceptRequest != true
// ?
//
// /// start trip button
// AppElevatedButton.large(
// onPressed: () async {
// setState(() {
// rideDetails
//     .displayDirectionForActivateTrip(
// imageConfiguration);
// rideDetails.startRide(
// rideDetails
//     .driverId ??
// '',
// rideDetails
//     .acceptedTripId ??
// '',
// );
// print(
// 'printing from the start trip button the driver id ${rideDetails.driverId}');
// print(
// 'printing from the start trip button the trip id ${rideDetails.acceptedTripId}');
// _startTripRequest =
// true;
// _acceptRequest = true;
// });
// // rideDetails.displayDirectionsToPickup(imageConfiguration);
// // Navigator.pushReplacement(
// //   context,
// //   MaterialPageRoute(builder: (context) => const HomeScreen()),
// // );
// // setState(() {});
// },
// text: 'Start Trip',
// ).expand()
//     :
//
// ///end trip
// AppElevatedButton.medium(
// onPressed: () async {
// rideDetails.endRiderTrip(
// rideDetails
//     .driverId ??
// '',
// rideDetails
//     .acceptedTripId ??
// '');
// print(
// 'printing from the end trip button the driver id ${rideDetails.driverId}');
// print(
// 'printing from the end trip button the trip id ${rideDetails.acceptedTripId}');
// context.push(
// const TripCompletedScreen());
// isRideActiveNotifier
//     .value = false;
// rideDetails.resetApp();
// setState(() {});
// },
// text: 'TAP TO COMPLETE',
// icon: Icons
//     .trending_flat_rounded,
// backgroundColor:
// AppColors.black,
// foregroundColor:
// AppColors.yellow,
// ).expand(),
// ],
// ),
// ),
// ),
// )
//     : const SizedBox();
// },
// )
///