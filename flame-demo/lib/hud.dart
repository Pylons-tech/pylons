import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:pylons_flame_demo/main.dart';

class Hud extends StatelessWidget {
  const Hud({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final text = "${Provider.of<HudNotifier>(context).profileName}\n${Provider.of<HudNotifier>(context).line2}";
    return Text(text, style: const TextStyle(fontSize: 42));
  }
}