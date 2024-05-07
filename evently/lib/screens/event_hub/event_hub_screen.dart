import 'package:evently/utils/evently_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EventHubScreen extends StatefulWidget {
  const EventHubScreen({super.key});

  @override
  State<EventHubScreen> createState() => _EventHubScreenState();
}

class _EventHubScreenState extends State<EventHubScreen> {
  @override
  Widget build(BuildContext context) {
    return  ColoredBox(
      color: EventlyAppTheme.kWhite,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: EventlyAppTheme.kBgWhite,
          body: Padding(
            padding: EdgeInsets.only(top: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

              ],
            ),
          ),
        ),
      ),
    );
  }


}
