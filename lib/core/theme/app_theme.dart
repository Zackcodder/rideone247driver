import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/colors.dart';
import '../constants/fonts.dart';

abstract class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary: AppColors.black,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      iconTheme: const IconThemeData(
        color: AppColors.black,
      ),
      titleTextStyle: TextStyle(
        color: AppColors.black,
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
      ),
    ),
    scaffoldBackgroundColor: AppColors.lightGrey,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.yellow,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.black,
        side: BorderSide(
          color: AppColors.yellow,
          width: 1.w,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    ),
    iconTheme: const IconThemeData(
      color: AppColors.grey,
    ),
    checkboxTheme: CheckboxThemeData(
      shape: const CircleBorder(),
      side: const BorderSide(color: AppColors.grey),
      fillColor: WidgetStateProperty.all(AppColors.yellow),
      checkColor: WidgetStateProperty.all(Colors.white),
    ),
    textTheme: Typography.englishLike2018
        .apply(
          fontSizeFactor: 1.sp,
          fontFamily: AppFonts.sfCompact,
        )
        .copyWith(
          bodySmall: TextStyle(
            color: AppColors.black,
            fontSize: 14.sp,
            fontWeight: FontWeight.w300,
          ),
          bodyMedium: TextStyle(
            color: AppColors.black,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
          bodyLarge: TextStyle(
            color: AppColors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
          titleSmall: TextStyle(
            color: AppColors.black,
            fontSize: 24.sp,
            fontWeight: FontWeight.w500,
          ),
          titleMedium: TextStyle(
            color: AppColors.black,
            fontSize: 28.sp,
            fontWeight: FontWeight.w700,
          ),
          titleLarge: TextStyle(
            color: AppColors.black,
            fontSize: 38.sp,
            fontWeight: FontWeight.w400,
          ),
          displayMedium: TextStyle(
            color: AppColors.black,
            fontSize: 44.sp,
            fontWeight: FontWeight.w700,
          ),
          displayLarge: TextStyle(
            color: AppColors.black,
            fontSize: 50.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
  );
}
