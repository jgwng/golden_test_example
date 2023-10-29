import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  return GoldenToolkit.runWithConfiguration(
        () async {

          // final fontLoader = FontLoader('fontName')
          //   ..addFont(rootBundle.load('assets/fonts/fontName-Bold.ttf'))
          //   ..addFont(rootBundle.load('assets/fonts/fontName-Medium.ttf'))
          //   ..addFont(rootBundle.load('assets/fonts/fontName-Regular.ttf'))
          // await fontLoader.load();
      await loadAppFonts();
      await testMain();
    },
    config: GoldenToolkitConfiguration(
      // Currently, goldens are not generated/validated in CI for this repo. We have settled on the goldens for this package
      // being captured/validated by developers running on MacOSX. We may revisit this in the future if there is a reason to invest
      // in more sophistication
      skipGoldenAssertion: () => !Platform.isMacOS,
    ),
  );
}

extension SetScreenSize on WidgetTester {
  Future<void> setScreenSize(
      {double width = 540,
        double height = 960,
        double pixelDensity = 1}) async {
    final size = Size(width, height);
    await binding.setSurfaceSize(size);
    view.physicalSize = size;
    view.devicePixelRatio = pixelDensity;
  }
}