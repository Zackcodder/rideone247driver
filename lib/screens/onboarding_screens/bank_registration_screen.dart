import 'package:flutter/material.dart';
import 'package:ride_on_driver/core/constants/assets.dart';
import 'package:ride_on_driver/core/extensions/build_context_extensions.dart';
import 'package:ride_on_driver/widgets/app_elevated_button.dart';
import 'package:ride_on_driver/widgets/app_text_field.dart';
import 'package:ride_on_driver/widgets/spacing.dart';

import '../../core/constants/colors.dart';

class BankDetailsRegScreen extends StatefulWidget {
  const BankDetailsRegScreen({super.key});

  @override
  State<BankDetailsRegScreen> createState() => _BankDetailsRegScreenState();
}

class _BankDetailsRegScreenState extends State<BankDetailsRegScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  final TextEditingController accountNameController = TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController bankNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('Bank Account Details',
            style: context.textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                fontFamily: 'SFPRODISPLAYREGULAR')),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              size: 15,
            )),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 15, right: 15),

        ///background image
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
            Divider(
              color: AppColors.grey.withOpacity(0.7),
            ),

            const VerticalSpacing(10),

            ///account name
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Account Name',
                  style: context.textTheme.bodyMedium!.copyWith(
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
                const VerticalSpacing(10),
                AppTextField(
                  controller: accountNameController,
                  hintText: 'Account name here',
                ),
              ],
            ),

            const VerticalSpacing(10),

            ///account number
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Account Number',
                  style: context.textTheme.bodyMedium!.copyWith(
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
                const VerticalSpacing(10),
                AppTextField(
                  keyboardType: TextInputType.number,
                  controller: accountNumberController,
                  hintText: 'xxxxxxxxxxx',
                ),
              ],
            ),

            const VerticalSpacing(10),

            ///bank name
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bank Name',
                  style: context.textTheme.bodyMedium!.copyWith(
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
                const VerticalSpacing(10),
                AppTextField(
                  controller: bankNameController,
                  hintText: 'Bank name here',
                ),
              ],
            ),

            const Spacer(),

            ///save button
            AppElevatedButton.large(
              onPressed: context.pop,
              text: 'Save',
              backgroundColor: AppColors.black,
              foregroundColor: AppColors.yellow,
            ),
            const VerticalSpacing(30),
          ],
        )),
      ),
    );
  }
}
