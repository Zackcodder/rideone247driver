import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_on_driver/core/constants/colors.dart';

class CustomSwitch extends StatelessWidget {
  const CustomSwitch({super.key, required this.value, required this.onChanged});
  final bool value;
  final Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInCirc,
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        padding: const EdgeInsets.all(2),
        width: 75.w,
        height: 35.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.r),
          border: Border.all(
            color: AppColors.black, // Change border color based on value
            width: 1.0, // Adjust the width as needed
          ),
          color: value ? AppColors.green : Colors.transparent,
        ),
        child: Container(
          width: 30.w,
          height: 30.h,
          decoration: BoxDecoration(
            color: value ? AppColors.green : AppColors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.black, // Change border color based on value
              width: 1.0, // Adjust the width as needed
            ),
          ),
          child: const Center(
            child: Icon(
              Icons.directions_car_outlined,
              color: AppColors.black,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
