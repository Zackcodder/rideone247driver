import 'package:flutter/material.dart';

class ProfileClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final width = size.width;
    final height = size.height;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(0, height * 0.6)
      ..quadraticBezierTo(
        0,
        size.height * 0.8,
        width * 0.1,
        size.height,
      )
      ..lineTo(width * 0.9, height)
      ..quadraticBezierTo(
        width,
        height * 0.8,
        width,
        height * 0.6,
      )
      ..lineTo(width, 0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
