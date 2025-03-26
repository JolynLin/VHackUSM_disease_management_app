import 'package:flutter/material.dart';

class DropdownArrowIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(6.5, 7);
    path.lineTo(13, 0);
    path.lineTo(0, 0);
    path.lineTo(6.5, 7);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
