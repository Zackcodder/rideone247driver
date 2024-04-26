import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ride_on_driver/core/constants/colors.dart';
import 'package:ride_on_driver/core/extensions/build_context_extensions.dart';
import 'package:ride_on_driver/core/extensions/widget_extensions.dart';
import 'package:ride_on_driver/dummy_data/active_trips.dart';
import 'package:ride_on_driver/screens/home_screen.dart';
import 'package:ride_on_driver/screens/trip_completed.dart';
import 'package:ride_on_driver/widgets/app_elevated_button.dart';
import 'package:ride_on_driver/widgets/map_widget.dart';
import 'package:ride_on_driver/widgets/trip_card.dart';

import '../core/constants/assets.dart';
import '../core/painters_clippers/vertical_dot_line.dart';
import '../provider/ride_request_provider.dart';
import '../widgets/currency_widget.dart';
import '../widgets/icon_text_button.dart';
import '../widgets/spacing.dart';
import 'chat_screen.dart';

class TripsView extends StatefulWidget {
  const TripsView({super.key});

  @override
  State<TripsView> createState() => _TripsViewState();
}

class _TripsViewState extends State<TripsView> {
  late RideRequestProvider _rideRequestProvider;
  @override
  void initState() {
    super.initState();
    _rideRequestProvider =
        Provider.of<RideRequestProvider>(context, listen: false);
    _rideRequestProvider.listenForRideRequests();
  }
  bool _acceptRequest = false;
  bool _startTripRequest = false;

  @override
  Widget build(BuildContext context) {
    ImageConfiguration imageConfiguration = createLocalImageConfiguration(context, size: const Size(2, 2));
    final rideDetails =
        Provider.of<RideRequestProvider>(context, listen: false);
    return Stack(
      children: [
        const MapWidget(),

        ///new trip request
        Consumer<RideRequestProvider>(
          builder: (context, rideRequestProvider, child) {
            return rideRequestProvider.hasRideRequests &&
                    rideDetails.newTripRequest == true
                ? Positioned(
                    bottom: 130,
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

                                ///user name n trip infor
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
                                                    fontWeight:
                                                        FontWeight.bold)),
                                      ],
                                    ),
                                    Text(
                                        '${rideDetails.tripDistance} Kms away | ${rideDetails.etaTimer} mins',
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
                                            price:
                                                rideDetails.tripCost!.toInt(),
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
                : const SizedBox();
          },
        ),

        ///accepted trip screen
        Consumer<RideRequestProvider>(
          builder: (context, rideRequestProvider, child) {
            return rideRequestProvider.hasRideRequests &&
                rideDetails.newTripRequest == true
                ? Positioned(
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

                          const SizedBox(width: 15,),

                          ///user name n trip infor
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Row(
                                children: [
                                  Text(
                                    rideDetails.riderName ?? 'no name',
                                    style: context.textTheme.bodySmall!
                                        .copyWith(color: AppColors.white),
                                  ),
                                  const SizedBox(width: 15,),
                                  const Icon(
                                    Icons.star,
                                    color: AppColors.yellow,
                                    size: 15,
                                  ),
                                  Text('4.5',
                                      style: context.textTheme.bodySmall!
                                          .copyWith(
                                          color: AppColors.white,
                                          fontWeight:
                                          FontWeight.bold)),
                                ],
                              ),
                              Text(
                                  '${rideDetails.tripDistance} Kms away | ${rideDetails.etaTimer} mins',
                                  style: context.textTheme.bodySmall!
                                      .copyWith(color: AppColors.white)),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            onPressed: () {
                              context.push(const ChatScreen());
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
                      const SizedBox(height: 10,),

                      ///accept and reject trip button
                      _acceptRequest != true ?
                      AppElevatedButton.medium(
                        onPressed: () async {
                          setState(() {
                            _acceptRequest = true;
                          });
                        },
                        text: 'Arrived',
                        backgroundColor: AppColors.green,
                        foregroundColor: AppColors.white,
                      ).expand() :
                      _startTripRequest != true && _acceptRequest != true ?
                      /// start trip button
                      AppElevatedButton.large(
                        onPressed: ()  async{
                          setState(() {
                            rideDetails.displayDirectionForActivateTrip(imageConfiguration);
                            rideDetails.startRide(rideDetails.driverId ??'',rideDetails.acceptedTripId ??'',);
                            print('printing from the start trip button the driver id ${rideDetails.driverId}');
                            print('printing from the start trip button the trip id ${rideDetails.acceptedTripId}');
                            _startTripRequest =true;
                            _acceptRequest=true;
                          });
                          // rideDetails.displayDirectionsToPickup(imageConfiguration);
                          // Navigator.pushReplacement(
                          //   context,
                          //   MaterialPageRoute(builder: (context) => const HomeScreen()),
                          // );
                          // setState(() {});
                        },
                        text: 'Start Trip',
                      ).expand() :
                      ///end trip
                      AppElevatedButton.medium(
                        onPressed: () async {
                          rideDetails.endRiderTrip(
                              rideDetails.driverId ?? '', rideDetails.acceptedTripId ?? '');
                          print(
                              'printing from the end trip button the driver id ${rideDetails.driverId}');
                          print(
                              'printing from the end trip button the trip id ${rideDetails.acceptedTripId}');
                          context.push(const TripCompletedScreen());
                          isRideActiveNotifier.value = false;
                          rideDetails.resetApp();
                          setState(() {});
                        },
                        text: 'TAP TO COMPLETE',
                        icon: Icons.trending_flat_rounded,
                        backgroundColor: AppColors.black,
                        foregroundColor: AppColors.yellow,
                      ).expand(),
                    ],
                  ),
                ),
              ),
            )
                : const SizedBox();
          },
        ),

        ///
        // Positioned(
        //   bottom: 10,
        //   child: AppElevatedButton.medium(
        //     onPressed: () async {
        //       rideDetails.endRiderTrip(
        //           rideDetails.driverId ?? '', rideDetails.acceptedTripId ?? '');
        //       print(
        //           'printing from the end trip button the driver id ${rideDetails.driverId}');
        //       print(
        //           'printing from the end trip button the trip id ${rideDetails.acceptedTripId}');
        //       context.push(const TripCompletedScreen());
        //       isRideActiveNotifier.value = false;
        //       setState(() {});
        //     },
        //     text: 'TAP TO COMPLETE',
        //     icon: Icons.trending_flat_rounded,
        //     backgroundColor: AppColors.black,
        //     foregroundColor: AppColors.yellow,
        //   ).padAll(20.w),
        // ),
      ],
    );
  }
}
