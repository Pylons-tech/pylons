import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:pylons_wallet/components/pylons_app_theme.dart';
import 'package:pylons_wallet/components/pylons_blue_button.dart';
import 'package:pylons_wallet/components/space_widgets.dart';

class PylonsDashboardFilterBox extends StatefulWidget {

  @override
  _PylonsDashboardFilterBoxState createState() => _PylonsDashboardFilterBoxState();
}

class _PylonsDashboardFilterBoxState extends State<PylonsDashboardFilterBox> {
  var filter_strings = [
    {"name":"Purchase", 'checked': true},
    {"name":"Mint", "checked": false},
    {"name":"Follow", "checked": false},
    {"name":"Trade", "checked": false},
    {"name":"Music", "checked": false},];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      child: contentBox(context),
    );
  }
  Widget contentBox(BuildContext context){
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: [
              const ImageIcon(
                  AssetImage('assets/icons/filter.png'),
                  size: 20,
                  color: Color(0xFF616161)
              ),
              Text('filter'.tr(), style: const TextStyle(fontWeight: FontWeight.w500),),
              const Spacer(),
              FlatButton(
                onPressed: (){},
                child: Text('reset'.tr(), style: PylonsAppTheme.HOME_LABEL,)
              )
            ],
          ),
          for (var i = 0; i < filter_strings.length; i += 1)
            Row(
                children: [
                  Checkbox(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    onChanged: (value) {
                      setState((){
                        filter_strings[i]['checked']=value!;
                      });
                    },
                    tristate: i == 1,
                    value: filter_strings[i]['checked'] == true,
                    activeColor: Color(0xFF6200EE),
                  ),
                  Text(
                    filter_strings[i]['name'].toString(),
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.start,
              ),
          const VerticalSpace(10),
          Row(
            children:[
              Expanded(
                child: SizedBox(
                height: 35,
                child: _PylonsGreyButton(onTap: (){}, text: "cancel".tr(),),
              ),),
             const HorizontalSpace(20),
             Expanded(
               flex: 2,
               child: SizedBox(
                 height: 35,
                   child: PylonsBlueButton(onTap: (){}, text: "apply".tr(),)),
             ),

            ]
          )
        ],
      ),
    );
  }
}

class _PylonsGreyButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;

  const _PylonsGreyButton({
    Key? key,
    required this.onTap,
    this.text = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        primary: const Color(0xFFC4C4C4),
      ),
      child: SizedBox(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                text,
                style: const TextStyle(fontSize: 15, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
