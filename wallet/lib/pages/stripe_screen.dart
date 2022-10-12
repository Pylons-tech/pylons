import 'dart:async';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/components/loading.dart';
import 'package:pylons_wallet/services/third_party_services/stripe_handler.dart';
import 'package:pylons_wallet/utils/base_env.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/svg_util.dart';
import 'package:webview_flutter/webview_flutter.dart';

class StripeScreen extends StatefulWidget {
  final String url;
  final VoidCallback onBack;

  const StripeScreen({Key? key, required this.url, required this.onBack}) : super(key: key);

  @override
  State<StripeScreen> createState() => _StripeScreenState();
}

class _StripeScreenState extends State<StripeScreen> {
  late WebViewController _controller;
  final baseEnv = GetIt.I.get<BaseEnv>();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  Future backHistory(BuildContext context) async {
    final bool goBack = await _controller.canGoBack();
    if (goBack) {
      _controller.goBack();
      return;
    }

    widget.onBack();
  }

  Future<bool> loadLoginLink() async {
    final loading = Loading()..showLoading();
    final account_response = await GetIt.I.get<StripeHandler>().handleStripeAccountLink();
    loading.dismiss();
    account_response.fold((fail) => {fail.message.show()}, (accountlink) => {_controller.loadUrl(accountlink)});

    return true;
  }

  JavascriptChannel _extractDataJSChannel(BuildContext context) {
    return JavascriptChannel(
      name: 'Flutter',
      onMessageReceived: (JavascriptMessage message) {},
    );
  }

  void hideSignout() {
    _controller.runJavascript(kStripeSignoutJS);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        backHistory(context);
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.white,
          body: Stack(children: [
            Positioned(
              left: 0,
              right: 0,
              top: 40.h,
              bottom: 0,
              child: WebView(
                initialUrl: widget.url,
                javascriptMode: JavascriptMode.unrestricted,
                debuggingEnabled: true,
                //userAgent: 'Mozilla/5.0 (Linux; Android 5.1.1; Nexus 5 Build/LMY48B; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/43.0.2357.65 Mobile Safari/537.36',
                onWebViewCreated: (WebViewController webViewController) {
                  _controller = webViewController;
                },
                javascriptChannels: {
                  _extractDataJSChannel(context),
                  JavascriptChannel(name: 'Print', onMessageReceived: (JavascriptMessage message) {}),
                },
                navigationDelegate: (NavigationRequest request) {
                  if (request.url.contains(baseEnv.baseStripeCallbackUrl)) {
                    getAccountLinkAndRedirect();
                    return NavigationDecision.prevent;
                  }
                  if (request.url.contains(baseEnv.baseStripeCallbackRefreshUrl)) {
                    getAccountLinkAndRedirect();
                    return NavigationDecision.prevent;
                  }

                  if (request.url.startsWith("blob:")) {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(SnackBar(
                        content: Text("blob_type_not_supported".tr()),
                      ));
                    return NavigationDecision.prevent;
                  }
                  return NavigationDecision.navigate;
                },

                onPageStarted: (String url) {},
                onPageFinished: (String url) {},
                gestureNavigationEnabled: true,
              ),
            ),
            Positioned(
              left: 20.w,
              top: 0,
              height: 40.h,
              child: InkWell(
                  onTap: () async {
                    Navigator.of(context).pop();
                    await backHistory(context);
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: AppColors.kDarkGrey,
                  )),
            ),
            Positioned(
                left: 0,
                right: 0,
                top: 0,
                height: 40.h,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: SvgPicture.asset(
                    SVGUtil.PYLON_STRIPE_VIEW_HEADER,
                    height: 40.h,
                    width: 80.w,
                  ),
                ))
          ]),
        ),
      ),
    );
  }

  Future getAccountLinkAndRedirect() async {
    final loading = Loading()..showLoading();

    final account_response = await GetIt.I.get<StripeHandler>().handleStripeAccountLink();
    loading.dismiss();
    account_response.fold((fail) => {fail.message.show()}, (accountlink) {
      _controller.loadUrl(accountlink);
    });
  }
}
