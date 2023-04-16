import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart' as f;
import 'package:flutter_test/flutter_test.dart';

export 'package:flutter_test/flutter_test.dart' hide group, testWidgets;

typedef TestCallback = Future<void> Function(WidgetTester tester);

final _setupCallbacks = <Function, TestCallback>{};
final _tearDownCallbacks = <Function, TestCallback>{};

Function? _currentBody;

void group(String description, VoidCallback body) {
  f.group(description, () {
    _currentBody = body;
    body();
    _currentBody = null;
  });
}

void setUpWidgets(TestCallback callback) {
  if (_currentBody == null) {
    throw 'not in a group';
  }
  _setupCallbacks[_currentBody!] = callback;
}

void tearDownWidgets(TestCallback callback) {
  if (_currentBody == null) {
    throw 'not in a group';
  }
  _tearDownCallbacks[_currentBody!] = callback;
}

void testWidgets(
  String description,
  TestCallback callback, {
  bool runSetUpWidgets = true,
  bool? skip,
  f.Timeout? timeout,
  bool semanticsEnabled = true,
  TestVariant<Object?> variant = const DefaultTestVariant(),
  dynamic tags,
}) {
  final setupWidgets = _setupCallbacks[_currentBody];
  final tearDownWidgets = _tearDownCallbacks[_currentBody];
  f.testWidgets(
    description,
    (tester) async {
      await _testWidgetsBody(
        tester: tester,
        runSetUpWidgets: runSetUpWidgets,
        callback: callback,
        setupWidgets: setupWidgets,
        tearDownWidgets: tearDownWidgets,
      );
    },
    skip: skip,
    timeout: timeout,
    semanticsEnabled: semanticsEnabled,
    variant: variant,
    tags: tags,
  );
}

Future<void> _testWidgetsBody({
  required WidgetTester tester,
  required bool runSetUpWidgets,
  required TestCallback callback,
  required TestCallback? setupWidgets,
  required TestCallback? tearDownWidgets,
}) async {
  if (runSetUpWidgets) {
    await setupWidgets?.call(tester);
  }
  await callback(tester);
  if (runSetUpWidgets) {
    await tearDownWidgets?.call(tester);
  }
}