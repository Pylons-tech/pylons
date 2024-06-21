import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:pylons_wallet/components/loading.dart';
import 'package:pylons_wallet/components/space_widgets.dart';
import 'package:pylons_wallet/model/event.dart';
import 'package:pylons_wallet/pages/home/currency_screen/model/ibc_coins.dart';
import 'package:pylons_wallet/pages/purchase_item/purchase_item_view_model.dart';
import 'package:pylons_wallet/pages/purchase_item/widgets/trade_receipt_dialog.dart';
import 'package:pylons_wallet/pages/purchase_item/widgets/transaction_complete_dialog.dart';
import 'package:pylons_wallet/pylons_app.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/dependency_injection/dependency_injection.dart';
import 'package:pylons_wallet/utils/route_util.dart';
import '../../modules/Pylonstech.pylons.pylons/module/client/pylons/execution.pb.dart';

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

  final viewModel = sl<PurchaseItemViewModel>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: viewModel,
      child: EventPassViewContent(
        events: widget.events,
      ),
    );
  }
}

class EventPassViewContent extends StatefulWidget {
  const EventPassViewContent({
    super.key,
    required this.events,
  });

  final Events events;

  @override
  State<EventPassViewContent> createState() => _EventPassViewContentState();
}

class _EventPassViewContentState extends State<EventPassViewContent> {
  late Rect scanWindow;

  MobileScannerController cameraController = MobileScannerController(
    formats: const [BarcodeFormat.qrCode],
    detectionSpeed: DetectionSpeed.noDuplicates,
  );

  bool isCapture = false;

  Future<void> executeRecipe(BuildContext context) async {
    final provider = context.read<PurchaseItemViewModel>();
    final ibcEnumCoins = provider.getEvents.denom;

    if (ibcEnumCoins == IBCCoins.ustripeusd) {
      //@TODO
      // needed to work on this flow
    } else {
      paymentByCoins();
    }
  }

  Future<void> paymentByCoins() async {
    final navigator = Navigator.of(navigatorKey.currentState!.overlay!.context);
    final provider = context.read<PurchaseItemViewModel>();
    final executionResponse = await provider.paymentForEventRecipe();

    navigator.pop();
    if (!executionResponse.success) {
      executionResponse.error.show();
      navigator.pushNamed(Routes.transactionFailure.name);
      return;
    }

    showTransactionCompleteDialog(execution: executionResponse.data!);
  }

  void showTransactionCompleteDialog({required Execution execution}) {
    final viewModel = context.read<PurchaseItemViewModel>();

    var price = double.parse(viewModel.nft.price);
    final fee = double.parse(viewModel.nft.price) * 0.1;
    price = price - fee;

    final txId = execution.hasId() ? execution.id : "";

    final txTime = getTransactionTimeStamp(execution.hasTxTime() ? execution.txTime.toInt() : null);

    final model = viewModel.createTradeReciptModel(
      fee: fee,
      price: price,
      txId: txId,
      txTime: txTime,
    );

    final TradeCompleteDialog tradeCompleteDialog = TradeCompleteDialog(
      model: model,
      context: context,
      onBackPressed: () {
        showReceiptDialog(model);
      },
    );
    tradeCompleteDialog.show();
  }

  void showReceiptDialog(TradeReceiptModel model) {
    final TradeReceiptDialog tradeReceiptDialog = TradeReceiptDialog(context: context, model: model);
    tradeReceiptDialog.show();
  }

  String getTransactionTimeStamp(int? time) {
    final formatter = DateFormat('MMM dd yyyy HH:mm');
    if (time == null) {
      return "${formatter.format(DateTime.now().toUtc())} $kUTC";
    }

    final int timeStamp = time * kDateConverterConstant;
    final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timeStamp, isUtc: true);
    return "${formatter.format(dateTime)} $kUTC";
  }

  Future<void> onDetect(BarcodeCapture barCodeCapture, PurchaseItemViewModel viewModel, BuildContext context) async {
    if (isCapture) {
      return;
    }
    if (!isCapture) {
      setState(() => isCapture = true);

      final String? displayValue = barCodeCapture.barcodes.first.displayValue;

      final map = jsonDecode(displayValue!);

      final event = Events.fromJson(map as Map<String, dynamic>);

      viewModel.setEvents = event;

      await executeRecipe(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    scanWindow = Rect.fromCenter(
      center: MediaQuery.sizeOf(context).center(Offset(0, -130.h)),
      width: 100.r,
      height: 100.r,
    );

    final viewModel = context.watch<PurchaseItemViewModel>();
    final coinWithDenom = widget.events.denom.getAbbrev() == kPYLN_ABBREVATION
        ? "\$${widget.events.denom.pylnToCredit(widget.events.denom.getCoinWithProperDenomination(widget.events.price))} ${widget.events.denom.getAbbrev()}"
        : "${widget.events.denom.getCoinWithProperDenomination(widget.events.price)} ${widget.events.denom.getAbbrev()}";

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
                      onDetect: (BarcodeCapture barCodeCapture) => onDetect(
                        barCodeCapture,
                        viewModel,
                        context,
                      ),
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
                      widget.events.eventName,
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
                              widget.events.startDate,
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
                              widget.events.startTime,
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
                              widget.events.location,
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
                              coinWithDenom,
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
                                  'x ${widget.events.listOfPerks?.length}',
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
                  height: 160.h,
                  width: double.infinity,
                  fit: BoxFit.fill,
                  imageUrl: widget.events.thumbnail,
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
