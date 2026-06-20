// bnb_custom_painter.dart
import 'package:flutter/material.dart';

class BNBCustomPainter extends CustomPainter {
  final Color color;
  final Color shadowColor;

  const BNBCustomPainter({
    required this.color,
    this.shadowColor = Colors.black,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    Path path = Path();
    double width = size.width;
    double height = size.height;
    double center = width / 2;
    double cornerRadius = 30;
    double holeWidth = 100;
    double holeDepth = 48;

    path.moveTo(0, cornerRadius);
    path.quadraticBezierTo(0, 0, cornerRadius, 0);
    path.lineTo(center - holeWidth, 0);
    path.cubicTo(
      center - (holeWidth * 0.5), 0,
      center - (holeWidth * 0.65), holeDepth,
      center, holeDepth,
    );
    path.cubicTo(
      center + (holeWidth * 0.65), holeDepth,
      center + (holeWidth * 0.5), 0,
      center + holeWidth, 0,
    );
    path.lineTo(width - cornerRadius, 0);
    path.quadraticBezierTo(width, 0, width, cornerRadius);
    path.lineTo(width, height);
    path.lineTo(0, height);
    path.lineTo(0, cornerRadius);
    path.close();

    canvas.drawShadow(path, shadowColor.withOpacity(0.3), 8.0, false);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(BNBCustomPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.shadowColor != shadowColor;
}