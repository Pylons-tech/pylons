import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:pylons_flame_demo/main.dart';

class Hud extends StatelessWidget {
  const Hud({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: nameNotifier,
        child: Text(Provider.of<NameNotifier>(context).profileName, style: const TextStyle(fontSize: 42))
    );
  }
}