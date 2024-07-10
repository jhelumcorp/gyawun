import 'package:flutter/material.dart';

Color greyColor = Colors.grey.withAlpha(100);
Color darkGreyColor = Colors.grey.withAlpha(70);
const MaterialColor primaryBlack = MaterialColor(
  0xFF000000,
  <int, Color>{
    50: Color(0xFF737373), // Slightly lighter black
    100: Color(0xFF666666), // Slightly lighter black
    200: Color(0xFF595959), // Slightly lighter black
    300: Color(0xFF4D4D4D), // Slightly lighter black
    400: Color(0xFF404040), // Slightly lighter black
    500: Color(0xFF333333), // Slightly lighter black
    600: Color(0xFF262626), // Slightly lighter black
    700: Color(0xFF1A1A1A), // Slightly lighter black
    800: Color(0xFF0D0D0D), // Slightly lighter black
    900: Color(0xFF000000), // Pure black
  },
);

const MaterialColor primaryWhite = MaterialColor(
  0xFFFFFFFF,
  <int, Color>{
    50: Color(0xFFEDEDED), // Slightly darker white
    100: Color(0xFFEFEEEE), // Slightly darker white
    200: Color(0xFFF1F1F1), // Slightly darker white
    300: Color(0xFFF3F3F3), // Slightly darker white
    400: Color(0xFFF5F5F5), // Slightly darker white
    500: Color(0xFFF7F7F7), // Slightly darker white
    600: Color(0xFFF9F9F9), // Slightly darker white
    700: Color(0xFFFBFBFB), // Slightly darker white
    800: Color(0xFFFDFDFD), // Slightly darker white
    900: Color(0xFFFFFFFF), // Pure white
  },
);
