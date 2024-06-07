import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_on_driver/core/extensions/build_context_extensions.dart';
import 'package:ride_on_driver/screens/authentication_screens/change_password_screen.dart';
import 'package:ride_on_driver/screens/authentication_screens/login_screen.dart';
import 'package:ride_on_driver/screens/profile_screens/profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/assets.dart';
import '../../core/constants/colors.dart';
import '../../widgets/app_elevated_button.dart';
import '../../widgets/app_text_button.dart';
import '../../widgets/spacing.dart';
import '../nav_bar.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({Key? key}) : super(key: key);

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('Security',
            style: context.textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                fontFamily: 'SFPRODISPLAYREGULAR')),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.assetsImagesPatternBackground),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(
                    color: AppColors.grey.withOpacity(0.7),
                  ),

                  ///change password
                  ProfileScreenTile(
                    leadingIcon: Assets.assetsSvgsPadlock,
                    text: 'Change Password',
                    onTap: () {
                      context.push(const ChangePasswordScreen());
                    },
                  ),

                  ///delete account
                  ProfileScreenTile(
                    leadingIcon: Assets.assetsSvgsDelete,
                    text: 'Delete My Account',
                    onTap: () {
                      showDialog(
                        // useSafeArea: false,
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            // margin: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              // color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 1,
                                  blurRadius: 2,
                                  offset: const Offset(
                                      0, 2), // changes position of shadow
                                ),
                              ],
                            ),
                            height: 50,
                            child: AlertDialog(
                              title: Text(
                                  'Are you sure you want to delete your account?',
                                  textAlign: TextAlign.center,
                                  style: context.textTheme.bodyMedium!.copyWith(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      fontFamily: 'SFPRODISPLAYREGULAR')),
                              content: Text('This action cannot be undone!',
                                  style: context.textTheme.bodyMedium!.copyWith(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      color: AppColors.red,
                                      fontFamily: 'SFPRODISPLAYREGULAR')),
                              actions: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ///yes button
                                    AppElevatedButton.tiny(
                                      onPressed: context.pop,
                                      text: 'Yes',
                                      backgroundColor: AppColors.green,
                                      foregroundColor: AppColors.white,
                                    ),
                                    const Spacer(),
                                    ///no button
                                    AppElevatedButton.tiny(
                                      onPressed: context.pop,
                                      text: 'No',
                                      backgroundColor: AppColors.red,
                                      foregroundColor: AppColors.white,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                  const VerticalSpacing(20),
                  Divider(
                    color: AppColors.grey.withOpacity(0.7),
                  ),
                  const VerticalSpacing(30),
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
                            context.pushReplacement(const LoginScreen());
                            currentPageIndexNotifier.value = 0;
                          },
                          text: 'Logout')
                    ],
                  ),
                  const VerticalSpacing(50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
