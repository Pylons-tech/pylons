import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pylons_wallet/utils/constants.dart';

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
    return ColoredBox(
      color: AppColors.kBlack87,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.kBlack87,
          appBar: AppBar(
            backgroundColor: Colors.black,
            flexibleSpace: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    Icons.arrow_back_ios,
                    color: AppColors.kWhite,
                  ),
                  Text(
                    'Event Pass',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.kWhite,
                    ),
                  ),
                  SvgPicture.asset(shareIcon),
                ],
              ),
            ),
          ),
          body: Column(
            children: [
              Container(
                decoration: BoxDecoration(color: AppColors.kBlue),
                child: Column(
                  children: [
                    Text(widget.events.eventName),
                    Row(
                      children: [
                        Column(
                          children: [
                            Text('Date'),
                            Text(widget.events.startDate),
                          ],
                        ),
                        Column(
                          children: [
                            Text('Time'),
                            Text(widget.events.startDate),
                          ],
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Column(
                          children: [
                            Text('LOCATION'),
                            Text(widget.events.location),
                          ],
                        ),
                        Column(
                          children: [
                            Text('SEAT'),
                            Text("no seat"),
                          ],
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Column(
                          children: [
                            Text('Date'),
                            Text(widget.events.startDate),
                          ],
                        ),
                        Column(
                          children: [
                            Text('Time'),
                            Text(widget.events.startDate),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
