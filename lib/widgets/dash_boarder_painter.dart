import 'package:flutter/material.dart';

class DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    double dashWidth = 5, dashSpace = 5, startX = 0;
    final double totalWidth = size.width;
    while (startX < totalWidth) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }

    double startY = 0;
    final double totalHeight = size.height;
    while (startY < totalHeight) {
      canvas.drawLine(
        Offset(totalWidth, startY),
        Offset(totalWidth, startY + dashWidth),
        paint,
      );
      startY += dashWidth + dashSpace;
    }

    startX = totalWidth;
    while (startX > 0) {
      canvas.drawLine(
        Offset(startX, totalHeight),
        Offset(startX - dashWidth, totalHeight),
        paint,
      );
      startX -= dashWidth + dashSpace;
    }

    startY = totalHeight;
    while (startY > 0) {
      canvas.drawLine(
        Offset(0, startY),
        Offset(0, startY - dashWidth),
        paint,
      );
      startY -= dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
