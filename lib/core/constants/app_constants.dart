import 'package:flutter/material.dart';

class AppConstants {
  // Colors
  static const Color primaryColor = Color(0xFFF97316);
  static const Color secondaryColor = Colors.black;
  static const Color backgroundColor = Color(0xFFFFFFFF);
  static const Color textColor = Color(0xFF000000);
  static const Color lightTextColor = Color(0xFF888888);

  // Padding
  static const double paddingXS = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 16.0;
  static const double paddingL = 24.0;
  static const double paddingXL = 32.0;

  // Spacing (vertical & horizontal)
  static const SizedBox verticalSpaceXS = SizedBox(height: 4);
  static const SizedBox verticalSpaceS = SizedBox(height: 8);
  static const SizedBox verticalSpaceM = SizedBox(height: 16);
  static const SizedBox verticalSpaceL = SizedBox(height: 24);
  static const SizedBox verticalSpaceXL = SizedBox(height: 32);
  static const SizedBox verticalSpaceXXL = SizedBox(height: 40);

  static const SizedBox horizontalSpaceXS = SizedBox(width: 4);
  static const SizedBox horizontalSpaceS = SizedBox(width: 8);
  static const SizedBox horizontalSpaceM = SizedBox(width: 16);
  static const SizedBox horizontalSpaceL = SizedBox(width: 24);
  static const SizedBox horizontalSpaceXL = SizedBox(width: 32);
  static const SizedBox horizontalSpaceXXL = SizedBox(height: 40);


  // Font Families
  static const String fontRegular = 'WorkSans';
  static const String fontBold = 'WorkSansBold';


  static const FontWeight thinBold = FontWeight.w100;
  static const FontWeight extraLightBold = FontWeight.w200;
  static const FontWeight lightBold = FontWeight.w300;
  static const FontWeight regularBold = FontWeight.w400;
  static const FontWeight mediumBold = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;
  static const FontWeight blackBold = FontWeight.w900;

  // Font Sizes
  static const double fontSizeXS = 8.0;
  static const double fontSizeS = 10.0;
  static const double fontSizeM = 12.0;
  static const double fontSizeL = 16.0;
  static const double fontSizeXL = 24.0;
  static const double fontSizeXXL = 32.0;

  // Example TextStyles
  static TextStyle heading1 = TextStyle(
    fontFamily: fontRegular,
    fontWeight: FontWeight.bold,
    fontSize: fontSizeXL,
    color: textColor,
  );

  static TextStyle bodyText = TextStyle(
    fontFamily: fontRegular,
    fontSize: fontSizeM,
    color: textColor,
  );
}
