import 'package:flutter/painting.dart';

List<Color> generateColorsFromAddress(String address) {
  final colors = hslTriad(address.hashCode % 360, 1, 0.5);

  return [
    HSLColor.fromAHSL(1, colors[0][0], colors[0][1], colors[0][2]).toColor(),
    HSLColor.fromAHSL(1, colors[1][0], colors[1][1], colors[1][2]).toColor(),
  ];
}

List<List<double>> hslTriad(double h, double s, double l) {
  return [
    [h, s, l],
    [(h + 120) % 360, s, l],
    [(h + 240) % 360, s, l],
  ];
}
