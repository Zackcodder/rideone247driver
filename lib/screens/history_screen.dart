import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ride_on_driver/core/extensions/build_context_extensions.dart';
import 'package:ride_on_driver/core/extensions/widget_extensions.dart';
import 'package:ride_on_driver/model/rides_histories_model.dart';
import 'package:ride_on_driver/provider/driver_provider.dart';
import 'package:ride_on_driver/screens/ride_histories_detials_screen.dart';

import '../core/constants/assets.dart';
import '../core/constants/colors.dart';
import '../core/painters_clippers/vertical_dot_line.dart';
import '../provider/authprovider.dart';
import '../widgets/currency_widget.dart';
import '../widgets/spacing.dart';

class RideHistoriesScreen extends StatefulWidget {
  static String id = 'ride_histories';
  const RideHistoriesScreen({Key? key}) : super(key: key);

  @override
  State<RideHistoriesScreen> createState() => _RideHistoriesScreenState();
}

class _RideHistoriesScreenState extends State<RideHistoriesScreen> {
  Color container1Color = AppColors.black;
  Color container2Color = AppColors.white;
  Color container3Color = AppColors.white;
  bool ride = true;
  bool completed = false;
  bool rejected = false;

  late AuthProvider _authProvider;
  @override
  void initState() {
    super.initState();
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    Provider.of<DriverProvider>(context, listen: false)
        .fetchRideHistory(_authProvider.token!);
  }

  @override
  Widget build(BuildContext context) {
    DriverProvider rideHistory = Provider.of<DriverProvider>(context);

    // rideHistory.allRideHistory!.length;
    // RidesHistories rides =
    // rideHistory.allRideHistory!.length as RidesHistories;
    return Scaffold(
      appBar: AppBar(
        title: Text('Ride History',
            style: context.textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                fontFamily: 'SFPRODISPLAYREGULAR')),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      backgroundColor: AppColors.lightGrey,
      body: SafeArea(
        child: Container(
          ///background image
          decoration:  const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Assets.assetsImagesPatternBackground),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Divider(
                color: AppColors.grey.withOpacity(0.7),
              ),

              /// selection container
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ///ALL
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        container1Color = AppColors.black;
                        container2Color = AppColors.white;
                        container3Color = AppColors.white;
                        ride = true;
                        completed = false;
                        rejected = false;
                      });
                    },
                    child: Container(
                      width: 90,
                      height: 38,
                      decoration: BoxDecoration(
                        color: container1Color,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.grey,
                          width: 1.0,
                        ),
                      ),
                      child:  Center(
                        child: Text(
                          'ALL',
                          style: context.textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w400,
                            fontSize: 12,
                              color:  ride == true ? AppColors.yellow : AppColors.black,
                            fontFamily: 'SFPRODISPLAYREGULAR')
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  ///COMPLETED
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        container1Color = AppColors.white;
                        container2Color = AppColors.black;
                        container3Color = AppColors.white;
                        ride = false;
                        completed = true;
                        rejected = false;
                      });
                    },
                    child: Container(
                      width: 90,
                      height: 38,
                      decoration: BoxDecoration(
                        color: container2Color,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.grey,
                          width: 1.0,
                        ),
                      ),
                      child:  Center(
                        child: Text(
                          'COMPLETED',
                            style: context.textTheme.bodyMedium!.copyWith(
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                color:  completed == true ? AppColors.yellow : AppColors.black,
                                fontFamily: 'SFPRODISPLAYREGULAR')
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  ///CANCELLED
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        container1Color = AppColors.white;
                        container2Color = AppColors.white;
                        container3Color = AppColors.black;
                        ride = false;
                        completed = false;
                        rejected = true;
                      });
                    },
                    child: Container(
                      width: 90,
                      height: 38,
                      decoration: BoxDecoration(
                        color: container3Color,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.grey,
                          width: 1.0,
                        ),
                      ),
                      child:  Center(
                        child: Text(
                          'CANCELLED',
                            style: context.textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color:  rejected == true ? AppColors.yellow : AppColors.black,
                            fontFamily: 'SFPRODISPLAYREGULAR')
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const VerticalSpacing(20),
              ride == true && completed == false && rejected == false
                  ?

              ///All
              Builder(builder: (context) {
                return rideHistory.allRideHistory == null
                    ? const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    VerticalSpacing(150),
                    CircularProgressIndicator(),
                  ],
                )
                    : rideHistory.allRideHistory!.isEmpty
                    ? const SizedBox(
                  child: Column(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: [
                      // Image.asset(
                      //     Assets.assetsImagesNothingtosee),
                      VerticalSpacing(10),
                      Text(
                        'Select a category to view history',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ).expand()
                    : ListView.builder(
                  padding: EdgeInsets.symmetric(
                      horizontal: 20.w, vertical: 70.w),
                  physics: const BouncingScrollPhysics(),
                  itemCount:
                  rideHistory.allRideHistory!.length,
                  itemBuilder: (context, index) {
                    RidesHistories rides =
                    rideHistory.allRideHistory![index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  RidesHistoriesDetailsScreen(rides)),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                          BorderRadius.circular(10.r),
                        ),
                        padding: EdgeInsets.all(15.w),
                        margin: EdgeInsets.symmetric(
                            vertical: 5.h),
                        child: IntrinsicHeight(
                          child: Row(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// pickup and destination icon
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    color: AppColors.black,
                                    size: 20.w,
                                  ),
                                  CustomPaint(
                                    size: Size(1, 60.h),
                                    painter: const DashedLineVerticalPainter(
                                      color: AppColors.black,
                                    ),
                                  ),
                                  Icon(
                                    Icons.send_outlined,
                                    // Icons.electric_bike,
                                    color: AppColors.black,
                                    size: 20.w,
                                  ).rotate(-0.6),
                                ],
                              ),
                              const HorizontalSpacing(10),

                              /// pickup location and destination name and date
                              Column(
                                crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                                mainAxisAlignment:
                                MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Text(
                                    rides.pickUpName ?? 'sss',
                                    style: context.textTheme
                                        .bodyMedium,
                                        // !.copyWith(
                                        // fontFamily:
                                        // 'SFPRODISPLAYREGULAR',
                                        // fontWeight:
                                        // FontWeight
                                        //     .w400,
                                        // color: AppColors
                                        //     .black),
                                  ),
                                  const VerticalSpacing(10),
                                  Text(
                                    rides.dropOffName,
                                    style: context.textTheme
                                        .bodyMedium,
                                  ),
                                  Text(
                                    rides.createdAt
                                        .toString(),
                                    // '20 Dec 2024. 10:20am',
                                    style: context.textTheme
                                        .bodySmall!
                                        .copyWith(
                                        fontFamily:
                                        'SFPRODISPLAYREGULAR',
                                        fontWeight:
                                        FontWeight
                                            .w400,
                                        color: AppColors
                                            .black),
                                  ),
                                ],
                              ).expand(),
                              const HorizontalSpacing(10),
                              ///price and status
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  CurrencyWidget(
                                    price: rides.fare ?? 0,
                                    color: AppColors.black,
                                    fontWeight:
                                    FontWeight.w500,
                                  ),
                                  VerticalSpacing(30),
                                  ///status
                            Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: AppColors.white,
                                      border: Border.all(
                                        color: rides.status == 'ended' ? AppColors.red : AppColors.yellow,
                                        width: 1.0,
                                      ),
                                    ),
                                    child:  Center(
                                      child: Text(
                                          rides.status,
                                          style: context.textTheme.bodyMedium!.copyWith(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12,
                                              color:  rides.status == 'ended' ? AppColors.red :AppColors.green,
                                              fontFamily: 'SFPRODISPLAYREGULAR')
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ).expand();
              })
                  : ride == false && completed == true && rejected == false
                  ?

              ///  completed
              Builder(builder: (context) {
                return rideHistory.allRideHistory == null
                    ? const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    VerticalSpacing(150),
                    CircularProgressIndicator(),
                  ],
                )
                    : rideHistory.allRideHistory!.isEmpty
                    ? const SizedBox(
                  child: Column(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: [
                      // Image.asset(
                      //     Assets.assetsImagesNothingtosee),
                      VerticalSpacing(10),
                      Text(
                        'Select a category to view history',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ).expand()
                    : ListView.builder(
                  padding: EdgeInsets.symmetric(
                      horizontal: 20.w, vertical: 60.w),
                  physics: const BouncingScrollPhysics(),
                  itemCount:
                  rideHistory.allRideHistory!.length,
                  itemBuilder: (context, index) {
                    RidesHistories rides =
                    rideHistory.allRideHistory![index];
                    return
                      rides.status == 'accepted' ? GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    RidesHistoriesDetailsScreen(rides)),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                            BorderRadius.circular(10.r),
                          ),
                          padding: EdgeInsets.all(15.w),
                          margin: EdgeInsets.symmetric(
                              vertical: 5.h),
                          child: IntrinsicHeight(
                            child: Row(
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// pickup and destination icon
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      color: AppColors.black,
                                      size: 20.w,
                                    ),
                                    CustomPaint(
                                      size: Size(1, 60.h),
                                      painter: const DashedLineVerticalPainter(
                                        color: AppColors.black,
                                      ),
                                    ),
                                    Icon(
                                      Icons.send_outlined,
                                      // Icons.electric_bike,
                                      color: AppColors.black,
                                      size: 20.w,
                                    ).rotate(-0.6),
                                  ],
                                ),
                                const HorizontalSpacing(10),

                                /// pickup location and destination name and date
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                                  mainAxisAlignment:
                                  MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    Text(
                                      rides.pickUpName ?? 'sss',
                                      style: context.textTheme
                                          .bodyMedium,
                                      // !.copyWith(
                                      // fontFamily:
                                      // 'SFPRODISPLAYREGULAR',
                                      // fontWeight:
                                      // FontWeight
                                      //     .w400,
                                      // color: AppColors
                                      //     .black),
                                    ),
                                    const VerticalSpacing(10),
                                    Text(
                                      rides.dropOffName,
                                      style: context.textTheme
                                          .bodyMedium,
                                    ),
                                    Text(
                                      rides.createdAt
                                          .toString(),
                                      // '20 Dec 2024. 10:20am',
                                      style: context.textTheme
                                          .bodySmall!
                                          .copyWith(
                                          fontFamily:
                                          'SFPRODISPLAYREGULAR',
                                          fontWeight:
                                          FontWeight
                                              .w400,
                                          color: AppColors
                                              .black),
                                    ),
                                  ],
                                ).expand(),
                                const HorizontalSpacing(10),
                                ///price and status
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    CurrencyWidget(
                                      price: rides.fare ?? 0,
                                      color: AppColors.black,
                                      fontWeight:
                                      FontWeight.w500,
                                    ),
                                    VerticalSpacing(30),
                                    ///status
                                    Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: AppColors.white,
                                        border: Border.all(
                                          color: rides.status == 'ended' ? AppColors.red : AppColors.yellow,
                                          width: 1.0,
                                        ),
                                      ),
                                      child:  Center(
                                        child: Text(
                                            rides.status,
                                            style: context.textTheme.bodyMedium!.copyWith(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12,
                                                color:  rides.status == 'ended' ? AppColors.red :AppColors.green,
                                                fontFamily: 'SFPRODISPLAYREGULAR')
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ) : SizedBox();
                  },
                ).expand();
              })
                  : ride == false && completed == false && rejected == true
                  ?

              ///  rejected history
              Builder(builder: (context) {
                return rideHistory.allRideHistory == null
                    ? const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    VerticalSpacing(150),
                    CircularProgressIndicator(),
                  ],
                )
                    : rideHistory.allRideHistory!.isEmpty
                    ? const SizedBox(
                  child: Column(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: [
                      // Image.asset(
                      //     Assets.assetsImagesNothingtosee),
                      VerticalSpacing(10),
                      Text(
                        'Select a category to view history',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ).expand()
                    : ListView.builder(
                  padding: EdgeInsets.symmetric(
                      horizontal: 20.w,vertical: 60.w),
                  physics: const BouncingScrollPhysics(),
                  itemCount:
                  rideHistory.allRideHistory!.length,
                  itemBuilder: (context, index) {
                    RidesHistories rides =
                    rideHistory.allRideHistory![index];
                    return
                      rides.status == 'transit' ? GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    RidesHistoriesDetailsScreen(rides)),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                            BorderRadius.circular(10.r),
                          ),
                          padding: EdgeInsets.all(15.w),
                          margin: EdgeInsets.symmetric(
                              vertical: 5.h),
                          child: IntrinsicHeight(
                            child: Row(
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// pickup and destination icon
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      color: AppColors.black,
                                      size: 20.w,
                                    ),
                                    CustomPaint(
                                      size: Size(1, 60.h),
                                      painter: const DashedLineVerticalPainter(
                                        color: AppColors.black,
                                      ),
                                    ),
                                    Icon(
                                      Icons.send_outlined,
                                      // Icons.electric_bike,
                                      color: AppColors.black,
                                      size: 20.w,
                                    ).rotate(-0.6),
                                  ],
                                ),
                                const HorizontalSpacing(10),

                                /// pickup location and destination name and date
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                                  mainAxisAlignment:
                                  MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    Text(
                                      rides.pickUpName ?? 'sss',
                                      style: context.textTheme
                                          .bodyMedium,
                                      // !.copyWith(
                                      // fontFamily:
                                      // 'SFPRODISPLAYREGULAR',
                                      // fontWeight:
                                      // FontWeight
                                      //     .w400,
                                      // color: AppColors
                                      //     .black),
                                    ),
                                    const VerticalSpacing(10),
                                    Text(
                                      rides.dropOffName,
                                      style: context.textTheme
                                          .bodyMedium,
                                    ),
                                    Text(
                                      rides.createdAt
                                          .toString(),
                                      // '20 Dec 2024. 10:20am',
                                      style: context.textTheme
                                          .bodySmall!
                                          .copyWith(
                                          fontFamily:
                                          'SFPRODISPLAYREGULAR',
                                          fontWeight:
                                          FontWeight
                                              .w400,
                                          color: AppColors
                                              .black),
                                    ),
                                  ],
                                ).expand(),
                                const HorizontalSpacing(10),
                                ///price and status
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    CurrencyWidget(
                                      price: rides.fare ?? 0,
                                      color: AppColors.black,
                                      fontWeight:
                                      FontWeight.w500,
                                    ),
                                    VerticalSpacing(30),
                                    ///status
                                    Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: AppColors.white,
                                        border: Border.all(
                                          color: rides.status == 'ended' ? AppColors.red : AppColors.yellow,
                                          width: 1.0,
                                        ),
                                      ),
                                      child:  Center(
                                        child: Text(
                                            rides.status,
                                            style: context.textTheme.bodyMedium!.copyWith(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12,
                                                color:  rides.status == 'ended' ? AppColors.red :AppColors.green,
                                                fontFamily: 'SFPRODISPLAYREGULAR')
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ) : SizedBox();
                  },
                ).expand();
              })
                  : const SizedBox().expand(),
            ],
          ),
        ),
      ),
    );
  }
}
