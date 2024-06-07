import 'package:flutter/material.dart';
import 'package:ride_on_driver/core/constants/assets.dart';
import 'package:ride_on_driver/core/extensions/build_context_extensions.dart';
import 'package:ride_on_driver/screens/onboarding_screens/bank_registration_screen.dart';
import 'package:ride_on_driver/screens/onboarding_screens/id_registration_screen.dart';
import 'package:ride_on_driver/screens/onboarding_screens/license_registration_screen.dart';
import 'package:ride_on_driver/screens/onboarding_screens/vehicle_registration_screen.dart';
import 'package:ride_on_driver/widgets/spacing.dart';

import '../profile_screens/profile_screen.dart';

class CompleteProfileScreen extends StatelessWidget {
  const CompleteProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(left: 15, right: 15),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.assetsImagesPatternBackground),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const VerticalSpacing(40),

              ///header
              Align(
                alignment: AlignmentDirectional.center,
                child: Column(
                  children: [
                    Text(
                      'Complete Your Profile',
                      style: context.textTheme.bodyLarge!
                          .copyWith(fontWeight: FontWeight.w700, fontSize: 22),
                    ),
                    Text(
                      textAlign: TextAlign.center,
                      "Don't worry, only you can see your personal data. \n No one else will be able to see it.",
                      style: context.textTheme.bodyLarge!
                          .copyWith(fontWeight: FontWeight.w400, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const VerticalSpacing(40),

              ///steps
              Text(
                'Required Steps',
                style: context.textTheme.bodyLarge!
                    .copyWith(fontWeight: FontWeight.w500, fontSize: 16),
              ),

              ///bank account details
              ProfileScreenTile(
                onTap: () {
                  context.push(const BankDetailsRegScreen());
                },
                leadingIcon: Assets.assetsSvgsBank,
                text: 'Bank Account Details',
              ),
              const VerticalSpacing(10),

              ///ID card
              ProfileScreenTile(
                onTap: () {
                  context.push(const IdRegistrationScreen());
                },
                leadingIcon: Assets.assetsSvgsID,
                text: 'Government ID',
              ),
              const VerticalSpacing(10),

              ///car details
              ProfileScreenTile(
                onTap: () {
                  context.push(const VehicleRegistrationScreen());
                },
                leadingIcon: Assets.assetsSvgsSmallCar,
                text: 'Car Details',
              ),
              const VerticalSpacing(10),

              ///driver Licence
              ProfileScreenTile(
                onTap: () {
                  context.push(const DriverLicenseRegistrationScreen());
                },
                leadingIcon: Assets.assetsSvgsLicense,
                text: 'Driving License',
              ),
              const VerticalSpacing(40),

              ///completed steps
              Text(
                'Completed Steps',
                style: context.textTheme.bodyLarge!
                    .copyWith(fontWeight: FontWeight.w500, fontSize: 16),
              ),
              ProfileScreenTile(
                onTap: () {
                  // context.push(const ProfileEditScreen());
                },
                leadingIcon: Assets.assetsSvgsUser,
                text: 'Profile Information',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
