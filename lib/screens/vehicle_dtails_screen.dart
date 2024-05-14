import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/authprovider.dart';
import '../provider/driver_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_on_driver/core/constants/colors.dart';
import 'package:ride_on_driver/core/extensions/build_context_extensions.dart';
import 'package:ride_on_driver/core/extensions/widget_extensions.dart';
import 'package:ride_on_driver/widgets/app_elevated_button.dart';
import 'package:ride_on_driver/widgets/spacing.dart';


class VehicleDetailsScreen extends StatefulWidget {
  const VehicleDetailsScreen({Key? key}) : super(key: key);

  @override
  State<VehicleDetailsScreen> createState() => _VehicleDetailsScreenState();
}

class _VehicleDetailsScreenState extends State<VehicleDetailsScreen> {
  late AuthProvider _authProvider;
  @override
  void initState() {
    super.initState();
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    Provider.of<DriverProvider>(context, listen: false)
        .fetchDriverProfile(_authProvider.token!);
  }
  bool _isEditing = false;
  bool _isEditing1 = false;
  bool _isEditing2 = false;
  bool _isEditing3 = false;
  final TextEditingController _vehicleMakeController = TextEditingController();
  final TextEditingController _vehicleModelController = TextEditingController();
  final TextEditingController _vehicleYearController = TextEditingController();
  final TextEditingController _vehicleColorController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    DriverProvider driverProfile = Provider.of<DriverProvider>(context);
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title:  Text('Vehicle Information',
            style: context.textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                fontFamily: 'SFPRODISPLAYREGULAR')),
        // scrolledUnderElevation: 0,

      ),
      body: driverProfile.driverInformation == null && driverProfile.profileLoading == true ?
      Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Loading Information ......',
            style: context.textTheme.bodyLarge!
                .copyWith(fontWeight: FontWeight.w500, fontSize: 14),),
          CircularProgressIndicator(),
        ],
      )) :
      driverProfile.profileLoadingError == true ?
      Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Oops! Check your internet connect and try again',
            style: context.textTheme.bodyLarge!
                .copyWith(fontWeight: FontWeight.w500, fontSize: 14),),
          Icon(Icons.error, color: AppColors.error,size: 25,)
        ],
      )) : Container(
        margin: const EdgeInsets.only(left: 15, right: 15,),
        child: ListView(
          children: [
            Divider(color: AppColors.grey.withOpacity(0.7),),
            ///vehicle make
            Container(
              margin: const EdgeInsets.only(top: 20,),
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                    4.r), // Adjust the radius as needed
                border: Border.all(
                  color:
                  AppColors.yellow, // Specify the border color here
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
                            'Vehicle Make',
                            style: context.textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 16.sp,
                                fontFamily: 'SFPRODISPLAYREGULAR'
                            ),
                          ),
                          _isEditing
                              ? SizedBox(
                            width: 250,
                            child: TextField(
                              style: context.textTheme.bodyMedium!
                                  .copyWith(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                  fontFamily: 'SFPRODISPLAYREGULAR'
                              ),
                              controller: _vehicleMakeController,
                              decoration: InputDecoration(
                                hintText: 'Vehicle Make',
                                hintStyle: context
                                    .textTheme.bodyMedium!
                                    .copyWith(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                    fontFamily: 'SFPRODISPLAYREGULAR'
                                ),
                              ),
                            ),
                          )
                              : Text(
                            driverProfile.driverInformation!.profile!.vehicleDetails!.make ??'',
                            style: context.textTheme.bodyMedium!
                                .copyWith(
                              fontWeight: FontWeight.w400,
                              fontSize: 14.sp,
                                fontFamily: 'SFPRODISPLAYREGULAR'
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
                                _vehicleMakeController.text =
                                    driverProfile.driverInformation!.profile!.vehicleDetails!.make ?? '';
                              } else {
                                // If saving, update the account name and dispose the text controller
                                driverProfile.driverInformation!.profile!.vehicleDetails!.make = _vehicleMakeController.text;
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

            ///vehicle model
            Container(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                    4.r), // Adjust the radius as needed
                border: Border.all(
                  color:
                  AppColors.yellow, // Specify the border color here
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
                            'Vehicle Model',
                            style: context.textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 16.sp,
                                fontFamily: 'SFPRODISPLAYREGULAR'
                            ),
                          ),
                          _isEditing1
                              ? SizedBox(
                            width: 250,
                            child: TextField(
                              style: context.textTheme.bodyMedium!
                                  .copyWith(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                  fontFamily: 'SFPRODISPLAYREGULAR'
                              ),
                              controller: _vehicleModelController,
                              decoration: InputDecoration(
                                hintText: 'e.g Camry',
                                hintStyle: context
                                    .textTheme.bodyMedium!
                                    .copyWith(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                    fontFamily: 'SFPRODISPLAYREGULAR'
                                ),
                              ),
                            ),
                          )
                              : Text(
                            driverProfile.driverInformation!.profile!.vehicleDetails!.model ?? 'Model',
                            style: context.textTheme.bodyMedium!
                                .copyWith(
                              fontWeight: FontWeight.w400,
                              fontSize: 14.sp,
                                fontFamily: 'SFPRODISPLAYREGULAR'
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
                                _vehicleModelController.text =
                                    driverProfile.driverInformation!.profile!.vehicleDetails!.model?? '';
                              } else {
                                // If saving, update the account name and dispose the text controller
                                driverProfile.driverInformation!.profile!.vehicleDetails!.model =
                                    _vehicleModelController.text;
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

            ///year of vehicle
            Container(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                    4.r), // Adjust the radius as needed
                border: Border.all(
                  color:
                  AppColors.yellow, // Specify the border color here
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
                            'Vehicle Year',
                            style: context.textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 16.sp,
                                fontFamily: 'SFPRODISPLAYREGULAR'
                            ),
                          ),
                          _isEditing2
                              ? SizedBox(
                            width: 250,
                            child: TextField(
                              style: context.textTheme.bodyMedium!
                                  .copyWith(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                              controller: _vehicleYearController,
                              decoration: InputDecoration(
                                hintText: 'YYYY',
                                hintStyle: context
                                    .textTheme.bodyMedium!
                                    .copyWith(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          )
                              : Text(
                            driverProfile.driverInformation!.profile!.vehicleDetails!.year.toString() ?? 'Year',
                            style: context.textTheme.bodyMedium!
                                .copyWith(
                              fontWeight: FontWeight.w400,
                              fontSize: 14.sp,
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
                                _vehicleYearController.text = driverProfile.driverInformation!.profile!.vehicleDetails!.year.toString() ?? '';
                              } else {
                                // If saving, update the account name and dispose the text controller
                                driverProfile.driverInformation!.profile!.vehicleDetails!.year = _vehicleYearController.text as int?;
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

            ///color of car
            Container(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                    4.r), // Adjust the radius as needed
                border: Border.all(
                  color:
                  AppColors.yellow, // Specify the border color here
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
                            'Vehicle Color',
                            style: context.textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 16.sp,
                                fontFamily: 'SFPRODISPLAYREGULAR'
                            ),
                          ),
                          _isEditing3
                              ? SizedBox(
                            width: 250,
                            child: TextField(
                              style: context.textTheme.bodyMedium!
                                  .copyWith(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                              controller: _vehicleColorController,
                              decoration: InputDecoration(
                                hintText: 'color',
                                hintStyle: context
                                    .textTheme.bodyMedium!
                                    .copyWith(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          )
                              : Text(
                            driverProfile.driverInformation!.profile!.vehicleDetails!.color ?? 'color',
                            style: context.textTheme.bodyMedium!
                                .copyWith(
                              fontWeight: FontWeight.w400,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              _isEditing3 = !_isEditing3;
                              if (_isEditing3) {
                                // If entering edit mode, populate the text field with the current account name
                                _vehicleColorController.text = driverProfile.driverInformation!.profile!.vehicleDetails!.color ?? '';
                              } else {
                                // If saving, update the account name and dispose the text controller
                                driverProfile.driverInformation!.profile!.vehicleDetails!.color = _vehicleColorController.text;
                                // _textEditingController.dispose();
                              }
                            });
                          },
                          icon: Icon(
                            _isEditing3
                                ? Icons.cancel
                                : Icons.edit,
                            // Icons.edit,
                            color: AppColors.black,
                            size: 15,
                          ))
                    ],
                  ),
                  const VerticalSpacing(15),
                  _isEditing3
                      ? AppElevatedButton.large(
                    onPressed: () {
                      _isEditing3 = !_isEditing3;
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

            const VerticalSpacing(20),

          ],
        ),
      ),
    ).onTap(context.unfocus);
  }
}
