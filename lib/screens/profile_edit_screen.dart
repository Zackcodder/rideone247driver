import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker_widget/image_picker_widget.dart';
import 'package:ride_on_driver/core/constants/assets.dart';
import 'package:ride_on_driver/core/constants/colors.dart';
import 'package:ride_on_driver/core/extensions/build_context_extensions.dart';
import 'package:ride_on_driver/core/extensions/widget_extensions.dart';
import 'package:ride_on_driver/widgets/app_elevated_button.dart';
import 'package:ride_on_driver/widgets/app_text_field.dart';
import 'package:ride_on_driver/widgets/spacing.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  bool editing = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: true,
        scrolledUnderElevation: 0,
        actions: [
          if (!editing)
            IconButton(
              onPressed: () {
                setState(() {
                  editing = true;
                });
              },
              icon: const Icon(Icons.edit),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              ImagePickerWidget(
                backgroundColor: AppColors.lightGrey,
                diameter: 120.r,
                initialImage: const AssetImage(Assets.assetsImagesDriverProfile),
                iconAlignment: Alignment.bottomRight,
                shape: ImagePickerWidgetShape.circle,
                editIcon: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.r)),
                  ),
                  color: AppColors.lightGrey,
                  child: const Icon(Icons.edit, color: AppColors.black),
                ),
                isEditable: true,
                shouldCrop: false,
                imagePickerOptions: ImagePickerOptions(imageQuality: 65),
                modalOptions: ModalOptions(
                  title: const Text(''),
                  cameraColor: AppColors.black,
                  cameraText: const Text('Camera'),
                  galleryColor: AppColors.black,
                  galleryText: const Text('Gallery'),
                ),
                onChange: (file) {},
              ),
              const VerticalSpacing(20),
              AppTextField(
                hintText: 'Name',
                prefixIcon: const Icon(Icons.person_rounded, color: AppColors.grey),
                readOnly: !editing,
              ),
              const VerticalSpacing(10),
              AppTextField(
                hintText: 'Email',
                prefixIcon: const Icon(Icons.alternate_email_rounded, color: AppColors.grey),
                readOnly: !editing,
              ),
              const VerticalSpacing(10),
              AppTextField(
                hintText: 'Phone Number',
                prefixIcon: const Icon(Icons.phone_rounded, color: AppColors.grey),
                readOnly: !editing,
              ),
              const VerticalSpacing(10),
              AppTextField(
                hintText: 'Password',
                prefixIcon: const Icon(Icons.lock_rounded, color: AppColors.grey),
                readOnly: !editing,
                isPassword: true,
              ),
              const VerticalSpacing(10),
              AppTextField(
                hintText: 'Confirm Password',
                prefixIcon: const Icon(Icons.lock_rounded, color: AppColors.grey),
                readOnly: !editing,
                isPassword: true,
              ),
              const VerticalSpacing(50),
              if (editing)
                AppElevatedButton.large(
                  onPressed: () {
                    context.pop();
                  },
                  text: 'Save',
                ),
              const VerticalSpacing(20),
              Text(
                'Terms & Conditions',
                style: context.textTheme.bodyMedium!.copyWith(
                  decoration: TextDecoration.underline,
                ),
              )
            ],
          ),
        ),
      ),
    ).onTap(context.unfocus);
  }
}
