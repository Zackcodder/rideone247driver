import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ride_on_driver/core/constants/colors.dart';

import '../core/extensions/build_context_extensions.dart';
import '../core/extensions/widget_extensions.dart';
import '../provider/authprovider.dart';
import '../widgets/app_elevated_button.dart';
import '../widgets/app_logo.dart';
import '../widgets/app_text_field.dart';
import '../widgets/spacing.dart';
import 'home_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  static String id = 'change_password';
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
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
                  'Otp label',
                  style: context.textTheme.bodyMedium,
                ),
              ).padOnly(left: 20.w),
              const VerticalSpacing(10),
              //otp text field
              AppTextField(
                keyboardType: TextInputType.number,
                prefixIcon: const Icon(
                  Icons.pin,
                  color: Colors.grey,
                ),
                controller: _otpController,
                hintText: 'Enter otp sent to your mail',
              ),
              const VerticalSpacing(20),
              //new password
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'New Password',
                  style: context.textTheme.bodyMedium,
                ),
              ).padOnly(left: 20.w),
              const VerticalSpacing(10),
              AppTextField(
                controller: _newPasswordController,
                hintText: '*********',
                isPassword: true,
                prefixIcon: const Icon(
                  Icons.lock_outline,
                  color: Colors.grey,
                ),
              ),
              const Spacer(),
              AppElevatedButton.large(
                onPressed: () async {
                  final otp = _otpController.text;
                  final newPassword = _newPasswordController.text;
                  authProvider.resetPassword(context, otp, newPassword);
                },
                // onPressed: () => context.push(const HomeScreen()),
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
