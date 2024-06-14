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
        padding: const EdgeInsets.all(5),
        width: 125.w,
        height: 50.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.r),
          border: Border.all(
            color: AppColors.black, // Change border color based on value
            width: 1.0, // Adjust the width as needed
          ),
          color: value ? Colors.lightGreen : Colors.transparent,
        ),
        child: value ?
        Center(
          child:
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text('ONLINE'),
              Container(
                height: 76.h,
                width: 40.w,
                margin: const EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                  color: value ? AppColors.green : AppColors.white,
                  borderRadius: BorderRadius.circular(50.r),
                  border: Border.all(
                    color: AppColors.black, // Change border color based on value
                    width: 1.0, // Adjust the width as needed
                  ),
                ),
                child: const Icon(
                  Icons.car_repair,
                  color: AppColors.black,
                  size: 20,
                ),
              ),
            ],
          )
        ) :
        Center(
          child:
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 76.h,
                width: 40.w,
                margin: const EdgeInsets.only(left: 2, right: 5),
                decoration: BoxDecoration(
                  color: value ? AppColors.green : AppColors.white,
                  borderRadius: BorderRadius.circular(50.r),
                  border: Border.all(
                    color: AppColors.black, // Change border color based on value
                    width: 1.0, // Adjust the width as needed
                  ),
                ),
                child: const Icon(
                Icons.car_repair,
                color: AppColors.black,
                size: 30,
                      ),
              ),

              const Text('OFFLINE'),
            ],
          ),
            ),
      ),
    );
  }
}
