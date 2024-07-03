import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/components/loading.dart';
import 'package:pylons_wallet/gen/assets.gen.dart';
import 'package:pylons_wallet/services/third_party_services/stripe_handler.dart';
import 'package:pylons_wallet/utils/base_env.dart';
import 'package:pylons_wallet/utils/constants.dart';

import '../generated/locale_keys.g.dart';

class StripeScreen extends StatefulWidget {
  final String url;
  final VoidCallback onBack;

  const StripeScreen({
    super.key,
    required this.url,
    required this.onBack,
  });

  @override
  State<StripeScreen> createState() => _StripeScreenState();
}

class _StripeScreenState extends State<StripeScreen> {
  late InAppWebViewController _controller;
  final baseEnv = GetIt.I.get<BaseEnv>();

  @override
  void initState() {
    super.initState();
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
    final account_response =
        await GetIt.I.get<StripeHandler>().handleStripeAccountLink();
    loading.dismiss();
    account_response.fold((fail) => {fail.message.show()}, (accountlink) {
      _controller.loadUrl(
          urlRequest: URLRequest(url: WebUri.uri(Uri.parse(accountlink))));
    });

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (_) => backHistory(context),
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
              child: InAppWebView(
                initialUrlRequest:
                    URLRequest(url: WebUri.uri(Uri.parse(widget.url))),
                onWebViewCreated: (InAppWebViewController webViewController) {
                  _controller = webViewController;
                },
                shouldOverrideUrlLoading: (controller, navigationAction) async {
                  final uri = navigationAction.request.url;
                  if (uri == null) {
                    return NavigationActionPolicy.ALLOW;
                  }

                  final String urlInString = uri.toString();
                  if (urlInString.contains(baseEnv.baseStripeCallbackUrl)) {
                    getAccountLinkAndRedirect();
                    return NavigationActionPolicy.CANCEL;
                  }
                  if (urlInString
                      .contains(baseEnv.baseStripeCallbackRefreshUrl)) {
                    getAccountLinkAndRedirect();
                    return NavigationActionPolicy.CANCEL;
                  }

                  if (urlInString.startsWith("blob:")) {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(SnackBar(
                        content: Text(LocaleKeys.blob_type_not_supported.tr()),
                      ));
                    return NavigationActionPolicy.CANCEL;
                  }
                  return NavigationActionPolicy.ALLOW;
                },
                androidOnPermissionRequest: (InAppWebViewController controller,
                    String origin, List<String> resources) async {
                  return PermissionRequestResponse(
                      resources: resources,
                      action: PermissionRequestResponseAction.GRANT);
                },
                initialOptions: InAppWebViewGroupOptions(
                    crossPlatform: InAppWebViewOptions(
                  useShouldOverrideUrlLoading: true,
                )),
              ),
            ),
            Positioned(
              left: 20.w,
              top: 0,
              height: 40.h,
              child: InkWell(
                  onTap: () async {
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
                    Assets.images.icons.stripeHeader,
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

    final account_response =
        await GetIt.I.get<StripeHandler>().handleStripeAccountLink();
    loading.dismiss();
    account_response.fold((fail) => {fail.message.show()}, (accountlink) {
      _controller.loadUrl(
          urlRequest: URLRequest(url: WebUri.uri(Uri.parse(accountlink))));
    });
  }
}
