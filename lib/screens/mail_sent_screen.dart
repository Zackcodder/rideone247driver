import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ride_on_driver/core/constants/colors.dart';

import '../core/constants/assets.dart';
import '../core/extensions/build_context_extensions.dart';
import '../widgets/app_elevated_button.dart';
import '../widgets/app_logo.dart';
import '../widgets/app_text_button.dart';
import '../widgets/spacing.dart';
import 'change_password.dart';

class MailSentScreen extends StatelessWidget {
  const MailSentScreen({super.key});

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
              const Spacer(),
              SvgPicture.asset(Assets.assetsSvgsCheck),
              Text(
                'A reset password link has been sent to your email.',
                textAlign: TextAlign.center,
                style: context.textTheme.bodySmall,
              ),
              const VerticalSpacing(20),
              AppElevatedButton.large(
                onPressed: () {
                  context.push(const ChangePasswordScreen());
                },
                text: 'Open Email App',
              ),
              const VerticalSpacing(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Didn\'t get an Email?',
                    style: context.textTheme.bodySmall,
                  ),
                  AppTextButton(
                    onPressed: () async {},
                    text: 'Resend',
                  )
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
