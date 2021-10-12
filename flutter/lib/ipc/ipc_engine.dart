import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pylons_wallet/pylons_app.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';

/// Terminology
/// Signal : Incoming request from a 3rd party app
/// Key : The key is the process against which the 3rd part app has sent the signal

class IPCEngine {
  late StreamSubscription _sub;

  bool systemHandlingASignal = false;

  /// This method initiate the IPC Engine
  Future<bool> init() async {
    await handleInitialLink();
    setUpListener();
    return true;
  }

  /// This method setups the listener which receives
  void setUpListener() {
    print('Init done');
    _sub = linkStream.listen((String? link) {
      if (link == null) {
        return;
      }

      handleLink(link);

      // Link contains the data that the wallet need
    }, onError: (err) {});
  }

  /// This method is used to handle the uni link when the app first opens
  Future<void> handleInitialLink() async {
    final initialLink = await getInitialLink();

    if (initialLink != null) {
      handleLink(initialLink);
    }
  }

  /// This method encodes the message that we need to send to wallet
  /// [Input] : [msg] is the string received from the wallet
  /// [Output] : [List] contains the decoded response
  String encodeMessage(List<String> msg) {
    final encodedMessageWithComma = msg.map((e) => base64Url.encode(utf8.encode(e))).join(',');
    return base64Url.encode(utf8.encode(encodedMessageWithComma));
  }

  /// This method decode the message that the wallet sends back
  /// [Input] : [msg] is the string received from the wallet
  /// [Output] : [List] contains the decoded response
  List<String> decodeMessage(String msg) {
    final decoded = utf8.decode(base64Url.decode(msg));
    return decoded.split(',').map((e) => utf8.decode(base64Url.decode(e))).toList();
  }

  /// This method handles the link that the wallet received from the 3rd Party apps
  /// [Input] : [link] contains the link that is received from the 3rd party apps.
  /// [Output] : [List] contains the decoded message
  Future<List> handleLink(String link) async {
    final getMessage = decodeMessage(link.split('/').last);

    if (systemHandlingASignal) {
      disconnectThisSignal(sender: getMessage.first, key: getMessage[1]);
      return [];
    }

    print(getMessage);

    systemHandlingASignal = true;

    await showApprovalDialog(key: getMessage[1], sender: getMessage.first);
    systemHandlingASignal = false;
    return getMessage;
  }

  /// This method sends the unilink to the wallet app
  /// [Input] : [unilink] is the unilink with data for the wallet app
  Future<bool> dispatchUniLink(String uniLink) async {
    if (await canLaunch(uniLink)) {
      await launch(uniLink);
      return true;
    } else {
      return false;
    }
  }

  /// This is a temporary dialog for the proof of concept.
  /// [Input] : [sender] The sender of the signal
  /// [Output] : [key] The signal kind against which the signal is sent
  Future showApprovalDialog({required String sender, required String key}) {
    return showDialog(
        context: navigatorKey.currentState!.overlay!.context,
        builder: (_) => AlertDialog(
              content: const Text('Allow this transaction'),
              actions: [
                RaisedButton(
                  onPressed: () async {
                    Navigator.of(_).pop();

                    final encodedMessage = encodeMessage([key, 'OK']);

                    await dispatchUniLink('pylons://$sender/$encodedMessage');
                  },
                  child: const Text('Approval'),
                )
              ],
            ));
  }

  /// This method disposes the
  void dispose() {
    _sub.cancel();
  }

  /// This method disconnect any new signal. If another signal is already in process
  /// [Input] : [sender] The sender of the signal
  /// [Output] : [key] The signal kind against which the signal is sent
  Future<void> disconnectThisSignal({required String sender, required String key}) async {
    final encodedMessage = encodeMessage([key, 'Wallet Busy: A transaction is already is already in progress']);
    await dispatchUniLink('pylons://$sender/$encodedMessage');
  }
}
