import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ride_on_driver/core/constants/assets.dart';
import 'package:ride_on_driver/core/constants/colors.dart';
import 'package:ride_on_driver/core/extensions/build_context_extensions.dart';
import 'package:ride_on_driver/screens/onboarding_screens/car_details_screen.dart';
import 'package:ride_on_driver/widgets/dash_boarder_painter.dart';

import '../../widgets/app_elevated_button.dart';
import '../../widgets/spacing.dart';

class IdRegistrationScreen extends StatefulWidget {
  const IdRegistrationScreen({super.key});

  @override
  State<IdRegistrationScreen> createState() => _IdRegistrationScreenState();
}

class _IdRegistrationScreenState extends State<IdRegistrationScreen> {
  String? _selectedIDType;
  final List<String> _idTypes = ['Passport', 'School ID', 'Work ID'];
  List<PlatformFile> _selectedFiles = [];

  Future<void> _pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'png'],
      allowMultiple: true,
    );

    if (result != null) {
      setState(() {
        _selectedFiles = result.files;
      });
    }
  }

  void _removeFile(int index) {
    setState(() {
      _selectedFiles.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('Government ID Registration',
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
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(
                color: AppColors.grey.withOpacity(0.7),
              ),
              const VerticalSpacing(10),

              ///instruction list
              Row(
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: AppColors.black,
                    size: 20,
                  ),
                  Expanded(
                    child: Text(
                        'The photo and all details must be clearly visible.',
                        style: context.textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                            fontFamily: 'SFPRODISPLAYREGULAR')),
                  ),
                ],
              ),
              const VerticalSpacing(10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: AppColors.black,
                    size: 20,
                  ),
                  Expanded(
                    child: Text(
                        'Photocopies and printouts of documents will not be accepted.',
                        textAlign: TextAlign.justify,
                        style: context.textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                            fontFamily: 'SFPRODISPLAYREGULAR')),
                  ),
                ],
              ),
              const VerticalSpacing(10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: AppColors.black,
                    size: 20,
                  ),
                  Expanded(
                    child: Text(
                        'Only document less than 10mb in size and in JPG, PNG or PDF format will be accepted.',
                        style: context.textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                            fontFamily: 'SFPRODISPLAYREGULAR')),
                  ),
                ],
              ),
              const VerticalSpacing(20),

              const Divider(
                color: AppColors.black,
                thickness: 2.0,
              ),
              const VerticalSpacing(40),

              ///ID selector
              Text('ID Type',
                  style: context.textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      fontFamily: 'SFPRODISPLAYREGULAR')),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                      10.r), // Adjust the radius as needed
                  border: Border.all(
                    color: AppColors.black, // Specify the border color here
                    width: 1.0, // Adjust the border width as needed
                  ),
                ),
                child: DropdownButton<String>(
                  value: _selectedIDType,
                  hint: Text('Select ID Type',
                      style: context.textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          fontFamily: 'SFPRODISPLAYREGULAR')),
                  isExpanded: true,
                  items: _idTypes.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value,
                          style: context.textTheme.bodySmall!.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              fontFamily: 'SFPRODISPLAYREGULAR')),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedIDType = newValue;
                    });
                  },
                ),
              ),

              ///image upload
              const VerticalSpacing(40),

              CustomPaint(
                  painter: DashedBorderPainter(),
                  child: SizedBox(
                      height: 100,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                                onTap: _pickFiles,
                                child: SvgPicture.asset(Assets.assetsSvgsDoc)),

                            ///hint
                            Text('Upload Document',
                                style: context.textTheme.bodySmall!.copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    fontFamily: 'SFPRODISPLAYREGULAR')),
                          ],
                        ),
                      ))),

              ///display of selected doc
              const SizedBox(height: 20),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // Number of items per row
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: _selectedFiles.length,
                  itemBuilder: (context, index) {
                    PlatformFile file = _selectedFiles[index];
                    return Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                          ),
                          child: file.extension == 'pdf'
                              ? const Center(
                                  child: Icon(Icons.picture_as_pdf,
                                      size: 50, color: Colors.red),
                                )
                              : Image.file(
                                  File(file.path!),
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton(
                              onPressed: () => _removeFile(index),
                              icon: const Icon(Icons.cancel, color: AppColors.black)),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              AppElevatedButton.large(
                onPressed: (){
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const VehicleRegistrationScreen()),
                  );
                },
                text: 'Save',
                backgroundColor: AppColors.black,
                foregroundColor: AppColors.yellow,
              ),
            ],
          ))),
    );
  }
}
