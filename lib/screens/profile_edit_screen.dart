import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ride_on_driver/core/constants/colors.dart';
import 'package:ride_on_driver/core/extensions/build_context_extensions.dart';
import 'package:ride_on_driver/core/extensions/widget_extensions.dart';
import 'package:ride_on_driver/widgets/app_elevated_button.dart';
import 'package:ride_on_driver/widgets/spacing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider/authprovider.dart';
import '../provider/driver_provider.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    Provider.of<DriverProvider>(context, listen: false)
        .fetchDriverProfile(_authProvider.token!);
    loadDriverDataFromSharedPreference();
  }

  String? _driverName;
  String? _driverLastName;
  String? _driverEmail;
  late AuthProvider _authProvider;
  loadDriverDataFromSharedPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _driverLastName = prefs.getString('driver_lastname');
      _driverName = prefs.getString('driver_name');
      _driverEmail = prefs.getString('driver_email');
    });
  }

  bool _isEditing = false;
  bool _isEditing1 = false;
  bool _isEditing2 = false;
  bool _isEditing3 = false;
  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    DriverProvider driverProfile = Provider.of<DriverProvider>(context);
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text('Profile Information',
            style: context.textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                fontFamily: 'SFPRODISPLAYREGULAR')),
        // scrolledUnderElevation: 0,
      ),
      body: driverProfile.driverInformation == null &&
              driverProfile.profileLoading == true
          ? Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Loading Information ......',
                  style: context.textTheme.bodyLarge!
                      .copyWith(fontWeight: FontWeight.w500, fontSize: 14),
                ),
                const CircularProgressIndicator(),
              ],
            ))
          : driverProfile.profileLoadingError == true
              ? Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Oops! Check your internet connect and try again',
                      style: context.textTheme.bodyLarge!
                          .copyWith(fontWeight: FontWeight.w500, fontSize: 14),
                    ),
                    const Icon(
                      Icons.error,
                      color: AppColors.error,
                      size: 25,
                    )
                  ],
                ))
              : Container(
                  margin: const EdgeInsets.only(
                    left: 15,
                    right: 15,
                  ),
                  child: Column(
                    children: [
                      Divider(
                        color: AppColors.grey.withOpacity(0.7),
                      ),

                      ///account name
                      Container(
                        margin: const EdgeInsets.only(
                          top: 20,
                        ),
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              4.r), // Adjust the radius as needed
                          border: Border.all(
                            color: AppColors
                                .yellow, // Specify the border color here
                            width: 1.0, // Adjust the border width as needed
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Account name',
                                      style:
                                          context.textTheme.bodyLarge!.copyWith(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                    _isEditing
                                        ? SizedBox(
                                            width: 250,
                                            child: TextField(
                                              style: context
                                                  .textTheme.bodyMedium!
                                                  .copyWith(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12,
                                              ),
                                              controller:
                                                  _nameEditingController,
                                              decoration: InputDecoration(
                                                hintText:
                                                    'Enter New Account name',
                                                hintStyle: context
                                                    .textTheme.bodyMedium!
                                                    .copyWith(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          )
                                        : Text(
                                            '$_driverName $_driverLastName',
                                            style: context.textTheme.bodyMedium!
                                                .copyWith(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12.sp,
                                            ),
                                          ),
                                  ],
                                ),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _isEditing = !_isEditing;
                                        if (_isEditing) {
                                          // If entering edit mode, populate the text field with the current account name
                                          _nameEditingController.text =
                                              _driverName ?? '';
                                        } else {
                                          // If saving, update the account name and dispose the text controller
                                          _driverName =
                                              _nameEditingController.text;
                                          // _textEditingController.dispose();
                                        }
                                      });
                                    },
                                    icon: Icon(
                                      _isEditing ? Icons.cancel : Icons.edit,
                                      // Icons.edit,
                                      color: AppColors.black,
                                      size: 15,
                                    ))
                              ],
                            ),
                            const VerticalSpacing(15),
                            _isEditing
                                ? AppElevatedButton.large(
                                    onPressed: () {
                                      _isEditing = !_isEditing;
                                      setState(() {});
                                    },
                                    // context.pop,
                                    text: 'Save',
                                    backgroundColor: AppColors.black,
                                    foregroundColor: AppColors.yellow,
                                  )
                                : const SizedBox(),
                            const VerticalSpacing(15),
                          ],
                        ),
                      ),
                      const VerticalSpacing(15),

                      ///phone number
                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              4.r), // Adjust the radius as needed
                          border: Border.all(
                            color: AppColors
                                .yellow, // Specify the border color here
                            width: 1.0, // Adjust the border width as needed
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Phone Number',
                                      style:
                                          context.textTheme.bodyLarge!.copyWith(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                    _isEditing1
                                        ? SizedBox(
                                            width: 250,
                                            child: TextField(
                                              style: context
                                                  .textTheme.bodyMedium!
                                                  .copyWith(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12,
                                              ),
                                              controller:
                                                  _phoneNumberController,
                                              decoration: InputDecoration(
                                                hintText: '090*******',
                                                hintStyle: context
                                                    .textTheme.bodyMedium!
                                                    .copyWith(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          )
                                        : Text(
                                            driverProfile.driverInformation!
                                                    .profile!.driver!.phone ??
                                                'Phone number',
                                            style: context.textTheme.bodyMedium!
                                                .copyWith(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12.sp,
                                            ),
                                          ),
                                  ],
                                ),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _isEditing1 = !_isEditing1;
                                        if (_isEditing1) {
                                          // If entering edit mode, populate the text field with the current account name
                                          _phoneNumberController.text =
                                              driverProfile.driverInformation!
                                                      .profile!.driver!.phone ??
                                                  '';
                                        } else {
                                          // If saving, update the account name and dispose the text controller
                                          driverProfile.driverInformation!
                                                  .profile!.driver!.phone =
                                              _phoneNumberController.text;
                                          // _textEditingController.dispose();
                                        }
                                      });
                                    },
                                    icon: Icon(
                                      _isEditing1 ? Icons.cancel : Icons.edit,
                                      // Icons.edit,
                                      color: AppColors.black,
                                      size: 15,
                                    ))
                              ],
                            ),
                            const VerticalSpacing(15),
                            _isEditing1
                                ? AppElevatedButton.large(
                                    onPressed: () {
                                      _isEditing1 = !_isEditing1;
                                      setState(() {});
                                    },
                                    // context.pop,
                                    text: 'Save',
                                    backgroundColor: AppColors.black,
                                    foregroundColor: AppColors.yellow,
                                  )
                                : const SizedBox(),
                            const VerticalSpacing(15),
                          ],
                        ),
                      ),
                      const VerticalSpacing(15),

                      ///email
                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              4.r), // Adjust the radius as needed
                          border: Border.all(
                            color: AppColors
                                .yellow, // Specify the border color here
                            width: 1.0, // Adjust the border width as needed
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Email',
                                      style:
                                          context.textTheme.bodyLarge!.copyWith(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                    _isEditing2
                                        ? SizedBox(
                                            width: 250,
                                            child: TextField(
                                              style: context
                                                  .textTheme.bodyMedium!
                                                  .copyWith(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12,
                                              ),
                                              controller: _emailController,
                                              decoration: InputDecoration(
                                                hintText: '@.com',
                                                hintStyle: context
                                                    .textTheme.bodyMedium!
                                                    .copyWith(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          )
                                        : Text(
                                            _driverEmail ?? 'email',
                                            style: context.textTheme.bodyMedium!
                                                .copyWith(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12.sp,
                                            ),
                                          ),
                                  ],
                                ),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _isEditing2 = !_isEditing2;
                                        if (_isEditing2) {
                                          // If entering edit mode, populate the text field with the current account name
                                          _emailController.text =
                                              _driverEmail ?? '';
                                        } else {
                                          // If saving, update the account name and dispose the text controller
                                          _driverEmail = _emailController.text;
                                          // _textEditingController.dispose();
                                        }
                                      });
                                    },
                                    icon: Icon(
                                      _isEditing2 ? Icons.cancel : Icons.edit,
                                      color: AppColors.black,
                                      size: 15,
                                    ))
                              ],
                            ),
                            const VerticalSpacing(15),
                            _isEditing2
                                ? AppElevatedButton.large(
                                    onPressed: () {
                                      _isEditing2 = !_isEditing2;
                                      setState(() {});
                                    },
                                    // context.pop,
                                    text: 'Save',
                                    backgroundColor: AppColors.black,
                                    foregroundColor: AppColors.yellow,
                                  )
                                : const SizedBox(),
                            const VerticalSpacing(15),
                          ],
                        ),
                      ),
                      const VerticalSpacing(15),

                      ///date of birth
                      // Container(
                      //   padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                      //   decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(
                      //         4.r), // Adjust the radius as needed
                      //     border: Border.all(
                      //       color:
                      //       AppColors.yellow, // Specify the border color here
                      //       width: 1.0, // Adjust the border width as needed
                      //     ),
                      //   ),
                      //   child: Column(
                      //     children: [
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           Column(
                      //             crossAxisAlignment: CrossAxisAlignment.start,
                      //             children: [
                      //               Text(
                      //                 'Date of Birth',
                      //                 style: context.textTheme.bodyLarge!.copyWith(
                      //                   fontWeight: FontWeight.w500,
                      //                   fontSize: 14.sp,
                      //                 ),
                      //               ),
                      //               _isEditing3
                      //                   ? SizedBox(
                      //                 width: 250,
                      //                 child: TextField(
                      //                   style: context.textTheme.bodyMedium!
                      //                       .copyWith(
                      //                     fontWeight: FontWeight.w400,
                      //                     fontSize: 12,
                      //                   ),
                      //                   controller: _dobController,
                      //                   decoration: InputDecoration(
                      //                     hintText: 'DOB',
                      //                     hintStyle: context
                      //                         .textTheme.bodyMedium!
                      //                         .copyWith(
                      //                       fontWeight: FontWeight.w400,
                      //                       fontSize: 12,
                      //                     ),
                      //                   ),
                      //                 ),
                      //               )
                      //                   : Text(
                      //                 _driverName ?? 'DOB',
                      //                 style: context.textTheme.bodyMedium!
                      //                     .copyWith(
                      //                   fontWeight: FontWeight.w400,
                      //                   fontSize: 12.sp,
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //           IconButton(
                      //               onPressed: () {
                      //                 setState(() {
                      //                   _isEditing3 = !_isEditing3;
                      //                   if (_isEditing3) {
                      //                     // If entering edit mode, populate the text field with the current account name
                      //                     _dobController.text = _driverName ?? '';
                      //                   } else {
                      //                     // If saving, update the account name and dispose the text controller
                      //                     _driverName = _dobController.text;
                      //                     // _textEditingController.dispose();
                      //                   }
                      //                 });
                      //               },
                      //               icon: Icon(
                      //                 _isEditing3
                      //                     ? Icons.cancel
                      //                     : Icons.perm_contact_calendar_outlined,
                      //                 // Icons.edit,
                      //                 color: AppColors.black,
                      //                 size: 15,
                      //               ))
                      //         ],
                      //       ),
                      //       const VerticalSpacing(15),
                      //       _isEditing3
                      //           ? AppElevatedButton.large(
                      //         onPressed: () {
                      //           _isEditing3 = !_isEditing3;
                      //           setState(() {});
                      //         },
                      //         // context.pop,
                      //         text: 'Save',
                      //         backgroundColor: AppColors.black,
                      //         foregroundColor: AppColors.yellow,
                      //       )
                      //           : const SizedBox(),
                      //       const VerticalSpacing(15),
                      //     ],
                      //   ),
                      // ),

                      const VerticalSpacing(20),
                    ],
                  ),
                ),
    ).onTap(context.unfocus);
  }
}
