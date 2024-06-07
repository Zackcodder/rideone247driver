import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';

import '../../core/constants/colors.dart';
import '../../core/extensions/build_context_extensions.dart';
import '../../widgets/app_elevated_button.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/app_text_button.dart';
import '../../widgets/spacing.dart';
import '../home_screen.dart';

class OTPScreen extends StatelessWidget {
  const OTPScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const VerticalSpacing(100),
              const AppLogo(),
              const VerticalSpacing(10),
              SizedBox(
                width: 220.w,
                child: Text(
                  'Please Provide Verification code sent to your phone.',
                  textAlign: TextAlign.center,
                  style: context.textTheme.bodySmall,
                ),
              ),
              const VerticalSpacing(100),
              OTPTextField(
                length: 4,
                width: context.width * 0.8,
                fieldWidth: 50.w,
                style: const TextStyle(fontSize: 17),
                textFieldAlignment: MainAxisAlignment.spaceAround,
                fieldStyle: FieldStyle.box,
                outlineBorderRadius: 5.r,
                otpFieldStyle: OtpFieldStyle(
                  backgroundColor: AppColors.lightGrey,
                  enabledBorderColor: AppColors.lightGrey,
                  focusBorderColor: AppColors.yellow,
                ),
                onCompleted: (pin) {},
              ),
              const VerticalSpacing(100),
              AppElevatedButton.large(
                  onPressed: () {
                    context.pushReplacement(const HomeScreen());
                  },
                  text: 'Verify'),
              const VerticalSpacing(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Did not get the code?',
                    style: context.textTheme.bodySmall,
                  ),
                  AppTextButton(
                    onPressed: () {},
                    text: 'Resend',
                  )
                ],
              ),
              const VerticalSpacing(50),
            ],
          ),
        ),
      ),
    );
  }
}
