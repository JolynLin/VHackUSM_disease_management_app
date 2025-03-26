import 'package:flutter/material.dart';

class UploadIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    // Draw upload arrow and tray
    Path path = Path();

    // Arrow and line part
    path.moveTo(size.width * 0.49, size.width * 0.55);
    path.lineTo(size.width * 0.49, size.width * 0.45);
    path.lineTo(size.width * 0.46, size.width * 0.48);
    path.lineTo(size.width * 0.445, size.width * 0.465);
    path.lineTo(size.width * 0.5, size.width * 0.41);
    path.lineTo(size.width * 0.555, size.width * 0.465);
    path.lineTo(size.width * 0.54, size.width * 0.48);
    path.lineTo(size.width * 0.51, size.width * 0.45);
    path.lineTo(size.width * 0.51, size.width * 0.55);
    path.lineTo(size.width * 0.49, size.width * 0.55);
    path.close();

    // Tray part
    path.moveTo(size.width * 0.435, size.width * 0.59);
    path.lineTo(size.width * 0.435, size.width * 0.57);
    path.lineTo(size.width * 0.41, size.width * 0.57);
    path.lineTo(size.width * 0.41, size.width * 0.54);
    path.lineTo(size.width * 0.435, size.width * 0.54);
    path.lineTo(size.width * 0.435, size.width * 0.57);
    path.lineTo(size.width * 0.565, size.width * 0.57);
    path.lineTo(size.width * 0.565, size.width * 0.54);
    path.lineTo(size.width * 0.59, size.width * 0.54);
    path.lineTo(size.width * 0.59, size.width * 0.57);
    path.lineTo(size.width * 0.565, size.width * 0.57);
    path.lineTo(size.width * 0.565, size.width * 0.59);
    path.lineTo(size.width * 0.435, size.width * 0.59);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}