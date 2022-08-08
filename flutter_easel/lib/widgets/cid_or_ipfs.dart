import 'package:easel_flutter/utils/constants.dart';
import 'package:flutter/material.dart';

class CidOrIpfs extends StatelessWidget {
  final WidgetBuilder viewCid;
  final WidgetBuilder viewIpfs;
  final String type;

  const CidOrIpfs(
      {Key? key,
      required this.viewCid,
      required this.viewIpfs,
      required this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case k3dText:
      case kPdfText:
        return viewCid(context);
      default:
        return viewIpfs(context);
    }
  }
}
