import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker_widget/image_picker_widget.dart';
import 'package:provider/provider.dart';
import 'package:ride_on_driver/core/constants/assets.dart';
import 'package:ride_on_driver/core/extensions/build_context_extensions.dart';
import 'package:ride_on_driver/core/extensions/int_extensions.dart';
import 'package:ride_on_driver/core/extensions/widget_extensions.dart';
import 'package:ride_on_driver/provider/authprovider.dart';
import 'package:ride_on_driver/provider/driver_provider.dart';
import 'package:ride_on_driver/screens/profile_screens/profile_screen.dart';
import 'package:ride_on_driver/services/driver_services.dart';
import 'package:ride_on_driver/widgets/custom_switch.dart';
import 'package:ride_on_driver/widgets/spacing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/colors.dart';
import '../provider/ride_request_provider.dart';
import '../widgets/app_elevated_button.dart';
import '../widgets/currency_widget.dart';
import '../widgets/icon_text_button.dart';
import '../widgets/map_widget.dart';
import 'trip_screens/chat_screen.dart';

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
    with TickerProviderStateMixin, WidgetsBindingObserver {
  ImageConfiguration imageConfiguration = const ImageConfiguration();
  final DriverService _driverService = DriverService();
  late RideRequestProvider _rideRequestProvider;
  String? _driverId;

  late AuthProvider _authProvider;

  loadDriverDataFromSharedPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _driverId = prefs.getString('id');
    });
  }

  @override
  initState() {
    super.initState();
    loadDriverDataFromSharedPreference();
    WidgetsBinding.instance.addObserver(this);
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    // _driverService.startLocationUpdates(_authProvider.id!);
    _rideRequestProvider =
        Provider.of<RideRequestProvider>(context, listen: false);
    _rideRequestProvider.updateDriverStatus(
        _driverId ?? '', isActiveNotifier.value);
    _rideRequestProvider =
        Provider.of<RideRequestProvider>(context, listen: false);
    _rideRequestProvider.listenForRideRequests(imageConfiguration);
    _rideRequestProvider.acceptRideRequestResponse(imageConfiguration);
    _rideRequestProvider.driverOnlineStatus();
    setState(() {});
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ImageConfiguration imageConfiguration =
        createLocalImageConfiguration(context, size: const Size(2, 2));
    RideRequestProvider rideDetails = Provider.of<RideRequestProvider>(context);
    final driverProvider = Provider.of<DriverProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
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
                              // rideDetails.driverOnlineStatus();
                              rideDetails.updateDriverStatus(_driverId!, value);
                              if (value == true) {
                                _driverService
                                    .startLocationUpdates(_authProvider.id!);
                                setState(() {});
                              } else {
                                setState(() {
                                  _driverService.stopLocationUpdates();
                                });
                              }
                            });
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
            ImagePickerWidget(
              backgroundColor: AppColors.black,
              diameter: 60.r,
              initialImage:
              '${driverProvider.driverInformation!.profile!.driver!.avatar}',
              iconAlignment:
              Alignment.bottomRight,
              shape:
              ImagePickerWidgetShape.circle,
              isEditable: false,
              shouldCrop: false,
            ).onTap(() => context.push(const ProfileScreen())),
                ///driver image

            //     UnconstrainedBox(
            //   child: Image.asset(
            //     Assets.assetsImagesDriverProfile,
            //     width: 40.w,
            //   ).clip(radius: 100),
            // ).onTap(() => context.push(const ProfileScreen())),
          ),

          ///Navigate to drive mode screen
          rideDetails.acceptedNewTripRequest == true
              ? Positioned(
                  right: 3,
                  top: MediaQuery.sizeOf(context).height * 0.4,
                  child: Visibility(
                    visible: true,
                    child: GestureDetector(
                      onTap: () => rideDetails
                          .launchGoogleMapsNavigationToRiderLocation(),
                      child: const Card(
                        elevation: 5,
                        color: Colors.black,
                        shape: CircleBorder(),
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Icon(
                            Icons.navigation,
                            color: Colors.orange,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
          // if (rideDetails.isNavigationActive)
          //   Positioned(
          //     bottom: 30.0,
          //     left: 16.0,
          //     right: 16.0,
          //     child: ElevatedButton(
          //       onPressed: () {
          //         // Handle your button action here
          //         print('Button Pressed');
          //       },
          //       child: Text('Custom Button'),
          //     ),
          //   ),

          ///new trip request
          rideDetails.newTripRequest == true &&
                  rideDetails.acceptedNewTripRequest == false
              ? Positioned(
                  bottom: 70,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    rideDetails.riderName ?? 'no name',
                                    style: context.textTheme.bodySmall!
                                        .copyWith(color: AppColors.white),
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        color: AppColors.yellow,
                                        size: 15,
                                      ),
                                      Text('4.5',
                                          style: context.textTheme.bodySmall!
                                              .copyWith(
                                                  color: AppColors.white,
                                                  fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  Text(
                                      '${rideDetails.distance} | ${rideDetails.etaTimer}away',
                                      style: context.textTheme.bodySmall!
                                          .copyWith(color: AppColors.white)),
                                ],
                              ),

                              ///trp cost
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ///trip cost
                                  SizedBox(
                                    child: Align(
                                        alignment: Alignment.centerRight,
                                        child: CurrencyWidget(
                                          price: rideDetails.tripCost!.toInt(),
                                          color: AppColors.white,
                                          fontSize: 18,
                                        )
                                        // price: trip.cost),
                                        ),
                                  ),
                                  Text('Trp Fee',
                                      style: context.textTheme.bodySmall!
                                          .copyWith(color: AppColors.white))
                                ],
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),

                          ///trip details (pickup nad dest)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ///accept button
                              AppElevatedButton.medium(
                                onPressed: () async {
                                  setState(() {
                                    /// Call acceptTripRequest function when the button is pressed
                                    rideDetails.acceptRideRequest(
                                        rideDetails.driverId ?? '',
                                        rideDetails.tripLng ?? '',
                                        rideDetails.tripLat ?? '',
                                        rideDetails.tripId ?? '');
                                  });
                                },
                                text: 'Accept',
                                backgroundColor: AppColors.green,
                                foregroundColor: AppColors.white,
                              ).expand(),
                              const SizedBox(
                                width: 15,
                              ),

                              ///reject button
                              AppElevatedButton.medium(
                                onPressed: () async {
                                  setState(() {
                                    rideDetails.tripRejection(
                                        rideDetails.driverId ?? '',
                                        rideDetails.tripId ?? '',
                                        imageConfiguration);
                                  });
                                },
                                text: 'Reject',
                                backgroundColor: AppColors.red,
                                foregroundColor: AppColors.white,
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
                      bottom: 70,
                      left: 10,
                      right: 10,
                      child: AnimatedSize(
                        duration: const Duration(milliseconds: 150),
                        curve: Curves.easeIn,
                        child: Container(
                          height: rideDetails.acceptedTripRequestSheetHeight,
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  ///user image
                                  UnconstrainedBox(
                                    child: Image.asset(
                                      Assets.assetsImagesDriverProfile,
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
                                            rideDetails.riderName ?? 'no name',
                                            style: context.textTheme.bodySmall!
                                                .copyWith(
                                                    color: AppColors.white),
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
                                              style: context
                                                  .textTheme.bodySmall!
                                                  .copyWith(
                                                      color: AppColors.white,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                        ],
                                      ),
                                      Text(
                                          '${rideDetails.distance} | ${rideDetails.etaTimer} away',
                                          style: context.textTheme.bodySmall!
                                              .copyWith(
                                                  color: AppColors.white)),
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
                                    icon: Icons.question_answer_rounded,
                                    text: 'Chat',
                                    onPressed: () {
                                      context.push(const ChatScreen());
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
                                      context.push(const ChatScreen());
                                    },
                                    iconColor: AppColors.yellow,
                                    textColor: Colors.white,
                                    backgroundColor: AppColors.black,
                                  ),

                                  ///cancel
                                  IconTextButton(
                                    icon: Icons.cancel_outlined,
                                    text: 'Cancel',
                                    onPressed: () async {
                                      const String driverRole = 'DRIVER';
                                      rideDetails.tripCancellation(
                                          rideDetails.driverId!,
                                          rideDetails.acceptedTripId!,
                                          driverRole,
                                          imageConfiguration);
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
                              rideDetails.tripHasStarted == false &&
                                      rideDetails.tripHasEnded == false &&
                                      rideDetails.driverHasArrived == false
                                  ? AppElevatedButton.large(
                                      onPressed: () async {
                                        setState(() {
                                          rideDetails.arrivedPickup(
                                              rideDetails.driverId ?? '',
                                              rideDetails.acceptedTripId ?? '');
                                        });
                                      },
                                      text: 'Arrived',
                                      backgroundColor: AppColors.green,
                                      foregroundColor: AppColors.white,
                                    ).expand()
                                  : rideDetails.tripHasStarted == false &&
                                          rideDetails.tripHasEnded == false &&
                                          rideDetails.driverHasArrived == true
                                      ?

                                      /// start trip button
                                      AppElevatedButton.large(
                                          onPressed: () async {
                                            setState(() {
                                              // rideDetails
                                              //     .displayDirectionForActivateTrip(
                                              //     imageConfiguration);
                                              rideDetails.startRide(
                                                rideDetails.driverId ?? '',
                                                rideDetails.acceptedTripId ??
                                                    '',
                                              );
                                            });
                                          },
                                          text: 'Start Trip',
                                          backgroundColor: AppColors.green,
                                          foregroundColor: AppColors.white,
                                        ).expand()
                                      : rideDetails.tripHasStarted == true &&
                                              rideDetails.tripHasEnded ==
                                                  false &&
                                              rideDetails.driverHasArrived ==
                                                  false
                                          ?

                                          ///end trip
                                          AppElevatedButton.large(
                                              onPressed: () async {
                                                rideDetails.endRiderTrip(
                                                    rideDetails.driverId ?? '',
                                                    rideDetails
                                                            .acceptedTripId ??
                                                        '');
                                                setState(() {});
                                              },
                                              text: 'End Trip',
                                              backgroundColor: AppColors.red,
                                              foregroundColor: AppColors.white,
                                            ).expand()
                                          : const SizedBox()
                              // : SizedBox(),
                            ],
                          ),
                        ),
                      ),
                    )
                  : rideDetails.newTripRequest == false &&
                          rideDetails.acceptedNewTripRequest == false &&
                          rideDetails.tripHasEnded == true
                      ?

                      ///rating
                      Positioned(
                          bottom: 70,
                          left: 10,
                          right: 10,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.black,
                              borderRadius: BorderRadius.circular(6.r),
                              border: Border.all(
                                color: AppColors
                                    .black, // Specify your border color here
                                width: 2, // Specify the border width
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Align(
                                  alignment: Alignment.topCenter,
                                  child: CircleAvatar(
                                    radius: 30,
                                    backgroundColor: AppColors.yellow,
                                    child: Icon(
                                      Icons.location_pin,
                                      color: AppColors.black,
                                    ),
                                  ),
                                ),
                                const VerticalSpacing(20),

                                ///title
                                Text(
                                  'Trip has ended!.',
                                  style: context.textTheme.titleLarge!.copyWith(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20,
                                      fontFamily: 'SFCOMPACTDISPLAY'),
                                ).padOnly(left: 20.w),
                                const Divider(
                                  color: AppColors.grey,
                                ),
                                const VerticalSpacing(5),

                                ///destination name
                                Text(
                                  rideDetails.riderDestinationLocationName ??
                                      'hvuktfykv',
                                  style: context.textTheme.bodySmall!.copyWith(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      fontFamily: 'SFPRODISPLAYBOLD'),
                                ).padOnly(left: 20.w),
                                const VerticalSpacing(10),

                                ///trip summary information
                                Container(
                                  margin: const EdgeInsets.only(bottom: 20),
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    color: AppColors.black,
                                    borderRadius: BorderRadius.circular(6.r),
                                    border: Border.all(
                                      color: AppColors
                                          .white, // Specify your border color here
                                      width: 1, // Specify the border width
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ///trip time
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.history,
                                            color: AppColors.yellow,
                                            size: 20,
                                          ),
                                          const VerticalSpacing(10),

                                          ///trip time
                                          Text(
                                            rideDetails.etaTimer ?? '',
                                            style: context.textTheme.bodySmall!
                                                .copyWith(
                                                    color: AppColors.white,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 14,
                                                    fontFamily:
                                                        'SFCOMPACTDISPLAY'),
                                          ),
                                          const VerticalSpacing(10),
                                          Text(
                                            'Duration',
                                            style: context.textTheme.bodySmall!
                                                .copyWith(
                                                    color: AppColors.white,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 12,
                                                    fontFamily:
                                                        'SFCOMPACTDISPLAY'),
                                          )
                                        ],
                                      ),

                                      ///trip distance in kilometer
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.location_pin,
                                            color: AppColors.yellow,
                                            size: 20,
                                          ),
                                          const VerticalSpacing(10),

                                          ///distance
                                          Text(
                                            rideDetails.distance ?? '',
                                            style: context.textTheme.bodySmall!
                                                .copyWith(
                                                    color: AppColors.white,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 14,
                                                    fontFamily:
                                                        'SFCOMPACTDISPLAY'),
                                          ),
                                          const VerticalSpacing(10),
                                          Text(
                                            'Distance',
                                            style: context.textTheme.bodySmall!
                                                .copyWith(
                                                    color: AppColors.white,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 12,
                                                    fontFamily:
                                                        'SFCOMPACTDISPLAY'),
                                          )
                                        ],
                                      ),

                                      ///trip fare
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.money_rounded,
                                            color: AppColors.yellow,
                                            size: 20,
                                          ),
                                          const VerticalSpacing(10),
                                          CurrencyWidget(
                                            price:
                                                rideDetails.tripCost!.toInt(),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: AppColors.white,
                                          ),
                                          const VerticalSpacing(10),
                                          Text(
                                            'Trip Fee',
                                            style: context.textTheme.bodySmall!
                                                .copyWith(
                                                    color: AppColors.white,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 12,
                                                    fontFamily:
                                                        'SFCOMPACTDISPLAY'),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                ///rating bar
                                Container(
                                  margin: const EdgeInsets.only(bottom: 20),
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    color: AppColors.black,
                                    borderRadius: BorderRadius.circular(6.r),
                                    border: Border.all(
                                      color: AppColors
                                          .white, // Specify your border color here
                                      width: 1, // Specify the border width
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      ///rating text
                                      Text(
                                        'How would you rate your passenger',
                                        style: context.textTheme.bodySmall!
                                            .copyWith(
                                                color: AppColors.white,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 14,
                                                fontFamily: 'SFCOMPACTDISPLAY'),
                                      ),
                                      const VerticalSpacing(10),
                                      Center(
                                        child: RatingBar.builder(
                                            initialRating:
                                                driverProvider.userRate ?? 0.0,
                                            itemSize: 50,
                                            maxRating: 5,
                                            minRating: 1,
                                            direction: Axis.horizontal,
                                            allowHalfRating: true,
                                            glowColor: AppColors.yellow,
                                            unratedColor: AppColors.grey,
                                            itemBuilder: (context, _) => Icon(
                                                  Icons.star,
                                                  size: 35.w,
                                                  color: AppColors.yellow,
                                                ),
                                            onRatingUpdate: (rating) {
                                              driverProvider
                                                  .setDriverRating(rating);
                                            }),
                                      ),
                                    ],
                                  ),
                                ),

                                ///submit button
                                AppElevatedButton.large(
                                  onPressed: () async {
                                    final docId = authProvider.id;
                                    const docModel = 'driver';
                                    final double rating =
                                        driverProvider.userRate ?? 0.0;
                                    const comment = ' ride was great';
                                    final token = authProvider.token;
                                    print(
                                        'this is calling the rating function');
                                    print('this is docId $docId');
                                    print('this is docModel $docModel');
                                    print('this is rating $rating');
                                    print('this is comment $comment');
                                    print('this is token $token');
                                    driverProvider.userRating(docId!, docModel,
                                        rating.toString(), comment, token!);
                                    setState(() {
                                      rideDetails.resetApp(imageConfiguration);
                                    });
                                    Future.delayed(1.s,
                                        () => context.push(const HomeScreen()));
                                  },
                                  text: 'Submit',
                                ),
                              ],
                            ),
                          ))
                      : const SizedBox(),
        ],
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