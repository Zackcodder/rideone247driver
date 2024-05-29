import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker_widget/image_picker_widget.dart';
import 'package:provider/provider.dart';
import 'package:ride_on_driver/core/constants/assets.dart';
import 'package:ride_on_driver/core/constants/colors.dart';
import 'package:ride_on_driver/core/extensions/build_context_extensions.dart';
import 'package:ride_on_driver/core/extensions/widget_extensions.dart';
import 'package:ride_on_driver/provider/authprovider.dart';
import 'package:ride_on_driver/screens/profile_edit_screen.dart';
import 'package:ride_on_driver/screens/security_screen.dart';
import 'package:ride_on_driver/screens/vehicle_details_screen.dart';
import 'package:ride_on_driver/screens/wallet_screen.dart';
import 'package:ride_on_driver/widgets/currency_widget.dart';
import 'package:ride_on_driver/widgets/spacing.dart';
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

  String? _driverName;
  String? _driverLastName;
  late AuthProvider _authProvider;
  loadDriverDataFromSharedPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _driverLastName = prefs.getString('driver_lastname');
      _driverName = prefs.getString('driver_name');
    });
  }


  @override
  Widget build(BuildContext context) {
    DriverProvider driverProfile = Provider.of<DriverProvider>(context);
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
                  style: context.textTheme.bodyLarge!
                      .copyWith(fontWeight: FontWeight.w500, fontSize: 14),
                ),
              ),
              Divider(
                color: AppColors.grey.withOpacity(0.7),
              ),
              const VerticalSpacing(10),

              /// driver details
              driverProfile.driverInformation == null && driverProfile.profileLoadingError==false && driverProfile.profileLoading == true ?
              Center(child: Column(
                children: [
                   Text('Loading Information ......',
                    style: context.textTheme.bodyLarge!
                        .copyWith(fontWeight: FontWeight.w500, fontSize: 14),),
                  const CircularProgressIndicator(),
                ],
              )) :
                  driverProfile.profileLoadingError == true ?
                  Center(child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Oops! Check your internet connect and try again',
                        style: context.textTheme.bodyLarge!
                            .copyWith(fontWeight: FontWeight.w500, fontSize: 14),),
                      const Icon(Icons.error, color: AppColors.error,size: 25,)
                    ],
                  )) :
                  ///details info card
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                margin: const EdgeInsets.only(left: 18, right: 18),
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
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ///name and image
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                ///image
                                ImagePickerWidget(
                                  backgroundColor: AppColors.black,
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
                                    title:  Text('Profile Photo',
                                      style: context.textTheme.bodySmall!
                                          .copyWith(fontWeight: FontWeight.w500, fontSize: 14),),
                                    cameraColor: AppColors.black,
                                    cameraText:  Text('Camera',
                                      style: context.textTheme.bodySmall!
                                          .copyWith(fontWeight: FontWeight.w500, fontSize: 12),),
                                    galleryColor: AppColors.black,
                                    galleryText:  Text('Gallery',
                                        style: context.textTheme.bodySmall!
                                            .copyWith(fontWeight: FontWeight.w500, fontSize: 12),),
                                    galleryIcon: Icons.image
                                  ),
                                  onChange: (file) {},
                                ),

                                Text(
                                   _driverLastName ??'',
                                  style: context.textTheme.bodySmall!
                                      .copyWith(fontWeight: FontWeight.w500, fontSize: 14),
                                ),Text(
                                  _driverName!,
                                  style: context.textTheme.bodySmall!
                                      .copyWith(fontWeight: FontWeight.w500, fontSize: 14),
                                ),
                              ],
                            ),
                          ///divider line
                          Container(
                            margin: const EdgeInsets.only(left: 5, right: 5),
                            width: 1,
                            height: 100,
                            color: AppColors.grey.withOpacity(0.7),
                          )
                          ],
                        ),

                        ///car details
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                const Icon(Icons.car_repair, color: AppColors.black, size: 35,),
                                ///car plate number
                                Text(
                                  driverProfile.driverInformation!.profile!.vehicleDetails!.numberPlate ?? '' ,
                                  style: context.textTheme.bodySmall!
                                      .copyWith(fontWeight: FontWeight.w700, fontSize: 12),
                                ),
                                ///car color
                                Text(
                                  driverProfile.driverInformation!.profile!.vehicleDetails!.color ?? '' ,
                                  style: context.textTheme.bodySmall!
                                      .copyWith(fontWeight: FontWeight.w500, fontSize: 12),
                                ),
                                ///car model and make
                                Text(
                                  '${driverProfile.driverInformation!.profile!.vehicleDetails!.make } ${driverProfile.driverInformation!.profile!.vehicleDetails!.model }',
                                  style: context.textTheme.bodySmall!
                                      .copyWith(fontWeight: FontWeight.w600, fontSize: 10),
                                ),
                              ],
                            ),
                            ///divider line
                            Container(
                              margin: const EdgeInsets.only(left: 5, right: 5),
                              width: 1,
                              height: 100,
                              color: AppColors.grey.withOpacity(0.7),
                            )
                          ],
                        ),

                        ///ride complete
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                // Image.asset(Assets.assetsSvgsHistory),
                                const Icon(Icons.verified, color: AppColors.yellow, size: 35,),
                                ///rides completed
                                Text(
                                  driverProfile.driverInformation!.profile!.completedTrips.toString(),
                                  style: context.textTheme.bodySmall!
                                      .copyWith(fontWeight: FontWeight.w500, fontSize: 12),
                                ),Text(
                                  'Completed \n    Trips',
                                  style: context.textTheme.bodySmall!
                                      .copyWith(fontWeight: FontWeight.w500, fontSize: 12),
                                ),
                              ],
                            ),
                            ///divider line
                            Container(
                              margin: const EdgeInsets.only(left: 5, right: 5),
                              width: 1,
                              height: 100,
                              color: AppColors.grey.withOpacity(0.7),
                            )
                          ],
                        ),

                        ///rating
                        Column(
                          children: [
                            const Icon(Icons.star, color: AppColors.yellow, size: 35,),
                            Text(
                              driverProfile.driverInformation!.profile!.averageRating!.toStringAsFixed(1),
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
                     const VerticalSpacing(15),

                     Divider(color: AppColors.grey.withOpacity(0.7),endIndent: 10, indent: 10,),

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
                        GestureDetector(
                          onTap: (){
                            context.push(const WalletScreen());},
                          child: Container(
                            padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                            decoration: BoxDecoration(
                              color: AppColors.black,
                              borderRadius:
                              BorderRadius.circular(6.r), // Adjust the radius as needed
                              border: Border.all(
                                color: AppColors.black, // Specify the border color here
                                width: 1.0, // Adjust the border width as needed
                              ),
                            ),
                            child: Center(
                              child: Text('WITHDRAW',
                                style: context.textTheme.bodySmall!
                                    .copyWith(fontWeight: FontWeight.w500, fontSize: 10, color: AppColors.yellow),),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              const VerticalSpacing(20),
              /// setting menu list
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
                    leadingIcon:  Assets.assetsSvgsHistory,
                    text: 'Vehicle Information',
                    onTap: () {
                      context.push(const VehicleDetailsScreen());
                    },
                  ),

                  // ///wallet
                  // ProfileScreenTile(
                  //   onTap: () {
                  //     // balanceProvider.userWalletBalance(_token!);
                  //     // context.push(const WalletScreen());
                  //   },
                  //   leadingIcon: Assets.assetsSvgsAccountWallet,
                  //   text: 'Wallet',
                  // ),

                  ///security
                  ProfileScreenTile(
                    leadingIcon: Assets.assetsSvgsShield,
                    text: 'Security',
                    onTap: () {
                      context.push(const SecurityScreen());
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
  }
}


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
