import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ride_on_driver/core/constants/colors.dart';
import 'package:ride_on_driver/core/extensions/build_context_extensions.dart';
import 'package:ride_on_driver/provider/authprovider.dart';
import 'package:ride_on_driver/widgets/app_text_field.dart';
import 'package:ride_on_driver/widgets/currency_widget.dart';
import 'package:ride_on_driver/widgets/spacing.dart';

import '../core/constants/assets.dart';
import '../provider/driver_provider.dart';
import '../widgets/app_elevated_button.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  late AuthProvider _authProvider;
  bool newAccount = false;
  bool addNewAccount = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    Provider.of<DriverProvider>(context, listen: false)
        .fetchDriverProfile(_authProvider.token!);
  }

  @override
  Widget build(BuildContext context) {
    DriverProvider driverProfile = Provider.of<DriverProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('Withdrawal',
            style: context.textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                fontFamily: 'SFPRODISPLAYREGULAR')),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 23, right: 23),
        ///background deco image
        decoration:  const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.assetsImagesPatternBackground),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView(
          children: [
            Divider(color: AppColors.grey.withOpacity(0.7),),
            ///title
            Text('Enter your amount blow',
              style: context.textTheme.bodyLarge!
                  .copyWith(fontWeight: FontWeight.w600, fontSize: 14),),

            ///withdrawal input box
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 10),
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.black,
                borderRadius:
                BorderRadius.circular(6.r), // Adjust the radius as needed
                border: Border.all(
                  color: AppColors.grey, // Specify the border color here
                  width: 1.0, // Adjust the border width as needed
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ///amount input field
                  SizedBox(
                    width: 100,
                      child: TextFormField(
                        showCursor: true,
                        style:context.textTheme.bodyLarge!
                            .copyWith(fontWeight: FontWeight.w700, fontSize: 30, color: AppColors.yellow),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '₦ 0.00',
                          hintStyle:context.textTheme.bodyLarge!
                            .copyWith(fontWeight: FontWeight.w700, fontSize: 30, color: AppColors.yellow)
                        ),
                      )),
                  ///account balance
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Available balance: ',
                        style: context.textTheme.bodyLarge!
                            .copyWith(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.green),),
                      CurrencyWidget(price: driverProfile.driverInformation!.profile!.balance!.toDouble(), fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.green,),
                    ],
                  )
                ],
              ),
            ),
            Divider(color: AppColors.grey.withOpacity(0.7),),

            const VerticalSpacing(20),

            ///choose account
            Text('Choose Account',
              style: context.textTheme.bodyLarge!
                  .copyWith(fontWeight: FontWeight.w700, fontSize: 14),),
            ///choose account sub title
            Text('Select a saved account',
              style: context.textTheme.bodyLarge!
                  .copyWith(fontWeight: FontWeight.w400, fontSize: 12),),

            const VerticalSpacing(40),

            ///account card list
            GestureDetector(
              onTap: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.credit_card,
                    color: AppColors.black,
                    size: 30,
                  ),
                  const HorizontalSpacing(10),
                  Text('Shai Hulud (xxxxx0998878)',
                      style: context.textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          fontFamily: 'SFPRODISPLAYREGULAR')),
                  const Spacer(),
                  const Icon(Icons.radio_button_checked, color: AppColors.yellow,)
                ],
              ),
            ),

            const VerticalSpacing(20),

            ///add new card
            GestureDetector(
              onTap: () {
                newAccount = true;
                addNewAccount = true;
                setState(() { });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.add_card,
                    color: AppColors.black,
                    size: 30,
                  ),
                  const HorizontalSpacing(10),
                  Text('Use another account',
                      style: context.textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          fontFamily: 'SFPRODISPLAYREGULAR')),
                  const Spacer(),
                  Icon( addNewAccount == true ? Icons.radio_button_checked : Icons.radio_button_unchecked, color: AppColors.yellow,),

                ],
              ),
            ),
            const VerticalSpacing(20),

            newAccount == true ?
            SizedBox(
              height: 300,
              // color: AppColors.yellow,
              child: ListView(
                children: [
                  ///account name
                  Text(
                    'Account Name',
                    style: context.textTheme.bodyMedium!.copyWith(
                      color: Colors.grey.shade800,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const VerticalSpacing(10),
                  const AppTextField(
                    hintText: 'Account Name',
                  ),
                  const VerticalSpacing(10),
                  ///account number
                  Text(
                    'Account Number',
                    style: context.textTheme.bodyMedium!.copyWith(
                      color: Colors.grey.shade800,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const VerticalSpacing(10),
                  const AppTextField(
                    keyboardType: TextInputType.number,
                    hintText: 'Account Number',
                  ),
                  const VerticalSpacing(10),
                  ///Bank Name
                  Text(
                    'Bank Name',
                    style: context.textTheme.bodyMedium!.copyWith(
                      color: Colors.grey.shade800,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const VerticalSpacing(10),
                  const AppTextField(
                    hintText: 'Bank Name',
                  ),
                ],
              ),
            ) : const SizedBox(),
            const VerticalSpacing(20),
            AppElevatedButton.large(
              onPressed: () {
                newAccount = false;
                addNewAccount = false;
                setState(() { });
                // Navigator.pop(context);
              },
              // context.pop,
              text: 'Submit',
              backgroundColor: AppColors.black,
              foregroundColor: AppColors.yellow,
            ),
            const VerticalSpacing(30),

          ],
        ),
      ),
    );
  }
}
