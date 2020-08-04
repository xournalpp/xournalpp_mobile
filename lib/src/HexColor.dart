import 'dart:ui';

/// creates a [Color] from an ARGB or RGB hex [String] known from HTML etc.
/// source: https://stackoverflow.com/a/53905427
class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    if (hexColor.length == 8) {
      hexColor = hexColor.substring(6, 8) + hexColor.substring(0, 6);
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
