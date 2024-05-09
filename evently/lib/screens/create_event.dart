import 'package:evently/screens/detail_screen.dart';
import 'package:evently/screens/overview_screen.dart';
import 'package:evently/screens/perks_screen.dart';
import 'package:evently/screens/price_screen.dart';
import 'package:evently/utils/di/di.dart';
import 'package:evently/utils/evently_app_theme.dart';
import 'package:evently/viewmodels/create_event_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateEvent extends StatefulWidget {
  const CreateEvent({super.key});

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  CreateEventViewModel createEventViewModel = sl<CreateEventViewModel>();

  @override
  void initState() {
    createEventViewModel.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: EventlyAppTheme.kWhite,
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          body: ChangeNotifierProvider.value(value: createEventViewModel, child: const CreateEventContent()),
        ),
      ),
    );
  }

  @override
  void dispose() {
    createEventViewModel.disposeControllers();
    super.dispose();
  }
}

class CreateEventContent extends StatelessWidget {
  const CreateEventContent({super.key});

  @override
  Widget build(BuildContext context) {
    final createEventViewModel = context.watch<CreateEventViewModel>();
    return PageView.builder(
      controller: createEventViewModel.pageController,
      physics: const NeverScrollableScrollPhysics(),
      onPageChanged: (int page) {
        createEventViewModel.currentPage.value = page;
        final map = {0: 0, 1: 1, 2: 2, 3: 3};
        createEventViewModel.currentStep.value = map[page]!;
      },
      itemBuilder: (BuildContext context, int index) {
        final map = {
          0: overview,
          1: details,
          2: perks,
          3: price,
        };

        return map[index]?.call() ?? const SizedBox();
      },
    );
  }

  Widget overview() {
    return const OverViewScreen();
  }

  Widget details() {
    return const DetailsScreen();
  }

  Widget perks() {
    return const PerksScreen();
  }

  Widget price() {
    return const PriceScreen();
  }
}
