import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CurrencyWidget extends StatelessWidget {
  const CurrencyWidget({
    super.key,
    required this.price,
    this.color,
    this.fontSize = 14,
    this.iconSize,
    this.fontWeight = FontWeight.normal,
  });
  final num price;
  final Color? color;
  final double fontSize;
  final FontWeight fontWeight;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      '₦ $price',
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.notoSans().copyWith(
        color: color,
        fontSize: fontSize.sp,
        fontWeight: fontWeight,
      ),
    );
  }
}
