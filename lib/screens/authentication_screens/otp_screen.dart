import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:provider/provider.dart';

import '../../core/constants/colors.dart';
import '../../core/extensions/build_context_extensions.dart';
import '../../provider/authprovider.dart';
import '../../widgets/app_elevated_button.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/app_text_button.dart';
import '../../widgets/spacing.dart';
import '../home_screen.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final OtpFieldController otpController = OtpFieldController();
  String otp = '';
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
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
                controller: otpController,
                length: 6,
                width: context.width * 0.8,
                fieldWidth: 50.w,
                style: const TextStyle(fontSize: 17),
                textFieldAlignment: MainAxisAlignment.spaceAround,
                fieldStyle: FieldStyle.box,
                outlineBorderRadius: 5.r,
                otpFieldStyle: OtpFieldStyle(
                  borderColor: AppColors.black,
                  disabledBorderColor: AppColors.black,
                  backgroundColor: AppColors.lightGrey,
                  enabledBorderColor: AppColors.black,
                  focusBorderColor: AppColors.yellow,
                ),
                onCompleted: (pin) async{
                  setState(() {
                    otp = pin;
                  });
                },
              ),
              const VerticalSpacing(100),

              ///submit
              authProvider.signUpLoading == true
                  ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.black),
                ),
              )
                  :AppElevatedButton.large(
                  onPressed: () async{
                    final otpPin = int.parse(otp);
                    print('this is the opt $otpPin');
                    authProvider.sendOtp(
                      context,
                      otpPin,
                    );
                    setState(() {
                      authProvider.signUpLoading;
                    });
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
                    onPressed: () async{
                      authProvider.getOtp(context, authProvider.driverEmail!);},
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
