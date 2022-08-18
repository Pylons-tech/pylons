import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/pages/settings/screens/recovery_screen/screens/practice_test.dart';
import 'package:pylons_wallet/services/repository/repository.dart';
import '../../mocks/mock_repository.dart';
import '../helpers/size_extensions.dart';

void main() {
  late Repository repository;
  late PracticeTestViewModel practiceTestViewModel;
  setUp(() {
    repository = MockRepository();
    GetIt.I.registerSingleton(repository);
    practiceTestViewModel = PracticeTestViewModel(repository);
    GetIt.I.registerSingleton(practiceTestViewModel);
  });
  tearDown(() {
    GetIt.I.reset();
  });
  testWidgets(
    'should check confirm practice test renders correct widgets',
    (tester) async {
      final practiceTextFinder = find.text('practice_test');
      final practiceRecoveryPhraseFinder =
          find.text('place_your_recovery_phrase_in_correct_order');
      final submitTextFinder = find.text('submit');
      final resetTextFinder = find.text('reset');
      final gridView = find.byType(GridView);
      await tester.setScreenSize();
      await tester.testAppForWidgetTesting(const PracticeTest());

      expect(practiceTextFinder, findsOneWidget);
      expect(practiceRecoveryPhraseFinder, findsOneWidget);
      expect(
        submitTextFinder,
        findsOneWidget,
      );
      expect(resetTextFinder, findsOneWidget);
      expect(gridView, findsNothing);
    },
  );

  testWidgets(
      'should drag widget from bottom widget to top random target widget',
      (tester) async {
    /// Finders
    final randomMnemonicFinder = find.text("laundry");
    final randomMnemonicTarget = find.byKey(const ValueKey('target_key_5'));

    await tester.testAppForWidgetTesting(const PracticeTest());
    await tester.pump(const Duration(seconds: 1));
    expect(
        practiceTestViewModel.acceptedList
            .where((element) => element.successDrop)
            .toList(),
        isEmpty);

    final Offset firstLocation = tester.getCenter(randomMnemonicFinder);
    final Offset secondLocation = tester.getCenter(randomMnemonicTarget);
    final TestGesture gesture = await tester.startGesture(firstLocation);
    await gesture.moveTo(secondLocation);

    await gesture.up();
    await tester.pump();
    expect(
        practiceTestViewModel.acceptedList
            .where((element) => element.successDrop)
            .length,
        1);
  });

  testWidgets(
      'should drag widget from bottom widget to top already occupied target widget',
      (tester) async {
    await tester.testAppForWidgetTesting(const PracticeTest());
    await tester.pump(const Duration(seconds: 1));

    final randomMnemonicFinder = find.text("laundry");
    final randomMnemonicTarget = find.byKey(const ValueKey('target_key_5'));

    final Offset firstBottomLocation = tester.getCenter(randomMnemonicFinder);
    final Offset FirstTopLocation = tester.getCenter(randomMnemonicTarget);
    final TestGesture gesture = await tester.startGesture(firstBottomLocation);
    await gesture.moveTo(FirstTopLocation);

    await gesture.up();
    await tester.pump();

    final bottomMnemonicFinder = find.text("ring");
    expect(bottomMnemonicFinder, findsOneWidget);

    final Offset bottomMnemonicLocation =
        tester.getCenter(bottomMnemonicFinder);
    final TestGesture testGesture =
        await tester.startGesture(bottomMnemonicLocation);
    await testGesture.moveTo(FirstTopLocation);

    await testGesture.up();
    await tester.pump();

    expect(
        practiceTestViewModel.acceptedList
            .where((element) => element.title == 'ring')
            .length,
        0);
  });

  testWidgets('should drag from top occupied widget to top empty target widget',
      (tester) async {
    await tester.testAppForWidgetTesting(const PracticeTest());
    await tester.pump(const Duration(seconds: 1));

    final randomMnemonicFinder = find.text("laundry");
    final randomMnemonicTarget = find.byKey(const ValueKey('target_key_5'));
    final Offset firstBottomLocation = tester.getCenter(randomMnemonicFinder);
    final Offset FirstTopLocation = tester.getCenter(randomMnemonicTarget);
    final TestGesture gesture = await tester.startGesture(firstBottomLocation);
    await gesture.moveTo(FirstTopLocation);

    await gesture.up();
    await tester.pump();

    final topMnemonicTarget = find.byKey(const ValueKey('target_key_4'));
    expect(topMnemonicTarget, findsOneWidget);

    final Offset topMnemonicLocation = tester.getCenter(topMnemonicTarget);
    final TestGesture testGesture = await tester.startGesture(FirstTopLocation);
    await testGesture.moveTo(topMnemonicLocation);

    await testGesture.up();
    await tester.pump();
    expect(
        practiceTestViewModel.acceptedList
            .where((element) => element.successDrop)
            .length,
        1);
  });

  testWidgets('should drag widget from top widget to empty bottom widget',
      (tester) async {
    await tester.testAppForWidgetTesting(const PracticeTest());
    await tester.pump(const Duration(seconds: 1));

    final int bottomTargetIndex = practiceTestViewModel.givenListNotifier.value
        .indexWhere((element) => element.title == "laundry");
    final randomMnemonicFinder = find.text("laundry");
    final randomMnemonicTarget = find.byKey(const ValueKey('target_key_5'));

    final Offset firstBottomLocation = tester.getCenter(randomMnemonicFinder);
    final Offset FirstTopLocation = tester.getCenter(randomMnemonicTarget);
    final TestGesture gesture = await tester.startGesture(firstBottomLocation);
    await gesture.moveTo(FirstTopLocation);

    await gesture.up();
    await tester.pump();

    final bottomMnemonicTarget =
        find.byKey(ValueKey('given_key_$bottomTargetIndex'));
    expect(bottomMnemonicTarget, findsOneWidget);

    final Offset bottomMnemonicLocation =
        tester.getCenter(bottomMnemonicTarget);
    final TestGesture testGesture = await tester.startGesture(FirstTopLocation);
    await testGesture.moveTo(bottomMnemonicLocation);

    await testGesture.up();
    await tester.pump();

    expect(
        practiceTestViewModel.acceptedList
            .where((element) => element.title == 'laundry')
            .length,
        0);
    expect(
        practiceTestViewModel.givenListNotifier.value
            .where((element) => element.title == 'laundry')
            .length,
        1);
  });

  testWidgets(
      'should drag widget from bottom draggable widget to bottom occupied target widget',
      (tester) async {
    await tester.testAppForWidgetTesting(const PracticeTest());
    await tester.pump(const Duration(seconds: 1));

    final randomMnemonicFinder = find.text("laundry");
    final bottomMnemonicTarget = find.text("ring");

    expect(randomMnemonicFinder, findsOneWidget);

    expect(bottomMnemonicTarget, findsOneWidget);

    final Offset firstBottomLocation = tester.getCenter(randomMnemonicFinder);
    final Offset secondBottomLocation = tester.getCenter(bottomMnemonicTarget);
    final TestGesture gesture = await tester.startGesture(firstBottomLocation);
    await gesture.moveTo(secondBottomLocation);

    await gesture.up();
    await tester.pump();
    expect(
        practiceTestViewModel.givenListNotifier.value
            .where((element) => element.title == 'laundry')
            .length,
        1);

    expect(
        practiceTestViewModel.givenListNotifier.value
            .where((element) => element.title == 'ring')
            .length,
        1);
  });
  testWidgets(
      'should drag widget from top widget to occupied bottom target widget',
      (tester) async {
    await tester.testAppForWidgetTesting(const PracticeTest());
    await tester.pump(const Duration(seconds: 1));

    final randomMnemonicFinder = find.text("laundry");
    final randomMnemonicTarget = find.byKey(const ValueKey('target_key_5'));

    final Offset firstBottomLocation = tester.getCenter(randomMnemonicFinder);
    final Offset firstTopLocation = tester.getCenter(randomMnemonicTarget);
    final TestGesture gesture = await tester.startGesture(firstBottomLocation);
    await gesture.moveTo(firstTopLocation);

    await gesture.up();
    await tester.pump();
    expect(
        practiceTestViewModel.givenListNotifier.value
            .where((element) => element.title == 'laundry')
            .length,
        0);

    final ringMnemonicFinder = find.text("ring");
    expect(ringMnemonicFinder, findsOneWidget);

    final Offset bottomMnemonicLocation = tester.getCenter(ringMnemonicFinder);
    final TestGesture testGesture = await tester.startGesture(firstTopLocation);
    await testGesture.moveTo(bottomMnemonicLocation);

    await testGesture.up();
    await tester.pump();

    expect(
        practiceTestViewModel.acceptedList
            .where((element) => element.successDrop)
            .length,
        1);
    expect(
        practiceTestViewModel.givenListNotifier.value
            .where((element) => element.title == 'laundry')
            .length,
        0);
  });

  testWidgets('should drag widget from bottom widget to empty bottom widget',
      (tester) async {
    await tester.testAppForWidgetTesting(const PracticeTest());
    await tester.pump(const Duration(seconds: 1));

    final int bottomTargetIndex = practiceTestViewModel.givenListNotifier.value
        .indexWhere((element) => element.title == "laundry");
    final randomMnemonicFinder = find.text("laundry");
    final randomMnemonicTarget = find.byKey(const ValueKey('target_key_5'));

    final Offset firstBottomLocation = tester.getCenter(randomMnemonicFinder);
    final Offset FirstTopLocation = tester.getCenter(randomMnemonicTarget);
    final TestGesture gesture = await tester.startGesture(firstBottomLocation);
    await gesture.moveTo(FirstTopLocation);

    await gesture.up();
    await tester.pump();

    final bottomMnemonicTarget =
        find.byKey(ValueKey('given_key_$bottomTargetIndex'));
    final ringMnemonicFinder = find.text("ring");

    expect(ringMnemonicFinder, findsOneWidget);
    expect(bottomMnemonicTarget, findsOneWidget);
    final Offset bottomMnemonicTargetLocation =
        tester.getCenter(bottomMnemonicTarget);
    final Offset bottomMnemonicFinderLocation =
        tester.getCenter(ringMnemonicFinder);

    final TestGesture testGesture =
        await tester.startGesture(bottomMnemonicFinderLocation);
    await testGesture.moveTo(bottomMnemonicTargetLocation);

    await testGesture.up();
    await tester.pump();
    expect(
        practiceTestViewModel.givenListNotifier.value
                .elementAt(bottomTargetIndex)
                .title ==
            '',
        true);
  });
}
