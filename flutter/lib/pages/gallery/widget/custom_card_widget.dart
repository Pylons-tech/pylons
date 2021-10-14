import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pylons_wallet/components/space_widgets.dart';
import 'package:pylons_wallet/pages/account/account.dart';

class CustomCardWidget extends StatelessWidget {
  final Widget buttonWidget;

  const CustomCardWidget({required this.buttonWidget});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: Container(
        padding: const EdgeInsets.all(16),
        width: MediaQuery.of(context).size.width * .90,
        child: Column(
          children: <Widget>[
            ListTile(
              contentPadding: EdgeInsets.zero,
              minLeadingWidth: 10,
              leading: const CircleAvatar(
                radius: 30,
                child: FlutterLogo(size: 28.0),
              ),
              title: const Text('Linda',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF201D1D),
                  )),
              subtitle: const Text('Media Artist (3D, Motiongraphics, Collecting NFT)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Color(0xFF616161))),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AccountScreenWidget()));
              },
            ),
            Row(
              children: [const SizedBox(width: 70), Text('${'followers'.tr()}: 23'), const SizedBox(width: 60), Text('${'followings'.tr().toLowerCase()}: 20')],
            ),
            const VerticalSpace(10),
            buttonWidget,
          ],
        ),
      ),
    );
  }
}
