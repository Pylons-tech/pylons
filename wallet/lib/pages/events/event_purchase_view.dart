import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pylons_wallet/components/space_widgets.dart';
import 'package:pylons_wallet/model/event.dart';
import 'package:pylons_wallet/pages/home/currency_screen/model/ibc_coins.dart';
import 'package:pylons_wallet/utils/constants.dart';

class EventPurchaseView extends StatefulWidget {
  const EventPurchaseView({super.key, required this.events});

  final Events events;

  @override
  State<EventPurchaseView> createState() => _EventPurchaseViewState();
}

class _EventPurchaseViewState extends State<EventPurchaseView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return EventPassViewContent(
      events: widget.events,
    );
  }
}

class EventPassViewContent extends StatelessWidget {
  EventPassViewContent({
    super.key,
    required this.events,
  });

  final Events events;

  final MobileScannerController controller = MobileScannerController(
    formats: const [BarcodeFormat.qrCode],
  );

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
                  GestureDetector(
                    onTap: () {},
                    child: Container(),
                  ),
                ],
              ),
            ),
          ),
          body: Column(
            children: [
              Stack(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20.w),
                    height: 200.h,
                    child: MobileScanner(
                      controller: controller,
                      onDetect: (_) {
                        print(_);
                      },
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                decoration: BoxDecoration(color: AppColors.kBlue),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      events.eventName,
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 25.sp, fontWeight: FontWeight.w700, color: AppColors.kWhite),
                    ),
                    VerticalSpace(20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Date',
                              style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 11.sp, fontWeight: FontWeight.w400, color: AppColors.kWhite),
                            ),
                            Text(
                              events.startDate,
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 15.sp, fontWeight: FontWeight.w700, color: AppColors.kWhite),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Time',
                              style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 11.sp, fontWeight: FontWeight.w400, color: AppColors.kWhite),
                            ),
                            Text(
                              events.startTime,
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 15.sp, fontWeight: FontWeight.w700, color: AppColors.kWhite),
                            ),
                          ],
                        )
                      ],
                    ),
                    VerticalSpace(20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'LOCATION',
                              style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 11.sp, fontWeight: FontWeight.w400, color: AppColors.kWhite),
                            ),
                            Text(
                              events.location,
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 15.sp, fontWeight: FontWeight.w700, color: AppColors.kWhite),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'PRICE',
                              style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 11.sp, fontWeight: FontWeight.w400, color: AppColors.kWhite),
                            ),
                            Text(
                              events.price == "0" ? "Free" : '${events.price} ${events.denom.getName()}',
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 15.sp, fontWeight: FontWeight.w700, color: AppColors.kWhite),
                            ),
                          ],
                        )
                      ],
                    ),
                    VerticalSpace(20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'PERKS',
                              style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w400, color: AppColors.kWhite),
                            ),
                            SizedBox(height: 1.h),
                            Row(
                              children: [
                                SvgPicture.asset(kDiamondIcon),
                                SizedBox(width: 5.w),
                                Text(
                                  'x ${events.listOfPerks?.length}',
                                  style: TextStyle(fontSize: 15.sp, color: AppColors.kWhite, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: 5.w),
                                Text(
                                  'Redeem',
                                  style: TextStyle(fontSize: 15.sp, color: AppColors.kGreenText, fontWeight: FontWeight.bold),
                                )
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w),
                child: CachedNetworkImage(
                  width: double.infinity,
                  fit: BoxFit.fill,
                  imageUrl: events.thumbnail,
                  errorWidget: (a, b, c) => const Center(
                      child: Icon(
                    Icons.error_outline,
                    color: AppColors.kWhite,
                  )),
                  // placeholder: (context, url) => Shimmer(color: AppColors.kLightGray, child: const SizedBox.expand()),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ScannerOverlay extends CustomPainter {
  const ScannerOverlay({
    required this.scanWindow,
    this.borderRadius = 12.0,
  });

  final Rect scanWindow;
  final double borderRadius;

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: use `Offset.zero & size` instead of Rect.largest
    // we need to pass the size to the custom paint widget
    final backgroundPath = Path()..addRect(Rect.largest);

    final cutoutPath = Path()
      ..addRRect(
        RRect.fromRectAndCorners(
          scanWindow,
          topLeft: Radius.circular(borderRadius),
          topRight: Radius.circular(borderRadius),
          bottomLeft: Radius.circular(borderRadius),
          bottomRight: Radius.circular(borderRadius),
        ),
      );

    final backgroundPaint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOut;

    final backgroundWithCutout = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );

    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    final borderRect = RRect.fromRectAndCorners(
      scanWindow,
      topLeft: Radius.circular(borderRadius),
      topRight: Radius.circular(borderRadius),
      bottomLeft: Radius.circular(borderRadius),
      bottomRight: Radius.circular(borderRadius),
    );

    // First, draw the background,
    // with a cutout area that is a bit larger than the scan window.
    // Finally, draw the scan window itself.
    canvas.drawPath(backgroundWithCutout, backgroundPaint);
    canvas.drawRRect(borderRect, borderPaint);
  }

  @override
  bool shouldRepaint(ScannerOverlay oldDelegate) {
    return scanWindow != oldDelegate.scanWindow || borderRadius != oldDelegate.borderRadius;
  }
}
