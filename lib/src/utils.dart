int hexColorToInt(String? color) {
  if (color?.length != 6) {
    return 0xffffffff;
  }
  return int.tryParse('ff$color', radix: 16) ?? 0xffffffff;
}

String intColorToHex(int? color) {
  if (color == null) {
    return 'ffffff';
  }
  return color.toRadixString(16).substring(2).padRight(6, '0');
}
