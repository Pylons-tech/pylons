import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:pylons_wallet/components/space_widgets.dart';
import 'package:pylons_wallet/gen/assets.gen.dart';
import 'package:pylons_wallet/model/event.dart';
import 'package:pylons_wallet/pages/detailed_asset_view/owner_view_view_model.dart';
import 'package:pylons_wallet/pages/events/event_qr_code_screen.dart';
import 'package:pylons_wallet/pages/home/currency_screen/model/ibc_coins.dart';
import 'package:pylons_wallet/utils/constants.dart';

class EventOwnerView extends StatefulWidget {
  const EventOwnerView({super.key, required this.events});

  final Events events;

  @override
  State<EventOwnerView> createState() => _EventOwnerViewState();
}

class _EventOwnerViewState extends State<EventOwnerView> {
  OwnerViewViewModel ownerViewViewModel = GetIt.I.get();

  @override
  void initState() {
    super.initState();
    ownerViewViewModel.events = widget.events;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: ownerViewViewModel,
      builder: (_, __) => const EventPassViewContent(),
    );
  }
}

class EventPassViewContent extends StatelessWidget {
  const EventPassViewContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<OwnerViewViewModel>();

    final coinWithDenom = viewModel.events.denom.getAbbrev() == kPYLN_ABBREVATION
        ? "\$${viewModel.events.denom.pylnToCredit(viewModel.events.denom.getCoinWithProperDenomination(viewModel.events.price))} ${viewModel.events.denom.getAbbrev()}"
        : "${viewModel.events.denom.getCoinWithProperDenomination(viewModel.events.price)} ${viewModel.events.denom.getAbbrev()}";

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
                    onTap: () {
                      final Size size = MediaQuery.of(context).size;
                      viewModel.shareEventsLink(size: size);
                    },
                    child: SvgPicture.asset(shareIcon),
                  ),
                ],
              ),
            ),
          ),
          body: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                decoration: BoxDecoration(color: AppColors.kBlue),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      viewModel.events.eventName,
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
                              viewModel.events.startDate,
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
                              viewModel.events.startTime,
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
                              viewModel.events.location,
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
                                  'x ${viewModel.events.listOfPerks?.length}',
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
                  fit: BoxFit.fill,
                  width: double.infinity,
                  imageUrl: viewModel.events.thumbnail,
                  errorWidget: (a, b, c) => const Center(
                      child: Icon(
                    Icons.error_outline,
                    color: AppColors.kWhite,
                  )),
                  // placeholder: (context, url) => Shimmer(color: AppColors.kLightGray, child: const SizedBox.expand()),
                ),
              ),
              SizedBox(height: 10.h),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => EventQrCodeScreen(
                      events: viewModel.events,
                    ),
                  );
                },
                child: SvgPicture.asset(
                  Assets.images.icons.qr,
                  height: 40.h,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
