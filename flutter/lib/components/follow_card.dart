import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pylons_wallet/components/pylons_blue_button.dart';

class FollowCardWidget extends StatelessWidget {
  const FollowCardWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const tileWidth = 85.0;
    const buttonWidth = tileWidth * 0.9;
    return Card(
        child: SizedBox(
            width: tileWidth,
            child: Column(children: [
              Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    child: const Icon(Icons.close, size: 10),
                    onTap: () {},
                  )),
              const Align(
                  alignment: Alignment.topCenter,
                  child: CircleAvatar(
                    child: FlutterLogo(size: 20.0),
                  )),
              const Text('JIN'),
              SizedBox(
                height: 25,
                width: buttonWidth,
                child: PylonsBlueButton(
                  text: 'follow'.tr(),
                  onTap: () {},
                ),
              )
            ])));
  }
}
