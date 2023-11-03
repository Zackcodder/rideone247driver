import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_on_driver/core/constants/colors.dart';

import '../core/extensions/build_context_extensions.dart';
import '../core/extensions/widget_extensions.dart';
import '../widgets/app_elevated_button.dart';
import '../widgets/app_logo.dart';
import '../widgets/app_text_field.dart';
import '../widgets/spacing.dart';
import 'home_screen.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const Spacer(),
              const AppLogo(),
              const VerticalSpacing(10),
              SizedBox(
                width: 250.w,
                child: Text(
                  'Welcome back. Please provide your access codes to gain access into our community.',
                  textAlign: TextAlign.center,
                  style: context.textTheme.bodySmall,
                ),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'New Password',
                  style: context.textTheme.bodyMedium,
                ),
              ).padOnly(left: 20.w),
              const VerticalSpacing(10),
              const AppTextField(
                hintText: '*********',
                isPassword: true,
                prefixIcon: Icon(
                  Icons.lock_outline,
                  color: Colors.grey,
                ),
              ),
              const VerticalSpacing(50),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Confirm Password',
                  style: context.textTheme.bodyMedium,
                ),
              ).padOnly(left: 20.w),
              const VerticalSpacing(10),
              const AppTextField(
                hintText: '*********',
                isPassword: true,
                prefixIcon: Icon(
                  Icons.lock_outline,
                  color: Colors.grey,
                ),
              ),
              const Spacer(),
              AppElevatedButton.large(
                onPressed: () => context.push(const HomeScreen()),
                text: 'Reset Password',
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
