import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_test_example/main.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import 'flutter_test_config.dart';

// TODO: Our calculated height is about 25 pixels too long possibly because of reserved space

/// Converts the size to a DPR 1.0 size and get the correct relative sizing
/// The test canvas / web is a DPR=1.0 device
/// This only provides the expected results if we load our fonts because the
/// Ahem font is much wider than our standard font
///
/// This can be used in two ways
/// 1. accept the device physical dimensions and the DPR as calculated by the Google viewport
/// 1. Accept the logical viewport dimensions and a DPR of 1.0
Future<void> configureTesterForSize(
    WidgetTester tester, Size canvasSize, double devicePixelRatio) async {
  Size convertedSize = Size(canvasSize.width / devicePixelRatio,
      canvasSize.height / devicePixelRatio);
  await tester.binding.setSurfaceSize(convertedSize);
  tester.view.physicalSize = convertedSize;
  tester.view.devicePixelRatio = 1.0;

}

void main() {
  testGoldens('DeviceBuilder - multiple scenarios - with onCreate',
          (tester) async {
        final builder = DeviceBuilder()
          ..overrideDevicesForAllScenarios(devices: [
            Device.phone,
            Device.iphone11,
          ])
          ..addScenario(
            widget: MyHomePage(),
            name: 'tap once',
            onCreate: (scenarioWidgetKey) async {
              final emailField = find.descendant(
                of: find.byKey(scenarioWidgetKey),
                matching: find.bySemanticsLabel('Email'),
              );
              await tester.enterText(emailField, "testing");
              await tester.pumpAndSettle();
            },
          );

        await tester.pumpDeviceBuilder(builder);

        await screenMatchesGolden(tester, 'flutter_demo_page_multiple_scenarios');
      });
}