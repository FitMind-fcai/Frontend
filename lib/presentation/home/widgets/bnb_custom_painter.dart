import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BNBCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    Path path = Path();
    double width = size.width;
    double height = size.height;
    double center = width / 2;
    double cornerRadius = 30;

    double holeWidth = 100;
    double holeDepth = 48;

    // Top-left rounded corner
    path.moveTo(0, cornerRadius);
    path.quadraticBezierTo(0, 0, cornerRadius, 0);

    // Line to notch start
    path.lineTo(center - holeWidth, 0);

    // Left curve into notch
    path.cubicTo(
      center - (holeWidth * 0.5), 0,
      center - (holeWidth * 0.65), holeDepth,
      center, holeDepth,
    );

    // Right curve out of notch
    path.cubicTo(
      center + (holeWidth * 0.65), holeDepth,
      center + (holeWidth * 0.5), 0,
      center + holeWidth, 0,
    );

    // Top-right rounded corner
    path.lineTo(width - cornerRadius, 0);
    path.quadraticBezierTo(width, 0, width, cornerRadius);

    // Right side, bottom, left side
    path.lineTo(width, height);
    path.lineTo(0, height);
    path.lineTo(0, cornerRadius);

    path.close();

    canvas.drawShadow(path, Colors.black.withOpacity(0.3), 8.0, false);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}