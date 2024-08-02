import 'dart:convert';

import 'package:evently/evently_provider.dart';
import 'package:evently/models/denom.dart';
import 'package:evently/models/events.dart';
import 'package:evently/screens/detail_screen.dart';
import 'package:evently/screens/host_view_ticket_preview.dart';
import 'package:evently/screens/overview_screen.dart';
import 'package:evently/screens/perks_screen.dart';
import 'package:evently/screens/price_screen.dart';
import 'package:evently/utils/di/di.dart';
import 'package:evently/utils/enums.dart';
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
  late EventlyProvider eventlyProvider;
  CreateEventViewModel createEventViewModel = sl<CreateEventViewModel>();

  @override
  void initState() {
    eventlyProvider = Provider.of<EventlyProvider>(context, listen: false);
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<EventlyProvider>().initStore();
    });

    createEventViewModel.init(setTextField: () {
      eventlyProvider.setEventName = createEventViewModel.events!.eventName;
      eventlyProvider.setHostName = createEventViewModel.events!.hostName;
      eventlyProvider.setThumbnail = createEventViewModel.events!.thumbnail;
      eventlyProvider.setStartDate = createEventViewModel.events!.startDate;
      eventlyProvider.setEndDate = createEventViewModel.events!.endDate;
      eventlyProvider.setStartTime = createEventViewModel.events!.startTime;
      eventlyProvider.setEndTime = createEventViewModel.events!.endTime;
      eventlyProvider.setLocation = createEventViewModel.events!.location;
      eventlyProvider.setDescription = createEventViewModel.events!.description;
      eventlyProvider.setId = createEventViewModel.events!.id!;

      final listOfPerkJson = jsonDecode(createEventViewModel.events!.listOfPerks);

      for (var perksJson in listOfPerkJson) {
        eventlyProvider.setPerks = PerksModel.fromJson(perksJson);
      }

      eventlyProvider.setFreeDrop = createEventViewModel.events!.isFreeDrops.toFreeDrop();
      eventlyProvider.setPrice = int.parse(createEventViewModel.events!.price);
      eventlyProvider.setNumberOfTickets = int.parse(createEventViewModel.events!.numberOfTickets);
      eventlyProvider.setSelectedDenom(Denom.fromJson(jsonDecode(createEventViewModel.events!.denom)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: EventlyAppTheme.kWhite,
      child: SafeArea(
        bottom: false,
        child: PopScope(
          canPop: false,
          child: Scaffold(
            body: ChangeNotifierProvider.value(value: createEventViewModel, child: const CreateEventContent()),
          ),
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
        final map = {0: 0, 1: 1, 2: 2, 3: 3, 4: 4};
        createEventViewModel.currentStep.value = map[page]!;
      },
      itemBuilder: (BuildContext context, int index) {
        final map = {
          0: overview,
          1: details,
          2: perks,
          3: price,
          4: ticketPreview,
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

  Widget ticketPreview() {
    return const HostTicketPreview();
  }
}
