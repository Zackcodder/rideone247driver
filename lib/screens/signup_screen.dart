import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_on_driver/screens/forget_password.dart';
import 'package:ride_on_driver/screens/home_screen.dart';

import '../core/constants/colors.dart';
import '../core/extensions/build_context_extensions.dart';
import '../core/extensions/widget_extensions.dart';
import '../widgets/app_elevated_button.dart';
import '../widgets/app_logo.dart';
import '../widgets/app_text_button.dart';
import '../widgets/app_text_field.dart';
import '../widgets/spacing.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            children: [
              const AppLogo(),
              SizedBox(
                width: 220.w,
                child: Text(
                  'Hey, to join our community, please provide these details.',
                  textAlign: TextAlign.center,
                  style: context.textTheme.bodySmall,
                ),
              ),
              const VerticalSpacing(50),
              const AppTextField(
                hintText: 'Please Enter Your Names',
                prefixIcon: Icon(
                  Icons.person_2_outlined,
                  color: AppColors.grey,
                ),
              ),
              const VerticalSpacing(20),
              const AppTextField(
                hintText: 'Please Enter Your Phone Number',
                prefixIcon: Icon(
                  Icons.phone_iphone_rounded,
                  color: AppColors.grey,
                ),
              ),
              const VerticalSpacing(20),
              const AppTextField(
                hintText: 'Please Enter Your Email',
                prefixIcon: Icon(
                  Icons.mail_outline_rounded,
                  color: AppColors.grey,
                ),
              ),
              const VerticalSpacing(20),
              const AppTextField(
                hintText: 'Please Enter Your Password',
                prefixIcon: Icon(
                  Icons.lock_outline_rounded,
                  color: AppColors.grey,
                ),
                isPassword: true,
              ),
              const VerticalSpacing(20),
              const AppTextField(
                hintText: 'Please Confirm Your Password',
                prefixIcon: Icon(
                  Icons.lock_outline_rounded,
                  color: AppColors.grey,
                ),
                isPassword: true,
              ),
              const VerticalSpacing(50),
              AppElevatedButton.large(
                onPressed: () => context.pushReplacement(const HomeScreen()),
                text: 'Sign Up',
              ),
              const VerticalSpacing(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    style: context.textTheme.bodySmall,
                  ),
                  AppTextButton(
                    onPressed: () {
                      context.pop();
                    },
                    text: 'Log In',
                  )
                ],
              ),
              AppTextButton(
                onPressed: () {
                  context.push(const ForgetPasswordScreen());
                },
                text: 'Forgot Password?',
              ),
            ],
          ),
        ),
      ),
    ).onTap(context.unfocus);
  }
}
