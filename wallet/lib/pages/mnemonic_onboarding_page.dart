import 'package:cosmos_ui_components/cosmos_ui_components.dart';
import 'package:cosmos_utils/cosmos_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pylons_wallet/components/pylons_app_theme.dart';
import 'package:pylons_wallet/components/pylons_blue_button.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:simple_rich_text/simple_rich_text.dart';

class MnemonicOnboardingPage extends StatefulWidget {
  const MnemonicOnboardingPage({Key? key}) : super(key: key);

  @override
  _MnemonicOnboardingPageState createState() => _MnemonicOnboardingPageState();
}

class _MnemonicOnboardingPageState extends State<MnemonicOnboardingPage> {
  String mnemonic = "";

  List<String> get mnemonicWords => mnemonic.trim().split(' ');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CosmosAppBar(
        title: "wallet_creation".tr(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: ContentStateSwitcher(
            isEmpty: mnemonic.isEmpty,
            emptyChild: Center(
              child: PylonsBlueButton(
                onTap: _generateMnemonicClicked,
                text: "create_new_wallet".tr(),
              ),
            ),
            contentChild: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CosmosMnemonicWordsGrid(mnemonicWords: mnemonicWords),
                  const SizedBox(height: 8),
                  SimpleRichText(
                    'security_hint'.tr(),
                    style: PylonsAppTheme.HOME_LABEL,
                  ),
                  PylonsBlueButton(onTap: _proceedClicked, text: "proceed".tr())
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _generateMnemonicClicked() => setState(() async => mnemonic = await generateMnemonic(strength: kMnemonicStrength));

  void _proceedClicked() => notImplemented(context);
}
