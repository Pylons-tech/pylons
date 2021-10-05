import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

extension SetScreenSize on WidgetTester {
  Future<void> setScreenSize({double width = 540, double height = 960, double pixelDensity = 1}) async {
    final size = Size(width, height);
    await binding.setSurfaceSize(size);
    binding.window.physicalSizeTestValue = size;
    binding.window.devicePixelRatioTestValue = pixelDensity;
  }


  Future testAppForWidgetTesting(Widget child) {
    return pumpWidget( MaterialApp(
        home: child));
  }

}
