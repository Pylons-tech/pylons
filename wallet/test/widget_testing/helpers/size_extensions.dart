import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

extension SetScreenSize on WidgetTester {
  Future<void> setScreenSize({double width = 540, double height = 960, double pixelDensity = 1}) async {
    final size = Size(width, height);
    await binding.setSurfaceSize(size);
    view.physicalSize = size;
    view.devicePixelRatio = pixelDensity;
  }

  Future testAppForWidgetTesting(
    Widget child, {
    Duration duration = Duration.zero,
  }) {
    return pumpWidget(Builder(builder: (context) {
      return ScreenUtilInit(
          designSize: const Size(480, 965),
          builder: (_, __) {
            return MaterialApp(
              home: Builder(builder: (context) {
                return child;
              }),
            );
          });
    }), duration);
  }
}
