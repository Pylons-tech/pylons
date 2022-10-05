import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/components/loading.dart';
import 'package:pylons_wallet/model/notification_message.dart';
import 'package:pylons_wallet/pages/home/message_screen/message_tile.dart';
import 'package:pylons_wallet/services/repository/repository.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:pylons_wallet/utils/constants.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  TextStyle kHeadingText = TextStyle(fontSize: 18.sp, fontFamily: kUniversalFontFamily, color: AppColors.kTextBlackColor, fontWeight: FontWeight.w800);

  ScrollController scrollController = ScrollController();

  List<NotificationMessage> msgList = [];

  List<String> msgIdsList = [];

  final int _limit = 10;

  int _offset = 0;

  int _maxListLength = 10;

  String walletAddress = "";

  bool isLoadMoreLoading = false;

  String no_messages = "";

  Repository get repository => GetIt.I.get();

  @override
  void initState() {
    markNotificationAsRead();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.addListener(pagination);
      getNotifications();
    });
    repository.logUserJourney(screenName: AnalyticsScreenEvents.messageScreen);
  }

  @override
  void dispose() {
    scrollController.removeListener(pagination);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.kBackgroundColor,
        body: Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).viewPadding.top + 30.h,
            left: 20.w,
            right: 20.w,
          ),
          child: Stack(children: [
            Align(
              alignment: Alignment.topCenter,
              child: Text(
                "messages".tr(),
                style: kHeadingText,
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: InkResponse(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(
                  Icons.arrow_back_ios,
                  color: AppColors.kUserInputTextColor,
                ),
              ),
            ),
            if (msgList.isNotEmpty)
              Column(children: [
                SizedBox(
                  height: 40.h,
                ),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    padding: EdgeInsets.zero,
                    itemCount: msgList.length,
                    itemBuilder: (_, i) {
                      return MessageTile(notificationMessage: msgList[i]);
                    },
                  ),
                ),
                if (isLoadMoreLoading)
                  Padding(
                    padding: EdgeInsets.only(top: 10.h, bottom: 30.h),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ])
            else
              Align(child: Text(no_messages)),
          ]),
        ));
  }

  Future getNotifications() async {
    final loader = Loading()..showLoading();

    walletAddress = GetIt.I.get<WalletsStore>().getWallets().value.last.publicAddress;

    msgList = await callGetNotificationApi();
    loader.dismiss();
    setState(() {});
    if (msgList.isNotEmpty) {
      markNotificationAsRead();
      return;
    }
    no_messages = "no_notifications_yet".tr();
  }

  Future getMoreNotifications() async {
    final List<NotificationMessage> updatedMsgList = await callGetNotificationApi();
    msgList.addAll(updatedMsgList);
    isLoadMoreLoading = false;
    setState(() {});
    if (updatedMsgList.isNotEmpty) {
      markNotificationAsRead();
    }
  }

  Future<List<NotificationMessage>> callGetNotificationApi() async {
    final response = await GetIt.I.get<Repository>().getAllNotificationsMessages(walletAddress: walletAddress, limit: _limit, offset: _offset);
    if (response.isLeft()) {
      "something_wrong".tr().show();
      return [];
    }
    final notificationMessageList = response.getOrElse(() => []);
    getMessagesIds(notificationMessageList);
    return notificationMessageList;
  }

  void getMessagesIds(List<NotificationMessage> messageList) {
    msgIdsList = [];
    for (final e in messageList) {
      msgIdsList.add(e.id);
    }
  }

  void pagination() {
    if ((scrollController.position.pixels == scrollController.position.maxScrollExtent) && isLoadMoreLoading == false && (msgList.length == _maxListLength)) {
      setState(() {
        isLoadMoreLoading = true;
        _offset += 10;
        _maxListLength += 10;
        getMoreNotifications();
      });
    }
  }

  Future markNotificationAsRead() async {
    final response = await GetIt.I.get<Repository>().markNotificationAsRead(idsList: msgIdsList);
    if (response.isLeft()) {
      "something_wrong".tr().show();
    }
  }
}
