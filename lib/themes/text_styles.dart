import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final defaultFontStyle = GoogleFonts.poppins();
TextStyle bigTextStyle(BuildContext context,
    {double opacity = 1, bool bold = true}) {
  return defaultFontStyle.copyWith(
    fontSize: 30,
    fontWeight: bold ? FontWeight.w900 : FontWeight.normal,
    color: Theme.of(context).textTheme.bodyMedium?.color,
  );
}

TextStyle mediumTextStyle(BuildContext context,
    {double opacity = 1, bool bold = true}) {
  return defaultFontStyle.copyWith(
    fontSize: 24,
    fontWeight: bold ? FontWeight.w900 : FontWeight.normal,
    color: Theme.of(context).textTheme.bodyMedium?.color,
  );
}

TextStyle textStyle(BuildContext context,
    {double opacity = 1, bool bold = true}) {
  return defaultFontStyle.copyWith(
    fontSize: 19,
    fontWeight: bold ? FontWeight.w600 : FontWeight.normal,
    color: Theme.of(context).textTheme.bodyMedium?.color,
  );
}

TextStyle subtitleTextStyle(BuildContext context,
    {double opacity = 1, bool bold = false}) {
  return defaultFontStyle.copyWith(
    fontSize: 15,
    fontWeight: bold ? FontWeight.w600 : FontWeight.normal,
    color: Colors.grey.withAlpha(200),
  );
}

TextStyle smallTextStyle(BuildContext context,
    {double opacity = 1, bool bold = false}) {
  return defaultFontStyle.copyWith(
    fontSize: 13,
    fontWeight: bold ? FontWeight.w600 : FontWeight.normal,
    color: Theme.of(context).textTheme.bodyMedium?.color,
  );
}

TextStyle tinyTextStyle(BuildContext context,
    {double opacity = 1, bool bold = false}) {
  return defaultFontStyle.copyWith(
    fontSize: 11,
    fontWeight: bold ? FontWeight.w600 : FontWeight.normal,
    color: Theme.of(context).textTheme.bodyMedium?.color,
  );
}

TextStyle customTextStyle(BuildContext context,
    {double opacity = 1, bool bold = false, double? fontSize}) {
  return defaultFontStyle.copyWith(
      fontSize: fontSize,
      fontWeight: bold ? FontWeight.w600 : FontWeight.normal);
}
