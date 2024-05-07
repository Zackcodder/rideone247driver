import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ride_on_driver/core/extensions/build_context_extensions.dart';
import 'package:ride_on_driver/core/extensions/widget_extensions.dart';

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

              ///all
              Builder(builder: (context) {
                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  physics: const BouncingScrollPhysics(),
                  itemCount: 9,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: (){},
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            padding: EdgeInsets.all(15.w),
                            margin: EdgeInsets.symmetric(vertical: 5.h),
                            child: IntrinsicHeight(
                              child: Row(
                                children: [
                                  /// pickup and destination icon
                                  Column(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        color: AppColors.black,
                                        size: 20.w,
                                      ),
                                      const Spacer(),
                                      // CustomPaint(
                                      //   size: Size(1, 60.h),
                                      //   painter: const DashedLineVerticalPainter(
                                      //     color: AppColors.black,
                                      //   ),
                                      // ),
                                      Icon(
                                        Icons.send_outlined,
                                        // Icons.electric_bike,
                                        color: AppColors.black,
                                        size: 20.w,
                                      ).rotate(-0.6),
                                    ],
                                  ),
                                  const HorizontalSpacing(10),

                                  /// pickup and destination names and time n date
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '11, Shai Hulud Crescent, Ikeja.',
                                        style: context.textTheme.bodyMedium,
                                      ),
                                        const VerticalSpacing(10),
                                      Text(
                                        'ShopRite Event Center, Ikeja.',
                                        style: context.textTheme.bodyMedium,
                                      ),
                                      Text(
                                        '29 May, 2024  10:00am',
                                        style: context.textTheme.bodySmall,
                                      ),

                                    ],
                                  ).expand(),
                                  const HorizontalSpacing(10),

                                  /// price
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      const CurrencyWidget(
                                        price: 1500,
                                        // model.cost,
                                        color: AppColors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                      const Spacer(),
                                      Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          color: AppColors.white,
                                          border: Border.all(
                                            color: AppColors.yellow,
                                            width: 1.0,
                                          ),
                                        ),
                                        child:  Center(
                                          child: Text(
                                              'COMPLETED',
                                              style: context.textTheme.bodyMedium!.copyWith(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 12,
                                                  color:  AppColors.green,
                                                  fontFamily: 'SFPRODISPLAYREGULAR')
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Column(
                                  //   crossAxisAlignment: CrossAxisAlignment.end,
                                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  //   children: [
                                  //     Text(
                                  //       model.date,
                                  //       style: context.textTheme.bodySmall,
                                  //     ),
                                  //     const VerticalSpacing(5),
                                  //     Row(
                                  //       mainAxisSize: MainAxisSize.min,
                                  //       children: List.generate(
                                  //         5,
                                  //         (index) => Icon(
                                  //           Icons.star,
                                  //           color: index < model.rating ? AppColors.yellow : AppColors.grey,
                                  //           size: 15.w,
                                  //         ),
                                  //       ),
                                  //     ),
                                  //     SizedBox(
                                  //       width: 50.w,
                                  //       height: 20.h,
                                  //       child: Align(
                                  //         alignment: Alignment.centerRight,
                                  //         child: CurrencyWidget(price: model.cost, color: AppColors.grey),
                                  //       ),
                                  //     ),
                                  //   ],
                                  // )
                                ],
                              ),
                            ),
                          ),
                          Divider(color: AppColors.grey.withOpacity(0.3),)
                        ],
                      ),
                    );
                  },
                ).expand();
              })
                  : ride == false && completed == true && rejected == false
                  ?

              ///  completed
              Builder(builder: (context) {
                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  physics: const BouncingScrollPhysics(),
                  itemCount: 9,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: (){},
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        padding: EdgeInsets.all(15.w),
                        margin: EdgeInsets.symmetric(vertical: 5.h),
                        child: IntrinsicHeight(
                          child: Row(
                            children: [
                              /// pickup and destination icon
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    color: AppColors.black,
                                    size: 20.w,
                                  ),
                                  CustomPaint(
                                    size: Size(1, 30.h),
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

                              /// pickup and destination names and time n date
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '11, Shai Hulud Crescent, Ikeja',
                                    style: context.textTheme.bodyMedium,
                                  ),
                                  const VerticalSpacing(10),
                                  Text(
                                    'ShopRite Event Center, Ikeja',
                                    style: context.textTheme.bodyMedium,
                                  ),
                                  Text(
                                    '29 May, 2024  10:00am',
                                    style: context.textTheme.bodySmall,
                                  ),

                                ],
                              ).expand(),
                              const HorizontalSpacing(10),

                              /// price
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const CurrencyWidget(
                                    price: 1500,
                                    // model.cost,
                                    color: AppColors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: AppColors.white,
                                      border: Border.all(
                                        color: AppColors.yellow,
                                        width: 1.0,
                                      ),
                                    ),
                                    child:  Center(
                                      child: Text(
                                          'COMPLETED',
                                          style: context.textTheme.bodyMedium!.copyWith(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12,
                                              color:  AppColors.green,
                                              fontFamily: 'SFPRODISPLAYREGULAR')
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // Column(
                              //   crossAxisAlignment: CrossAxisAlignment.end,
                              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //   children: [
                              //     Text(
                              //       model.date,
                              //       style: context.textTheme.bodySmall,
                              //     ),
                              //     const VerticalSpacing(5),
                              //     Row(
                              //       mainAxisSize: MainAxisSize.min,
                              //       children: List.generate(
                              //         5,
                              //         (index) => Icon(
                              //           Icons.star,
                              //           color: index < model.rating ? AppColors.yellow : AppColors.grey,
                              //           size: 15.w,
                              //         ),
                              //       ),
                              //     ),
                              //     SizedBox(
                              //       width: 50.w,
                              //       height: 20.h,
                              //       child: Align(
                              //         alignment: Alignment.centerRight,
                              //         child: CurrencyWidget(price: model.cost, color: AppColors.grey),
                              //       ),
                              //     ),
                              //   ],
                              // )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ).expand();
              })
                  : ride == false && completed == false && rejected == true
                  ?

              ///  rejected history
              Builder(builder: (context) {
                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  physics: const BouncingScrollPhysics(),
                  itemCount: 9,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: (){},
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        padding: EdgeInsets.all(15.w),
                        margin: EdgeInsets.symmetric(vertical: 5.h),
                        child: IntrinsicHeight(
                          child: Row(
                            children: [
                              /// pickup and destination icon
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    color: AppColors.black,
                                    size: 20.w,
                                  ),
                                  CustomPaint(
                                    size: Size(1, 30.h),
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

                              /// pickup and destination names and time n date
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '11, Shai Hulud Crescent, Ikeja',
                                    style: context.textTheme.bodyMedium,
                                  ),
                                  const VerticalSpacing(10),
                                  Text(
                                    'ShopRite Event Center, Ikeja',
                                    style: context.textTheme.bodyMedium,
                                  ),
                                  Text(
                                    '29 May, 2024  10:00am',
                                    style: context.textTheme.bodySmall,
                                  ),

                                ],
                              ).expand(),
                              const HorizontalSpacing(10),

                              /// price
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const CurrencyWidget(
                                    price: 1500,
                                    // model.cost,
                                    color: AppColors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: AppColors.white,
                                      border: Border.all(
                                        color: AppColors.red,
                                        width: 1.0,
                                      ),
                                    ),
                                    child:  Center(
                                      child: Text(
                                          'CANCELLED',
                                          style: context.textTheme.bodyMedium!.copyWith(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12,
                                              color:  AppColors.red,
                                              fontFamily: 'SFPRODISPLAYREGULAR')
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // Column(
                              //   crossAxisAlignment: CrossAxisAlignment.end,
                              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //   children: [
                              //     Text(
                              //       model.date,
                              //       style: context.textTheme.bodySmall,
                              //     ),
                              //     const VerticalSpacing(5),
                              //     Row(
                              //       mainAxisSize: MainAxisSize.min,
                              //       children: List.generate(
                              //         5,
                              //         (index) => Icon(
                              //           Icons.star,
                              //           color: index < model.rating ? AppColors.yellow : AppColors.grey,
                              //           size: 15.w,
                              //         ),
                              //       ),
                              //     ),
                              //     SizedBox(
                              //       width: 50.w,
                              //       height: 20.h,
                              //       child: Align(
                              //         alignment: Alignment.centerRight,
                              //         child: CurrencyWidget(price: model.cost, color: AppColors.grey),
                              //       ),
                              //     ),
                              //   ],
                              // )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ).expand();
              })
                  : const SizedBox(
                // child: Column(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Image.asset(Assets.assetsImagesNothingtosee),
                //     const VerticalSpacing(10),
                //     const Text(
                //       'Select a category to view history',
                //       textAlign: TextAlign.center,
                //     ),
                //   ],
                // ),
              ).expand(),
            ],
          ),
        ),
      ),
    );
  }
}
