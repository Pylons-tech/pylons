import 'package:flutter/material.dart';
import 'package:pylons_sdk/pylons_sdk.dart';

const menu = "1) Fight a goblin!\n2) Fight a troll!\n3) Fight a dragon!\n4) Buy a sword!\n"
    "5) Upgrade your sword!\n6) Rest for a moment\n7) Rest for a bit\n8) Rest for a while\n"
    "9) Power nap (9 PYL)\n10) Quit";

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  PylonsWallet.setup(mode: PylonsMode.prod, host: 'flutter_wallet');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _displayMenuButtons = false;
  String _username = "";
  String _address = "";
  String _text = "lorem ipsum etc. etc.";
  bool _foundWallet = false;
  Item? _character;
  int _pylons = 0;
  int _swordLv = 0;
  int _coins = 0;
  int _shards = 0;
  int _curHp = 0;
  @override
  void initState() {
    super.initState();
    PylonsWallet.instance.exists().then((value) {
      _foundWallet = value;
    });
  }

  void _displayText(String t, bool menu) {
    setState(() {
      if (menu || _text.isEmpty) {
        _text = t;
      } else {
        _text += "\n";
        _text += t;
      }
      _displayMenuButtons = menu;
    });
  }

  Future<void> _checkCharacter() async {
    _displayText("Checking character...", false);

    var sdkResponse = await PylonsWallet.instance.getProfile();
    _pylons = sdkResponse.data.coins.firstWhere((element) => element.denom == "upylon").amount.value.toBigInt().toInt();
    _username = sdkResponse.data.username;
    _address = sdkResponse.data.address;

    if (_character == null) {
      Item? chr;
      int lu = -1;
      for (var item in sdkResponse.data.items) {
        if (item.strings.any((element) => element.key == "entityType" && element.value == "character") &&
            item.longs.any((element) => element.key == "currentHp" && element.value != 0)) {
          var v = item.lastUpdate.toInt();
          if (v > lu) {
            lu = v;
            chr = item;
          }
        }
      }
      _character = chr;
    }

    _swordLv = _character?.longs.firstWhere((element) => element.key == "swordLevel").value.toInt() ?? 0;
    _coins = _character?.longs.firstWhere((element) => element.key == "coins").value.toInt() ?? 0;
    _shards = _character?.longs.firstWhere((element) => element.key == "shards").value.toInt() ?? 0;
    _curHp = _character?.longs.firstWhere((element) => element.key == "currentHp").value.toInt() ?? 0;
  }

  Future<void> _generateCharacter() async {
    _displayText("Generating character...", false);
    var sdkResponse = await PylonsWallet.instance.txExecuteRecipe(
        cookbookId: "appTestCookbook",
        recipeName: "RecipeTestAppGetCharacter",
        itemIds: [],
        coinInputIndex: 0,
        paymentInfo: []);
    if (!sdkResponse.success) {
      throw Exception("character generation tx should not fail");
    }
    var txhash = "TODO"; // this is obv. wrong
    // grab the tx somehow?
    // then grab the character id out of it
    var itemId = "NOPE";
    sdkResponse = await PylonsWallet.instance.getItemById(cookbookId: "appTestCookbook", itemId: itemId);
    _character = sdkResponse.data as Item;
  }

  Future<void> _fightGoblin() async {
    _displayText("Fighting a goblin...", false);
    var sdkResponse = await PylonsWallet.instance.txExecuteRecipe(
        cookbookId: "appTestCookbook",
        recipeName: "RecipeTestAppFightGoblin",
        itemIds: [_character!.id],
        coinInputIndex: 0,
        paymentInfo: []);
    if (!sdkResponse.success) {
      throw Exception("combat tx should not fail");
    }
    _displayText("Victory!", false);
    var lastHp = _curHp;
    var lastCoins = _coins;
    await _checkCharacter();
    if (lastHp != _curHp) {
      _displayText("Took ${lastHp - _curHp} damage!", false);
    }
    if (lastCoins != _coins) {
      _displayText("Found ${_coins - lastCoins} coins!", false);
    }
  }

  Future<void> _fightTroll() async {
    _displayText("Fighting a troll...", false);
    if (_swordLv < 1) {
      var sdkResponse = await PylonsWallet.instance.txExecuteRecipe(
          cookbookId: "appTestCookbook",
          recipeName: "RecipeTestAppFightTrollUnarmed",
          itemIds: [_character!.id],
          coinInputIndex: 0,
          paymentInfo: []);
      if (!sdkResponse.success) {
        throw Exception("combat tx should not fail");
      }
      _displayText("Defeat...", false);
      var lastHp = _curHp;
      await _checkCharacter();
      if (lastHp != _curHp) {
        _displayText("Took ${lastHp - _curHp} damage!", false);
      }
    } else {
      var sdkResponse = await PylonsWallet.instance.txExecuteRecipe(
          cookbookId: "appTestCookbook",
          recipeName: "RecipeTestAppFightTrollArmed",
          itemIds: [_character!.id],
          coinInputIndex: 0,
          paymentInfo: []);
      if (!sdkResponse.success) {
        throw Exception("combat tx should not fail");
      }
      _displayText("Victory!", false);
      var lastHp = _curHp;
      var lastShards = _shards;
      await _checkCharacter();
      if (lastHp != _curHp) {
        _displayText("Took ${lastHp - _curHp} damage!", false);
      }
      if (lastShards != _shards) {
        _displayText("Found ${_shards - lastShards} shards!", false);
      }
    }
  }

  Future<void> _fightDragon() async {
    _displayText("Fighting a dragon...", false);
    if (_swordLv < 2) {
      var sdkResponse = await PylonsWallet.instance.txExecuteRecipe(
          cookbookId: "appTestCookbook",
          recipeName: "RecipeTestAppFightDragonUnarmed",
          itemIds: [_character!.id],
          coinInputIndex: 0,
          paymentInfo: []);
      if (!sdkResponse.success) {
        throw Exception("combat tx should not fail");
      }
      _displayText("Defeat...", false);
      var lastHp = _curHp;
      await _checkCharacter();
      if (lastHp != _curHp) {
        _displayText("Took ${lastHp - _curHp} damage!", false);
      }
    } else {
      var sdkResponse = await PylonsWallet.instance.txExecuteRecipe(
          cookbookId: "appTestCookbook",
          recipeName: "RecipeTestAppFightDragonArmed",
          itemIds: [_character!.id],
          coinInputIndex: 0,
          paymentInfo: []);
      if (!sdkResponse.success) {
        throw Exception("combat tx should not fail");
      }
      _displayText("Victory!", false);
      var lastHp = _curHp;
      await _checkCharacter();
      if (lastHp != _curHp) {
        _displayText("Took ${lastHp - _curHp} damage!", false);
      }
    }
  }

  Future<void> _buySword() async {
    if (_swordLv > 0) {
      _displayText("You already have a sword", false);
    } else if (_coins < 50 ) {
      _displayText("You need 50 coins to buy a sword", false);
    } else {
      var sdkResponse = await PylonsWallet.instance.txExecuteRecipe(
          cookbookId: "appTestCookbook",
          recipeName: "RecipeTestAppBuySword",
          itemIds: [_character!.id],
          coinInputIndex: 0,
          paymentInfo: []);
      if (!sdkResponse.success) {
        throw Exception("purchase tx should not fail");
      }
      _displayText("Bought a sword!", false);
      var lastCoins = _coins;
      await _checkCharacter();
      if (lastCoins != _coins) {
        _displayText("Spent ${lastCoins - _coins} coins!", false);
      }
    }
  }

  Future<void> _upgradeSword() async {
    if (_swordLv > 1) {
      _displayText("You already have an upgraded sword", false);
    } else if (_shards < 5) {
      _displayText("You need 5 shards to upgrade your sword", false);
    } else {
      var sdkResponse = await PylonsWallet.instance.txExecuteRecipe(
          cookbookId: "appTestCookbook",
          recipeName: "RecipeTestAppUpgradeSword",
          itemIds: [_character!.id],
          coinInputIndex: 0,
          paymentInfo: []);
      if (!sdkResponse.success) {
        throw Exception("purchase tx should not fail");
      }
      _displayText("Upgraded your sword!", false);
      var lastShards = _shards;
      await _checkCharacter();
      if (lastShards != _shards) {
        _displayText("Spent ${lastShards - _shards} shards!", false);
      }
    }
  }

  Future<void> _rest1() async {
    _displayText("Resting...", false);
    var sdkResponse = await PylonsWallet.instance.txExecuteRecipe(
        cookbookId: "appTestCookbook",
        recipeName: "RecipeTestAppRest25",
        itemIds: [_character!.id],
        coinInputIndex: 0,
        paymentInfo: []);
    if (!sdkResponse.success) {
      throw Exception("rest tx should not fail");
    }
    //dunno how to get exec either...
    var exec = "TODO";
    while (true) {
      _displayText("...", false);
      sdkResponse = await PylonsWallet.instance.getExecutionBasedOnId(id: exec);
      // if completed break
    }
    _displayText("Done!", false);
    var lastHp = _curHp;
    await _checkCharacter();
    if (lastHp != _curHp) {
      _displayText("Recovered ${_curHp - lastHp} HP!", false);
    }
  }

  Future<void> _rest2() async {
    _displayText("Resting...", false);
    var sdkResponse = await PylonsWallet.instance.txExecuteRecipe(
        cookbookId: "appTestCookbook",
        recipeName: "RecipeTestAppRest50",
        itemIds: [_character!.id],
        coinInputIndex: 0,
        paymentInfo: []);
    if (!sdkResponse.success) {
      throw Exception("rest tx should not fail");
    }
    //dunno how to get exec either...
    var exec = "TODO";
    while (true) {
      _displayText("...", false);
      sdkResponse = await PylonsWallet.instance.getExecutionBasedOnId(id: exec);
      // if completed break
    }
    _displayText("Done!", false);
    var lastHp = _curHp;
    await _checkCharacter();
    if (lastHp != _curHp) {
      _displayText("Recovered ${_curHp - lastHp} HP!", false);
    }
  }

  Future<void> _rest3() async {
    _displayText("Resting...", false);
    var sdkResponse = await PylonsWallet.instance.txExecuteRecipe(
        cookbookId: "appTestCookbook",
        recipeName: "RecipeTestAppRest100",
        itemIds: [_character!.id],
        coinInputIndex: 0,
        paymentInfo: []);
    if (!sdkResponse.success) {
      throw Exception("rest tx should not fail");
    }
    //dunno how to get exec either...
    var exec = "TODO";
    while (true) {
      _displayText("...", false);
      sdkResponse = await PylonsWallet.instance.getExecutionBasedOnId(id: exec);
      // if completed break
    }
    _displayText("Done!", false);
    var lastHp = _curHp;
    await _checkCharacter();
    if (lastHp != _curHp) {
      _displayText("Recovered ${_curHp - lastHp} HP!", false);
    }
  }

  Future<void> _rest4() async {
    if (_pylons < 9) {
      _displayText("You need 9 Pylons Points to take a power nap!", false);
      return;
    }
    _displayText("Resting...", false);
    var sdkResponse = await PylonsWallet.instance.txExecuteRecipe(
        cookbookId: "appTestCookbook",
        recipeName: "RecipeTestAppRest100Premium",
        itemIds: [_character!.id],
        coinInputIndex: 0,
        paymentInfo: []);
    if (!sdkResponse.success) {
      throw Exception("rest tx should not fail");
    }
    _displayText("Done!", false);
    var lastHp = _curHp;
    await _checkCharacter();
    if (lastHp != _curHp) {
      _displayText("Recovered ${_curHp - lastHp} HP!", false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(
            // Column is also a layout widget. It takes a list of children and
            // arranges them vertically. By default, it sizes itself to fit its
            // children horizontally, and tries to be as tall as its parent.
            //
            // Invoke "debug painting" (press "p" in the console, choose the
            // "Toggle Debug Paint" action from the Flutter Inspector in Android
            // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
            // to see the wireframe for each widget.
            //
            // Column has various properties to control how it sizes itself and
            // how it positions its children. Here we use mainAxisAlignment to
            // center the children vertically; the main axis here is the vertical
            // axis because Columns are vertical (the cross axis would be
            // horizontal).
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Container(
                      decoration: BoxDecoration(color: Colors.black, border: Border.all(color: Colors.white)),
                      padding: EdgeInsets.zero,
                      child: Padding(padding: const EdgeInsets.all(32),
                          child: Text(_text, style: const TextStyle(color: Colors.white, fontSize: 16)))
                  )),
              SizedBox.fromSize(
                size: const Size.fromHeight(120),
                child:             Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(color: Colors.black, border: Border.all(color: Colors.white)),
                      padding: EdgeInsets.zero,
                      child: _displayMenuButtons ? Row(
                        children: [
                          TextButton(onPressed: () => {_fightGoblin()}, child: const Text("0")),
                          TextButton(onPressed: () => {_fightTroll()}, child: const Text("1")),
                          TextButton(onPressed: () => {_fightDragon()}, child: const Text("2")),
                          TextButton(onPressed: () => {_buySword()}, child: const Text("3")),
                          TextButton(onPressed: () => {_upgradeSword()}, child: const Text("4")),
                          TextButton(onPressed: () => {_rest1()}, child: const Text("5")),
                          TextButton(onPressed: () => {_rest2()}, child: const Text("6")),
                          TextButton(onPressed: () => {_rest3()}, child: const Text("7")),
                          TextButton(onPressed: () => {_rest4()}, child: const Text("9"))
                        ],
                      ) : TextButton(onPressed: () => {_displayText(menu, true)}, child: const Text("OK")),
                    )),
              )
            ],
          ),
        )
    );
  }
}
