import 'package:flutter/material.dart';

Color generateUniqueColorById(String id) {
  int hash = 5381;
  for (int i = 0; i < id.length; i++) {
    hash = ((hash << 5) + hash) + id.codeUnitAt(i);
  }

  final double hue = (hash.abs() % 360).toDouble();

  return HSLColor.fromAHSL(1.0, hue, 0.65, 0.50).toColor();
}
