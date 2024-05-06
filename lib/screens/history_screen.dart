import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ride_on_driver/core/extensions/build_context_extensions.dart';
import 'package:ride_on_driver/core/extensions/widget_extensions.dart';

import '../core/constants/assets.dart';
import '../core/constants/colors.dart';
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
    // Provider.of<AuthProvider>(context, listen: false) .fetchRideHistory(_authProvider.token!);
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider rideHistory = Provider.of<AuthProvider>(context);
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
          // decoration:  BoxDecoration(
          //   image: DecorationImage(
          //     image: AssetImage(Assets.assetsImagesPatternBackground),
          //     fit: BoxFit.cover,
          //   ),
          // ),
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

                  ///REJECTED
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
                          'REJECTED',
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
              // ride == true && completed == false && rejected == false
              //     ?

              // ///ride history
              // Builder(builder: (context) {
              //   return TripListViewer(
              //     onCardTap: () {
              //       // Navigator.push(
              //       //   context,
              //       //   MaterialPageRoute(builder: (context) => const TripDetailsScreen()),
              //       // );
              //     },
              //   ).expand();
              // })
              //     : ride == false && completed == true && rejected == false
              //     ?
              //
              // ///  food and general delivery history
              // Builder(builder: (context) {
              //   return rideHistory.allRideHistory == null
              //       ? const Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       VerticalSpacing(150),
              //       CircularProgressIndicator(),
              //     ],
              //   )
              //       : rideHistory.allRideHistory!.isEmpty
              //       ? SizedBox(
              //     child: Column(
              //       mainAxisAlignment:
              //       MainAxisAlignment.center,
              //       children: [
              //         Image.asset(
              //             Assets.assetsImagesNothingtosee),
              //         const VerticalSpacing(10),
              //         const Text(
              //           'Select a category to view history',
              //           textAlign: TextAlign.center,
              //         ),
              //       ],
              //     ),
              //   ).expand()
              //       : ListView.builder(
              //     padding: EdgeInsets.symmetric(
              //         horizontal: 20.w),
              //     physics: const BouncingScrollPhysics(),
              //     itemCount:
              //     rideHistory.allRideHistory!.length,
              //     itemBuilder: (context, index) {
              //       Trips rides =
              //       rideHistory.allRideHistory![index];
              //       return GestureDetector(
              //         onTap: () {
              //           Navigator.push(
              //             context,
              //             MaterialPageRoute(
              //                 builder: (context) =>
              //                     TripDetailsScreen(rides)),
              //           );
              //         },
              //         child: Container(
              //           decoration: BoxDecoration(
              //             color: Colors.white,
              //             borderRadius:
              //             BorderRadius.circular(10.r),
              //           ),
              //           padding: EdgeInsets.all(15.w),
              //           margin: EdgeInsets.symmetric(
              //               vertical: 5.h),
              //           child: IntrinsicHeight(
              //             child: Row(
              //               children: [
              //                 /// pickup and destination icon
              //                 Column(
              //                   mainAxisAlignment:
              //                   MainAxisAlignment
              //                       .center,
              //                   children: [
              //                     Icon(
              //                       Icons.location_on,
              //                       color: AppColors.black,
              //                       size: 20.w,
              //                     ),
              //                     CustomPaint(
              //                       size: Size(1, 30.h),
              //                       painter:
              //                       const DashedLineVerticalPainter(
              //                         color:
              //                         AppColors.black,
              //                       ),
              //                     ),
              //                     Icon(
              //                       Icons.electric_bike,
              //                       color: AppColors.black,
              //                       size: 20.w,
              //                     ),
              //                   ],
              //                 ),
              //                 const HorizontalSpacing(10),
              //
              //                 /// pickup location and destination name and date
              //                 Column(
              //                   crossAxisAlignment:
              //                   CrossAxisAlignment
              //                       .start,
              //                   mainAxisAlignment:
              //                   MainAxisAlignment
              //                       .spaceBetween,
              //                   children: [
              //                     Text(
              //                       '11, Shai Hulud Crescent, Ikeja.',
              //                       style: context.textTheme
              //                           .bodyMedium,
              //                     ),
              //                     const VerticalSpacing(10),
              //                     Text(
              //                       'Stadplus Event Center, Ikeja',
              //                       style: context.textTheme
              //                           .bodyMedium,
              //                     ),
              //                     Text(
              //                       rides.createdAt
              //                           .toString(),
              //                       // '20 Dec 2024. 10:20am',
              //                       style: context.textTheme
              //                           .bodySmall!
              //                           .copyWith(
              //                           fontFamily:
              //                           'SFPRODISPLAYREGULAR',
              //                           fontWeight:
              //                           FontWeight
              //                               .w400,
              //                           color: AppColors
              //                               .black),
              //                     ),
              //                   ],
              //                 ).expand(),
              //                 const HorizontalSpacing(10),
              //                 SizedBox(
              //                   width: 50.w,
              //                   height: 20.h,
              //                   child: Align(
              //                     alignment:
              //                     Alignment.centerRight,
              //                     child: CurrencyWidget(
              //                       price: rides.fare ?? 0,
              //                       color: AppColors.black,
              //                       fontWeight:
              //                       FontWeight.w500,
              //                     ),
              //                   ),
              //                 )
              //               ],
              //             ),
              //           ),
              //         ),
              //       );
              //     },
              //   ).expand();
              // })
              //     : ride == false && delivery == false && groceries == true
              //     ?
              //
              // ///  groceries history
              // Builder(builder: (context) {
              //   return ListView.builder(
              //     padding:
              //     const EdgeInsets.symmetric(horizontal: 10),
              //     itemCount: cartItemList.length,
              //     itemBuilder: (_, index) {
              //       final model = cartItemList[index];
              //       return OrderItemCard(model: model);
              //     },
              //   ).expand();
              // })
              //     : SizedBox(
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Image.asset(Assets.assetsImagesNothingtosee),
              //       const VerticalSpacing(10),
              //       const Text(
              //         'Select a category to view history',
              //         textAlign: TextAlign.center,
              //       ),
              //     ],
              //   ),
              // ).expand(),
            ],
          ),
        ),
      ),
    );
  }
}
