import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/constants/colors.dart';
import '../core/extensions/build_context_extensions.dart';

class RoundFancyTextField extends StatefulWidget {
  const RoundFancyTextField({
    super.key,
    required this.hintText,
    this.prefixIcon,
    required this.suffix,
    this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.dense = true,
    this.onTap,
    this.onChanged,
    this.autoFocus = false,
    this.maxLines = 1,
    this.maxLength,
  });

  final bool dense;
  final String hintText;
  final Widget? prefixIcon;
  final Widget suffix;
  final bool autoFocus;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final VoidCallback? onTap;
  final Function(String)? onChanged;
  final int maxLines;
  final int? maxLength;

  @override
  State<RoundFancyTextField> createState() => _RoundFancyTextFieldState();
}

class _RoundFancyTextFieldState extends State<RoundFancyTextField> {
  bool visible = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350.w,
      height: 60.h,
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              onTap: widget.onTap,
              validator: widget.validator,
              controller: widget.controller,
              textAlignVertical: TextAlignVertical.center,
              obscuringCharacter: '*',
              inputFormatters: [
                LengthLimitingTextInputFormatter(widget.maxLength),
              ],
              maxLines: widget.maxLines,
              readOnly: widget.onTap != null ? true : false,
              cursorRadius: const Radius.circular(0),
              style: context.textTheme.bodySmall!.copyWith(
                color: AppColors.black,
              ),
              autofocus: widget.autoFocus,
              keyboardType: widget.keyboardType,
              onChanged: widget.onChanged,
              decoration: InputDecoration(
                isDense: widget.dense,
                hintText: widget.hintText,
                fillColor: AppColors.lightGrey,
                filled: true,
                prefixIcon: widget.prefixIcon,
                hintStyle:
                    context.textTheme.bodySmall!.copyWith(color: AppColors.black.withOpacity(0.5)),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.lightGrey),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(100.r),
                    bottomLeft: Radius.circular(100.r),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.lightGrey),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(100.r),
                    bottomLeft: Radius.circular(100.r),
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.lightGrey),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(100.r),
                    bottomLeft: Radius.circular(100.r),
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.lightGrey),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(100.r),
                    bottomLeft: Radius.circular(100.r),
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: 80.w,
            height: 53.h,
            decoration: BoxDecoration(
              color: AppColors.yellow,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(100.r),
                bottomRight: Radius.circular(100.r),
              ),
            ),
            child: widget.suffix,
          ),
        ],
      ),
    );
  }
}
