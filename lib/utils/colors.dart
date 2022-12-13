import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

Color primaryColor = const Color.fromARGB(255, 205, 230, 248);
Color secondaryColor = const Color.fromARGB(255, 231, 243, 251);
Color tertiaryColor = const Color.fromARGB(255, 216, 236, 249);
Color grayColor = const Color.fromARGB(255, 50, 50, 51);

generateColor(image) async {
  PaletteGenerator paletteGenerator = await PaletteGenerator.fromImageProvider(
    Image.network(image).image,
  );
  return paletteGenerator;
}

Color? lighten(Color? color, [double amount = 0.2]) {
  assert(amount >= 0 && amount <= 1);
  if (color == null) return color;
  final hsl = HSLColor.fromColor(color);
  final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

  return hslLight.toColor();
}
