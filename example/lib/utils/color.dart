class Colors {
  static const Color black = Color(0x000000);
  static const Color white = Color(0xFFFFFF);
  static const Color red = Color(0xFF0000);
  static const Color green = Color(0x00FF00);
  static const Color blue = Color(0x0000FF);

  const Colors._();
}

class Color {
  final int value;

  const Color(this.value);

  String toRGB() {
    final r = (value >> 16) & 255;
    final g = (value >> 8) & 255;
    final b = value & 255;
    return '$r;$g;$b';
  }
}
