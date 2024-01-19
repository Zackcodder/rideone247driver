import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/constants/colors.dart';
import '../core/extensions/build_context_extensions.dart';
import '../core/extensions/widget_extensions.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.isPassword = false,
    this.controller,
    this.validator,
  this.capitalization = TextCapitalization.none,
    this.keyboardType = TextInputType.text,
    this.dense = true,
    this.onTap,
    this.onChanged,
    this.autoFocus = false,
    this.maxLines = 1,
    this.maxLength,
    this.readOnly = false,
    this.hasBorder = true,
  });

  final bool dense;
  final String hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool isPassword;
  final bool autoFocus;
  final bool readOnly;
  final TextEditingController? controller;
  final TextCapitalization capitalization;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final VoidCallback? onTap;
  final Function(String)? onChanged;
  final int maxLines;
  final int? maxLength;
  final bool hasBorder;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool visible = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350.w,
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
        readOnly: widget.readOnly,
        cursorRadius: const Radius.circular(0),
        style: context.textTheme.bodySmall!.copyWith(
          color: AppColors.black,
        ),
        autofocus: widget.autoFocus,
        obscureText: widget.isPassword && !visible ? true : false,
        keyboardType: widget.keyboardType,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          isDense: widget.dense,
          hintText: widget.hintText,
          fillColor: AppColors.lightGrey,
          filled: true,
          prefixIcon: widget.maxLines > 1 && widget.prefixIcon != null
              ? Column(
                  children: [if (widget.prefixIcon != null) widget.prefixIcon!],
                )
              : widget.prefixIcon,
          suffixIcon: widget.isPassword
              ? Icon(
                  visible
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_rounded,
                  color: AppColors.grey,
                ).onTap(() {
                  setState(() => visible = !visible);
                })
              : widget.suffixIcon,
          hintStyle: context.textTheme.bodySmall!
              .copyWith(color: AppColors.black.withOpacity(0.5)),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: !widget.hasBorder || widget.readOnly
                  ? AppColors.lightGrey
                  : AppColors.yellow,
            ),
            borderRadius: BorderRadius.all(Radius.circular(10.r)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.lightGrey),
            borderRadius: BorderRadius.all(Radius.circular(10.r)),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: !widget.hasBorder || widget.readOnly
                  ? AppColors.lightGrey
                  : AppColors.error,
            ),
            borderRadius: BorderRadius.all(Radius.circular(10.r)),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: !widget.hasBorder || widget.readOnly
                  ? AppColors.lightGrey
                  : AppColors.error,
            ),
            borderRadius: BorderRadius.all(Radius.circular(10.r)),
          ),
        ),
      ),
    );
  }
}
