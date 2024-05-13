import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker_widget/image_picker_widget.dart';
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
import 'package:ride_on_driver/screens/vehicle_dtails_screen.dart';
import 'package:ride_on_driver/widgets/currency_widget.dart';
import 'package:ride_on_driver/widgets/spacing.dart';
import 'package:ride_on_driver/widgets/trip_list_viewer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider/driver_provider.dart';
import '../widgets/app_text_button.dart';

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
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    Provider.of<DriverProvider>(context, listen: false)
        .fetchDriverProfile(_authProvider.token!);
    loadDriverDataFromSharedPreference();
  }

  num? _walletBalance;
  String? _driverName;
  String? _driverLastName;
  late AuthProvider _authProvider;
  loadDriverDataFromSharedPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _driverLastName = prefs.getString('driver_lastname');
      _driverName = prefs.getString('driver_name');
      _walletBalance = prefs.getInt('wallet_balance') as num;
    });
  }


  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    DriverProvider driverProfile = Provider.of<DriverProvider>(context);
    var wallet = authProvider.walletBalance;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.assetsImagesPatternBackground),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const VerticalSpacing(40),
              ///screen name
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  'Account Settings',
                  // 'Hello $_driverLastName $_driverName!',
                  style: context.textTheme.bodyLarge!
                      .copyWith(fontWeight: FontWeight.w500, fontSize: 14),
                ),
              ),
              Divider(
                color: AppColors.grey.withOpacity(0.7),
              ),
              const VerticalSpacing(10),

              /// driver details
              driverProfile == null && driverProfile.profileLoading == true ? CircularProgressIndicator() :Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(left: 20, right: 20),
                // height: 65.h,
                decoration: BoxDecoration(
                  borderRadius:
                  BorderRadius.circular(4.r), // Adjust the radius as needed
                  border: Border.all(
                    color: AppColors.grey, // Specify the border color here
                    width: 1.0, // Adjust the border width as needed
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ///name, car details, rating n ride done
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ///name and image
                        Column(
                          children: [
                            ///image
                            ImagePickerWidget(
                              backgroundColor: AppColors.lightGrey,
                              diameter: 60.r,
                              initialImage: AssetImage(
                                driverProfile.driverInformation!.profile!.driver!.avatar ??
                                    Assets.assetsImagesDriverProfile,),
                              iconAlignment: Alignment.bottomRight,
                              shape: ImagePickerWidgetShape.circle,
                              editIcon: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(50.r)),
                                ),
                                color: AppColors.yellow,
                                child: const Icon(Icons.edit, color: AppColors.black, size: 15,),
                              ),
                              isEditable: true,
                              shouldCrop: false,
                              imagePickerOptions: ImagePickerOptions(imageQuality: 65),
                              modalOptions: ModalOptions(
                                title: const Text(''),
                                cameraColor: AppColors.black,
                                cameraText: const Text('Camera'),
                                galleryColor: AppColors.black,
                                galleryText: const Text('Gallery'),
                              ),
                              onChange: (file) {},
                            ),

                            Text(
                               _driverLastName ??'',
                              style: context.textTheme.bodySmall!
                                  .copyWith(fontWeight: FontWeight.w500, fontSize: 14),
                            ),Text(
                              _driverName! ??'',
                              style: context.textTheme.bodySmall!
                                  .copyWith(fontWeight: FontWeight.w500, fontSize: 14),
                            ),
                          ],
                        ),

                        ///car details
                        Column(
                          children: [
                            Icon(Icons.car_repair, color: AppColors.black, size: 35,),
                            ///car color
                            Text(
                              driverProfile.driverInformation!.profile!.vehicleDetails!.color ?? '' ,
                              style: context.textTheme.bodySmall!
                                  .copyWith(fontWeight: FontWeight.w500, fontSize: 12),
                            ),
                            ///car model
                            Text(
                              '${driverProfile.driverInformation!.profile!.vehicleDetails!.make }',
                              style: context.textTheme.bodySmall!
                                  .copyWith(fontWeight: FontWeight.w500, fontSize: 12),
                            ),
                            ///car model
                            Text(
                              '${driverProfile.driverInformation!.profile!.vehicleDetails!.model }',
                              style: context.textTheme.bodySmall!
                                  .copyWith(fontWeight: FontWeight.w500, fontSize: 12),
                            ),
                          ],
                        ),

                        ///ride complete
                        Column(
                          children: [
                            Icon(Icons.verified, color: AppColors.yellow, size: 35,),
                            ///rides complatred
                            Text(
                              driverProfile.driverInformation!.profile!.completedTrips.toString() ?? '' ,
                              style: context.textTheme.bodySmall!
                                  .copyWith(fontWeight: FontWeight.w500, fontSize: 12),
                            ),Text(
                              'Completed \n    Trips',
                              style: context.textTheme.bodySmall!
                                  .copyWith(fontWeight: FontWeight.w500, fontSize: 12),
                            ),
                          ],
                        ),

                        ///rating
                        Column(
                          children: [
                            Icon(Icons.star, color: AppColors.yellow, size: 35,),
                            Text(
                              driverProfile.driverInformation!.profile!.averageRating.toString() ?? '',
                              style: context.textTheme.bodySmall!
                                  .copyWith(fontWeight: FontWeight.w500, fontSize: 12),
                            ),Text(
                              'Rating',
                              style: context.textTheme.bodySmall!
                                  .copyWith(fontWeight: FontWeight.w500, fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const Divider(color: AppColors.grey,endIndent: 10, indent: 10,),

                    ///account balance
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(5),
                              margin: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(100.r), // Adjust the radius as needed
                                border: Border.all(
                                  color: AppColors.grey, // Specify the border color here
                                  width: 1.0, // Adjust the border width as needed
                                ),
                              ),
                              child: const Center(child: Icon(Icons.wallet, color: AppColors.yellow,) ,),
                            ),

                            ///account balance
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CurrencyWidget(price: driverProfile.driverInformation!.profile!.balance!.toDouble(), fontWeight: FontWeight.bold, fontSize: 14,),
                                Text(
                                  'Available balance',
                                  style: context.textTheme.bodySmall!
                                      .copyWith(fontWeight: FontWeight.w600, fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                        ///withdraw button
                        Container(
                          padding: const EdgeInsets.all(5),
                          height: 40.h,
                          decoration: BoxDecoration(
                            color: AppColors.black,
                            borderRadius:
                            BorderRadius.circular(4.r), // Adjust the radius as needed
                            border: Border.all(
                              color: AppColors.black, // Specify the border color here
                              width: 1.0, // Adjust the border width as needed
                            ),
                          ),
                          child: Center(
                            child: Text('WITHDRAW',
                              style: context.textTheme.bodySmall!
                                  .copyWith(fontWeight: FontWeight.w400, fontSize: 12, color: AppColors.yellow),),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              const VerticalSpacing(20),
              ListView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                children: [
                  ///user profile
                  ProfileScreenTile(
                    onTap: () {
                      context.push(const ProfileEditScreen());
                    },
                    leadingIcon: Assets.assetsSvgsUser,
                    text: 'Profile Information',
                  ),

                  ///vehicle Details
                  ProfileScreenTile(
                    leadingIcon: Assets.assetsSvgsHistory,
                    text: 'Vehicle Information',
                    onTap: () {
                      context.push(const VehicleDetailsScreen());
                    },
                  ),

                  ///wallet
                  ProfileScreenTile(
                    onTap: () {
                      // balanceProvider.userWalletBalance(_token!);
                      // context.push(const WalletScreen());
                    },
                    leadingIcon: Assets.assetsSvgsAccountWallet,
                    text: 'Wallet',
                  ),

                  ///security
                  ProfileScreenTile(
                    leadingIcon: Assets.assetsSvgsShield,
                    text: 'Security',
                    onTap: () {
                      // context.push(const SecurityScreen());
                    },
                  ),

                  ///notification
                  ProfileScreenTile(
                    leadingIcon: Assets.assetsSvgsNotification,
                    text: 'Notification',
                    onTap: () {},
                  ),

                  ///terms and conditions
                  ProfileScreenTile(
                    leadingIcon: Assets.assetsSvgsTerms,
                    text: 'Terms and Policy',
                    onTap: () {},
                  ),

                  ///About
                  ProfileScreenTile(
                    leadingIcon: Assets.assetsSvgsAbout,
                    text: 'About',
                    onTap: () {},
                  ),
                  const VerticalSpacing(10),

                  Divider(
                    color: AppColors.grey.withOpacity(0.7),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.logout,
                        color: AppColors.yellow,
                      ),
                      AppTextButton(
                          onPressed: () async {
                            final SharedPreferences sharedPreferences =
                            await SharedPreferences.getInstance();
                            sharedPreferences.setBool('autoLogin', false);
                            // Navigator.pushNamedAndRemoveUntil(context, LoginScreen(), (Route<dynamic> route) => false);
                            // context.pushReplacement(const AuthScreen());
                            // currentPageIndexNotifier.value = 0;
                          },
                          text: 'Logout')
                    ],
                  ),
                ],
              ).expand(),
              const VerticalSpacing(100)
            ],
          ),
        ),
      ),
    );
    //   Scaffold(
    //   body: SafeArea(
    //     child: Column(
    //       children: [
    //         const ClippedView(),
    //         Card(
    //           child: Row(
    //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //             children: [
    //               [
    //                 SvgPicture.asset(Assets.assetsSvgsEarnedToday),
    //                 Text(
    //                   'Earned Today',
    //                   style: context.textTheme.bodySmall,
    //                 ),
    //                 CurrencyWidget(price: authProvider.walletBalance ?? 0),
    //               ].toColumn(
    //                 crossAxisAlignment: CrossAxisAlignment.center,
    //               ),
    //               [
    //                 SvgPicture.asset(Assets.assetsSvgsYouOwn),
    //                 Text(
    //                   'You Owe',
    //                   style: context.textTheme.bodySmall,
    //                 ),
    //                 const CurrencyWidget(price: 0),
    //               ].toColumn(
    //                 crossAxisAlignment: CrossAxisAlignment.center,
    //               )
    //             ],
    //           ),
    //         ).padHorizontal(20.w),
    //         const VerticalSpacing(20),
    //         const TripListViewer().expand(),
    //       ],
    //     ),
    //   ),
    // );
  }
}

// class ClippedView extends StatefulWidget {
//   const ClippedView({super.key});
//
//   @override
//   State<ClippedView> createState() => _ClippedViewState();
// }
//
// class _ClippedViewState extends State<ClippedView> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     loadDriverDataFromSharedPreference();
//   }
//
//   String? _driverName;
//   String? _driverLastName;
//   loadDriverDataFromSharedPreference() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _driverLastName = prefs.getString('driver_lastname');
//       _driverName = prefs.getString('driver_name');
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final authProvider = Provider.of<AuthProvider>(context);
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage(Assets.assetsImagesPatternBackground),
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: SafeArea(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const VerticalSpacing(40),
//               // Row(
//               //   children: [
//               //     CircleAvatar(
//               //       radius: 40.r,
//               //       backgroundImage: const AssetImage(
//               //         Assets.assetsImagesDriverProfile,
//               //       ),
//               //     ),
//               //     const HorizontalSpacing(20),
//               //     Column(
//               //       crossAxisAlignment: CrossAxisAlignment.start,
//               //       children: [
//               //         Text(
//               //           '$_userLastName $_userName',
//               //           style: context.textTheme.bodyLarge,
//               //         ),
//               //         AppElevatedButton(
//               //           onPressed: () {
//               //             context.push(const EditProfileScreen());
//               //           },
//               //           text: 'Edit Profile',
//               //         ),
//               //       ],
//               //     ),
//               //   ],
//               // ).padOnly(left: 20),
//               ///user name
//               Text(
//                 'Hello $_driverLastName $_driverName!',
//                 style: context.textTheme.bodyLarge!
//                     .copyWith(fontWeight: FontWeight.w500, fontSize: 14),
//               ),
//               Divider(
//                 color: AppColors.grey.withOpacity(0.7),
//               ),
//               const VerticalSpacing(20),
//               ListView(
//                 padding: EdgeInsets.symmetric(horizontal: 20.w),
//                 children: [
//                   ///user profile
//                   ProfileScreenTile(
//                     onTap: () {
//                       context.push(const ProfileEditScreen());
//                     },
//                     leadingIcon: Assets.assetsSvgsUser,
//                     text: 'Profile Information',
//                   ),
//
//                   ///trip history
//                   ProfileScreenTile(
//                     leadingIcon: Assets.assetsSvgsHistory,
//                     text: 'Order Histories',
//                     onTap: () {
//                       // context.push(const TripHistoryScreen());
//                     },
//                   ),
//
//                   ///wallet
//                   ProfileScreenTile(
//                     onTap: () {
//                       // balanceProvider.userWalletBalance(_token!);
//                       // context.push(const WalletScreen());
//                     },
//                     leadingIcon: Assets.assetsSvgsAccountWallet,
//                     text: 'Wallet',
//                   ),
//
//                   ///security
//                   ProfileScreenTile(
//                     leadingIcon: Assets.assetsSvgsShield,
//                     text: 'Security',
//                     onTap: () {
//                       // context.push(const SecurityScreen());
//                     },
//                   ),
//
//                   ///notification
//                   ProfileScreenTile(
//                     leadingIcon: Assets.assetsSvgsNotification,
//                     text: 'Notification',
//                     onTap: () {},
//                   ),
//
//                   ///terms and conditions
//                   ProfileScreenTile(
//                     leadingIcon: Assets.assetsSvgsTerms,
//                     text: 'Terms and Policy',
//                     onTap: () {},
//                   ),
//
//                   ///about
//                   ProfileScreenTile(
//                     leadingIcon: Assets.assetsSvgsAbout,
//                     text: 'About',
//                     onTap: () {},
//                   ),
//                   const VerticalSpacing(10),
//
//                   Divider(
//                     color: AppColors.grey.withOpacity(0.7),
//                   ),
//
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Icon(
//                         Icons.logout,
//                         color: AppColors.yellow,
//                       ),
//                       AppTextButton(
//                           onPressed: () async {
//                             final SharedPreferences sharedPreferences =
//                             await SharedPreferences.getInstance();
//                             sharedPreferences.setBool('autoLogin', false);
//                             // Navigator.pushNamedAndRemoveUntil(context, LoginScreen(), (Route<dynamic> route) => false);
//                             // context.pushReplacement(const AuthScreen());
//                             // currentPageIndexNotifier.value = 0;
//                           },
//                           text: 'Logout')
//                     ],
//                   ),
//                 ],
//               ).expand(),
//               const VerticalSpacing(50)
//             ],
//           ),
//         ),
//       ),
//     );
//
//   }
// }
//

class ProfileScreenTile extends StatelessWidget {
  const ProfileScreenTile({
  super.key,
  required this.leadingIcon,
  required this.text,
  this.onTap,
  });
  final String leadingIcon;
  final String text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 5.h),
        child: Container(
          height: 65.h,
          decoration: BoxDecoration(
            borderRadius:
            BorderRadius.circular(4.r), // Adjust the radius as needed
            border: Border.all(
              color: AppColors.yellow, // Specify the border color here
              width: 1.0, // Adjust the border width as needed
            ),
          ),
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.r)),
            color: AppColors.white,
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
              dense: true,
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 12,
                color: AppColors.black,
                weight: 10.0,
              ),
              leading: SvgPicture.asset(
                leadingIcon,
                width: 35.w,
                height: 35.h,
                color: AppColors.black,
              ),
              title: Text(text,
                  style: context.textTheme.bodyMedium!
                      .copyWith(fontWeight: FontWeight.w400, fontSize: 14)),
              onTap: onTap,
            ),
          ),
        ));
  }
}



//   ClipPath(
//   clipper: ProfileClipper(),
//   child: Container(
//     height: 300.h,
//     color: AppColors.black,
//     child: Column(
//       children: [
//         const VerticalSpacing(20),
//         AppBar(
//           backgroundColor: AppColors.black,
//           title: Text(
//             'PROFILE',
//             style: context.textTheme.bodyMedium!.copyWith(
//               color: Colors.white,
//             ),
//           ),
//           leading: IconButton(
//             icon: const Icon(
//               Icons.arrow_back,
//               color: Colors.white,
//             ),
//             onPressed: context.pop,
//           ),
//           actions: [
//             IconButton(
//               onPressed: (){
//                 authProvider.logout(context);
//               },
//               //=> context.pushReplacement(const LoginScreen()),
//               icon: const Icon(
//                 Icons.logout,
//                 color: Colors.white,
//               ),
//             ),
//             const HorizontalSpacing(10),
//           ],
//         ),
//         const VerticalSpacing(20),
//         ListTile(
//           onTap: () {
//             context.push(const ProfileEditScreen());
//           },
//           contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
//           leading: Image.asset(Assets.assetsImagesDriverProfile)
//               .clip(radius: 100),
//           trailing: const Icon(
//             Icons.settings,
//             color: Colors.white,
//           ),
//           title: Text(
//             '$_driverName ',
//             style: context.textTheme.bodyMedium!.copyWith(
//               color: Colors.white,
//             ),
//           ),
//           subtitle: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 '134 Completed Trips',
//                 style: context.textTheme.bodySmall!.copyWith(
//                   color: Colors.white,
//                 ),
//               ),
//               Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: List.generate(
//                   5,
//                   (index) => Icon(
//                     Icons.star,
//                     color: index < 4 ? AppColors.yellow : AppColors.grey,
//                     size: 15.w,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         )
//       ],
//     ),
//   ),
// );