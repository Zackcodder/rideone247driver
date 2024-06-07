import 'package:flutter/material.dart';
import 'package:ride_on_driver/core/constants/assets.dart';
import 'package:ride_on_driver/core/constants/colors.dart';
import 'package:ride_on_driver/core/extensions/build_context_extensions.dart';
import 'package:ride_on_driver/widgets/app_elevated_button.dart';
import 'package:ride_on_driver/widgets/app_text_field.dart';
import 'package:ride_on_driver/widgets/spacing.dart';

class VehicleRegistrationScreen extends StatefulWidget {
  const VehicleRegistrationScreen({super.key});

  @override
  State<VehicleRegistrationScreen> createState() =>
      _VehicleRegistrationScreenState();
}

class _VehicleRegistrationScreenState extends State<VehicleRegistrationScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  final TextEditingController _vehicleMakeController = TextEditingController();
  final TextEditingController _VehicleModelController = TextEditingController();
  final TextEditingController _vehicleYearController = TextEditingController();
  final TextEditingController _VehicleColorController = TextEditingController();
  final TextEditingController _vehiclePlateNumberController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('Vehicle Registration',
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
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.assetsImagesPatternBackground),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(
              color: AppColors.grey.withOpacity(0.7),
            ),
            const VerticalSpacing(10),
            ///Vehicle make
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Vehicle Make (e.g Toyota)',
                  style: context.textTheme.bodyMedium!.copyWith(
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
                const VerticalSpacing(10),
                AppTextField(
                  controller: _vehicleMakeController,
                  hintText: 'Vehicle Make Here',
                ),
              ],
            ),
            const VerticalSpacing(10),
            ///Vehicle model
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Vehicle Model (e.g Camry)',
                  style: context.textTheme.bodyMedium!.copyWith(
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
                const VerticalSpacing(10),
                AppTextField(
                  controller: _VehicleModelController,
                  hintText: 'Vehicle Model Here',
                ),
              ],
            ),

            const VerticalSpacing(10),

            ///Vehicle year
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Vehicle Year',
                  style: context.textTheme.bodyMedium!.copyWith(
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
                const VerticalSpacing(10),
                AppTextField(
                  keyboardType: TextInputType.number,
                  controller: _vehicleYearController,
                  hintText: 'Vehicle Year Here',
                ),
              ],
            ),

            const VerticalSpacing(10),

            ///Vehicle color
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Vehicle Color',
                  style: context.textTheme.bodyMedium!.copyWith(
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
                const VerticalSpacing(10),
                AppTextField(
                  controller: _VehicleColorController,
                  hintText: 'Vehicle Color Here',
                ),
              ],
            ),
            const VerticalSpacing(10),
            ///Vehicle plate number
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Vehicle Plate Number',
                  style: context.textTheme.bodyMedium!.copyWith(
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
                const VerticalSpacing(10),
                AppTextField(
                  controller: _vehiclePlateNumberController,
                  hintText: 'Vehicle Plate Number',
                ),
              ],
            ),

            // const Spacer(),
            const VerticalSpacing(90),

            ///save button
            AppElevatedButton.large(
              onPressed: context.pop,
              text: 'Save',
              backgroundColor: AppColors.black,
              foregroundColor: AppColors.yellow,
            ),
            // const VerticalSpacing(30),
          ],
        ),
        ),
      ),
    );
  }
}
