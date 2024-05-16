import 'package:flutter/material.dart';

import '../../model/event.dart';

class EventPassViewScreen extends StatefulWidget {
  const EventPassViewScreen({super.key, required this.events});

  final Events events;

  @override
  State<EventPassViewScreen> createState() => _EventPassViewScreenState();
}

class _EventPassViewScreenState extends State<EventPassViewScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [],
      ),
    );
  }
}
