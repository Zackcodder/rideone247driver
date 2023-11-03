import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_on_driver/screens/forget_password.dart';
import 'package:ride_on_driver/screens/home_screen.dart';
import 'package:ride_on_driver/screens/signup_screen.dart';
import 'package:ride_on_driver/widgets/app_elevated_button.dart';
import 'package:ride_on_driver/widgets/app_logo.dart';
import 'package:ride_on_driver/widgets/app_text_field.dart';
import 'package:ride_on_driver/widgets/spacing.dart';

import '../core/constants/colors.dart';
import '../core/extensions/build_context_extensions.dart';
import '../core/extensions/widget_extensions.dart';
import '../widgets/app_text_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            children: [
              const VerticalSpacing(50),
              const AppLogo(),
              SizedBox(
                width: 220.w,
                child: Text(
                  'Welcome back. Please provide your access codes to gain access into our community.',
                  textAlign: TextAlign.center,
                  style: context.textTheme.bodySmall,
                ),
              ),
              const VerticalSpacing(100),
              const AppTextField(
                hintText: 'Cristianoronaldo@gmail.com',
                prefixIcon: Icon(
                  Icons.alternate_email_rounded,
                  color: AppColors.grey,
                ),
              ),
              const VerticalSpacing(20),
              const AppTextField(
                hintText: 'Your Password',
                prefixIcon: Icon(
                  Icons.lock_outline_rounded,
                  color: AppColors.grey,
                ),
                isPassword: true,
              ),
              const VerticalSpacing(50),
              AppElevatedButton.large(
                onPressed: () => context.pushReplacement(const HomeScreen()),
                text: 'Login',
              ),
              const VerticalSpacing(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don\'t have an account?',
                    style: context.textTheme.bodySmall,
                  ),
                  AppTextButton(
                    onPressed: () => context.push(const SignupScreen()),
                    text: 'Sign Up',
                  )
                ],
              ),
              AppTextButton(
                onPressed: () {
                  context.push(const ForgetPasswordScreen());
                },
                text: 'Forgot Password?',
              ),
              const VerticalSpacing(100),
            ],
          ),
        ),
      ),
    ).onTap(context.unfocus);
  }
}
