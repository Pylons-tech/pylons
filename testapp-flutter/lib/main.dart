import 'dart:developer';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pylons_sdk/pylons_sdk.dart';
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
    () async {
      PylonsWallet.instance.exists().then((exists) async {
        if (!exists) {
          PylonsWallet.instance.goToInstall();
        }
      });
    };
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
  Item? character;
  int swordLv = 0;
  int coins = 0;
  int shards = 0;
  int curHp = 0;

  @override
  void initState () {
    super.initState();
    if (kDebugMode) {
      print ("initState");
    }
    Cookbook.load("appTestCookbook").then((value) {
      _checkCharacter().then((value) async {
        if (kDebugMode) {
          print ("character exiss: ${character != null}");
        }
        if (character == null) {
          await _generateCharacter();
          if (kDebugMode) {
            print ("after generate - character exiss: ${character != null}");
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("HP: $curHp/20 | Sword level $swordLv | $coins coins | $shards shards", style: const TextStyle(fontSize: 18),),
              const Divider(),
              showTopLevelMenu ? topLevelMenu() : Container(),
        ])
      ),
    );
  }

  Widget topLevelMenu() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [

        ElevatedButton(
          onPressed: () async {
            Cookbook.recipes();
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

  Future<void> _checkCharacter() async {
    flavorText = ("Checking character...");

    if (kDebugMode) {
      print("getting profile");
    }
    final prf = await Profile.get();
    if (kDebugMode) {
      print ("got profile");
    }
    if (prf == null) throw Exception("HANDLE THIS");
    if (kDebugMode) {
      print ("(ok!)");
    }
    var lastUpdate = Int64.MIN_VALUE;
    for (var item in prf.items) {
      if (item.getString("entityType") == "character" &&
          !(item.getInt("currentHp")?.isZero ?? true)) {
        if (item.getLastUpdate() > lastUpdate) {
          character = item;
          lastUpdate = item.getLastUpdate();
        }
      }
    }

    if (kDebugMode) {
      print ("got character!");
    }

    swordLv = character?.getInt("swordLevel")?.toInt() ?? 0;
    coins = character?.getInt("coins")?.toInt() ?? 0;
    shards = character?.getInt("shards")?.toInt() ?? 0;
    curHp = character?.getInt("currentHp")?.toInt() ?? 0;
  }

  Future<void> _generateCharacter() async {
    flavorText = "Generating character...";
    final recipe = await Recipe.get("RecipeTestAppGetCharacter");
    if (recipe == null) throw Exception("todo: handle this");
    final exec = await recipe.executeWith([]).onError((error, stackTrace) {
      throw Exception("character generation tx should not fail");
    });
    final itemId = exec.getItemOutputIds().first;
    character = await Item.get(itemId);
  }
}
