import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ride_on_driver/core/constants/colors.dart';

// import '../core/constants/assets.dart';
import '../core/extensions/build_context_extensions.dart';
import '../core/extensions/widget_extensions.dart';
import '../provider/authprovider.dart';
import '../widgets/app_elevated_button.dart';
import '../widgets/app_logo.dart';
import '../widgets/app_text_field.dart';
import '../widgets/spacing.dart';
import 'mail_sent_screen.dart';

class ForgetPasswordScreen extends StatefulWidget {
  static String id = 'forgot_password';
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
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
                  'Forgot Password?. No worries Please provide your email address below so we can send a reset password link to you',
                  textAlign: TextAlign.center,
                  style: context.textTheme.bodySmall,
                ),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Email Address',
                  style: context.textTheme.bodyMedium,
                ),
              ).padOnly(left: 20.w),
              const VerticalSpacing(10),
               AppTextField(
                controller: _emailController,
                hintText: 'Cristianoronaldo@gmail.com',
                prefixIcon: const Icon(
                  Icons.mail_outline,
                  color: Colors.grey,
                ),
              ),
              const Spacer(),
              AppElevatedButton.large(
                onPressed: () async {
                  final email = _emailController.text;
                  authProvider.forgotPassword(context, email);
                },
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
