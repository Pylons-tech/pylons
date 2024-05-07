import 'package:evently/viewmodels/create_event_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OverViewScreen extends StatefulWidget {
  const OverViewScreen({Key? key}) : super(key: key);

  @override
  State<OverViewScreen> createState() => _OverViewScreenState();
}

class _OverViewScreenState extends State<OverViewScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final homeViewModel = context.watch<CreateEventViewModel>();

    return Scaffold(
      body: Column(
        children: [],
      ),
    );
  }
}
