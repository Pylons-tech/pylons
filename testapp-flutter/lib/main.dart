import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:pylons_sdk/low_level.dart';
import 'package:fixnum/fixnum.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  PylonsWallet.setup(mode: PylonsMode.prod, host: 'testapp_flutter');

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    PylonsWallet.instance.exists().then((exists) {
      if (!exists) {
        PylonsWallet.instance.goToInstall();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pylons Testapp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Welcome to Pylons Testapp'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  bool showTopLevelMenu = true;
  String flavorText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: showTopLevelMenu ? topLevelMenu() : Container(),
      ),
    );
  }

  Widget topLevelMenu() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text("HP: 20/20 | Sword level 0 | 99 gold | 99 shards", style: TextStyle(fontSize: 18),),
        const Divider(),
        ElevatedButton(
          onPressed: () async {

          },
          child: const Text('Fight a goblin!'),
        ),
        ElevatedButton(
          onPressed: () async {

          },
          child: const Text('Fight a troll!'),
        ),
        ElevatedButton(
          onPressed: () async {

          },
          child: const Text('Fight a dragon!'),
        ),
        ElevatedButton(
          onPressed: () async {

          },
          child: const Text('Buy a sword!'),
        ),
        ElevatedButton(
          onPressed: () async {

          },
          child: const Text('Upgrade your sword!'),
        ),
        ElevatedButton(
          onPressed: () async {

          },
          child: const Text('Rest and recover!'),
        ),
      ],
    );
  }

}
