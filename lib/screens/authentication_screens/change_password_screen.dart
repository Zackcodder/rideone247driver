import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_on_driver/core/extensions/build_context_extensions.dart';

import '../../core/constants/assets.dart';
import '../../core/constants/colors.dart';
import '../../widgets/app_elevated_button.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/spacing.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Security',
            style: context.textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                fontFamily: 'SFPRODISPLAYREGULAR')),
        // leading: IconButton(
        //     onPressed: () {
        //       Navigator.pop(context);
        //     },
        //     icon: const Icon(Icons.arrow_back)),
      ),
      body: Container(
        ///background image
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
                  Text(
                    'Old Password',
                    style: context.textTheme.bodyMedium!.copyWith(
                      color: Colors.grey.shade800,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const VerticalSpacing(10),
                  const AppTextField(
                    hintText: '********',
                    isPassword: true,
                    prefixIcon: Icon(
                      Icons.lock_outline_rounded,
                      color: AppColors.grey,
                    ),
                  ),
                  const VerticalSpacing(10),

                  ///new password
                  Text(
                    'New Password',
                    style: context.textTheme.bodyMedium!.copyWith(
                      color: Colors.grey.shade800,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const VerticalSpacing(10),
                  const AppTextField(
                    hintText: 'Please Enter Your New Password',
                    isPassword: true,
                  ),
                  const VerticalSpacing(10),

                  ///confirm password
                  Text(
                    'Confirm Password',
                    style: context.textTheme.bodyMedium!.copyWith(
                      color: Colors.grey.shade800,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const VerticalSpacing(10),
                  const AppTextField(
                    hintText: 'Please Enter Your New Password',
                    isPassword: true,
                  ),
                  const VerticalSpacing(60),
                  AppElevatedButton.large(
                    onPressed: context.pop,
                    text: 'Change Password',
                    backgroundColor: AppColors.black,
                    foregroundColor: AppColors.yellow,
                  ),
                  const VerticalSpacing(20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
