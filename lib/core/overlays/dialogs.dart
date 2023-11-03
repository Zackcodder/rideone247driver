import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_on_driver/core/constants/colors.dart';
import 'package:ride_on_driver/core/extensions/build_context_extensions.dart';
import 'package:ride_on_driver/core/extensions/widget_extensions.dart';
import 'package:ride_on_driver/widgets/app_elevated_button.dart';
import 'package:ride_on_driver/widgets/app_text_field.dart';
import 'package:ride_on_driver/widgets/currency_widget.dart';
import 'package:ride_on_driver/widgets/spacing.dart';

abstract class AppDialogs {
  static Future<void> showNegotialtionDialog(BuildContext context) async {
    TextEditingController controller = TextEditingController(text: '245');
    await showDialog(
      context: context,
      useSafeArea: false,
      barrierColor: AppColors.black.withOpacity(0.8),
      builder: (context) => StatefulBuilder(builder: (context, ss) {
        return Dialog(
          elevation: 0,
          insetPadding: const EdgeInsets.all(20),
          backgroundColor: AppColors.white,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    Icons.close,
                    size: 30.w,
                    color: AppColors.black,
                  ).onTap(context.pop),
                ),
                CurrencyWidget(
                  price: controller.text.isEmpty ? 0 : int.parse(controller.text),
                  fontSize: 30.sp,
                  iconSize: 30.w,
                ),
                const VerticalSpacing(10),
                Row(
                  children: [10, 20, 30, 40, 50].map((addition) {
                    return GestureDetector(
                      onTap: () => ss(
                        () => controller.text = (int.parse(controller.text) + addition).toString(),
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: AppColors.yellow,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '+$addition',
                          style: context.textTheme.bodyMedium!.copyWith(
                            color: AppColors.black,
                          ),
                        ),
                      ),
                    ).expand();
                  }).toList(),
                ),
                const VerticalSpacing(10),
                Text(
                  'OR',
                  style: context.textTheme.bodyMedium!.copyWith(
                    color: AppColors.black,
                  ),
                ),
                const VerticalSpacing(10),
                const AppTextField(hintText: 'Please Enter Price'),
                const VerticalSpacing(10),
                AppElevatedButton(
                  onPressed: context.pop,
                  text: 'Submit',
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
