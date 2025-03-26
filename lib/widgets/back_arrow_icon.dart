import 'package:flutter/material.dart';

class BackArrowIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = const Color(0xFF1D1B20)
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(16.9542, 23.2916);
    path.lineTo(29.0876, 33.325);
    path.lineTo(26.0001, 35.8333);
    path.lineTo(8.66675, 21.5);
    path.lineTo(26.0001, 7.16663);
    path.lineTo(29.0876, 9.67496);
    path.lineTo(16.9542, 19.7083);
    path.lineTo(43.3334, 19.7083);
    path.lineTo(43.3334, 23.2916);
    path.lineTo(16.9542, 23.2916);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}