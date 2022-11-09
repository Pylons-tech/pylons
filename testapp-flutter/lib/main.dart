import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
          print ("character exists: ${character != null}");
        }
        if (character == null) {
          await _generateCharacter();
          if (kDebugMode) {
            print ("after generate - character exists: ${character != null}");
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
              Text("HP: $curHp/20 | Sword level $swordLv | $coins coins | $shards shards", style: const TextStyle(fontSize: 18)),
              const Divider(),
              Text(flavorText,  style: const TextStyle(fontSize: 18)),
              const Divider(),
              showTopLevelMenu ? topLevelMenu() : Container(),
        ])
      ),
    );
  }

  Widget topLevelMenu() {
    if (curHp == 0) {
      return quitButton();
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          onPressed: () async {
            await _fightGoblin();
          },
          child: const Text('Fight a goblin!'),
        ),
        ElevatedButton(
          onPressed: () async {
            await _fightTroll();
          },
          child: const Text('Fight a troll!'),
        ),
        ElevatedButton(
          onPressed: () async {
            await _fightDragon();
          },
          child: const Text('Fight a dragon!'),
        ),
        ElevatedButton(
          onPressed: () async {
            await _buySword();
          },
          child: const Text('Buy a sword!'),
        ),
        ElevatedButton(
          onPressed: () async {
            await _upgradeSword();
          },
          child: const Text('Upgrade your sword!'),
        ),
        ElevatedButton(
          onPressed: () async {

          },
          child: const Text('Rest and recover!'),
        ),
        quitButton(),
      ],
    );
  }

  Widget quitButton() {
    return ElevatedButton(
      onPressed: () async {
        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      },
      child: const Text('Quit'),
    );
  }

  Future<void> _checkCharacter() async {
    final tlmDefault = showTopLevelMenu;
    setState(() {
      showTopLevelMenu = false;
      flavorText = "Checking character...";
    });
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
          setState(() {
            character = item;
          });
          lastUpdate = item.getLastUpdate();
        }
      }
    }
    if (kDebugMode) {
      print ("got character!");
    }
    setState(() {
      swordLv = character?.getInt("swordLevel")?.toInt() ?? 0;
      coins = character?.getInt("coins")?.toInt() ?? 0;
      shards = character?.getInt("shards")?.toInt() ?? 0;
      curHp = character?.getInt("currentHp")?.toInt() ?? 0;
      flavorText = "Got character!";
      showTopLevelMenu = tlmDefault;
    });
  }

  Future<void> _generateCharacter() async {
    setState(() {
      showTopLevelMenu = false;
      flavorText = "Generating character...";
    });
    final recipe = await Recipe.get("RecipeTestAppGetCharacter");
    if (recipe == null) throw Exception("todo: handle this");
    final exec = await recipe.executeWith([]).onError((error, stackTrace) {
      throw Exception("character generation tx should not fail");
    });
    final itemId = exec.getItemOutputIds().first;
    final chr = await Item.get(itemId);
    setState(() {
      character = chr;
    });
    await _checkCharacter();
    setState(() {
      showTopLevelMenu = true;
    });
  }

  Future<void> _fightGoblin() async {
    var buffer = StringBuffer("Fighting a goblin...");
    setState(() {
      showTopLevelMenu = false;
      flavorText = buffer.toString();
    });
    final recipe = await Recipe.get("RecipeTestAppFightGoblin");
    if (recipe == null) throw Exception("todo: handle this");
    await recipe.executeWith([character!]).onError((error, stackTrace) {
      throw Exception("combat tx should not fail");
    });
    buffer.writeln("Victory!");
    setState(() {
      flavorText = buffer.toString();
    });
    final lastHp = curHp;
    final lastCoins = coins;
    await _checkCharacter();
    if (lastHp != curHp) {
      buffer.writeln("Took ${lastHp - curHp} damage!");
    }
    if (lastCoins != coins) {
      buffer.writeln("Found ${coins - lastCoins} coins!");
    }
    setState(() {
      showTopLevelMenu = true;
      flavorText = buffer.toString();
    });
  }

  Future<void> _fightTroll() async {
    var buffer = StringBuffer("Fighting a troll...");
    setState(() {
      showTopLevelMenu = false;
      flavorText = buffer.toString();
    });
    if (swordLv < 1) {
      final recipe = await Recipe.get("RecipeTestAppFightTrollUnarmed");
      if (recipe == null) throw Exception("todo: handle this");
      await recipe.executeWith([character!]).onError((error, stackTrace) {
        throw Exception("combat tx should not fail");
      });
      buffer.writeln("Defeat...");
      setState(() {
        flavorText = buffer.toString();
      });
      var lastHp = curHp;
      await _checkCharacter();
      if (lastHp != curHp) {
        buffer.writeln("Took ${lastHp - curHp} damage!");
        if (curHp == 0) buffer.writeln(("You are dead."));
      }
      setState(() {
        flavorText = buffer.toString();
      });
    } else {
      final recipe = await Recipe.get("RecipeTestAppFightTrollArmed");
      if (recipe == null) throw Exception("todo: handle this");
      await recipe.executeWith([character!]).onError((error, stackTrace) {
        throw Exception("combat tx should not fail");
      });
      buffer.writeln("Victory!");
      setState(() {
        flavorText = buffer.toString();
      });
      final lastHp = curHp;
      final lastShards = shards;
      await _checkCharacter();
      if (lastHp != curHp) {
        buffer.writeln("Took ${lastHp - curHp} damage!");
      }
      if (lastShards != shards) {
        buffer.writeln("Found ${shards - lastShards} shards!");
      }
      setState(() {
        showTopLevelMenu = true;
        flavorText = buffer.toString();
      });
    }
  }

  Future<void> _fightDragon() async {
    var buffer = StringBuffer("Fighting a dragon...");
    setState(() {
      showTopLevelMenu = false;
      flavorText = buffer.toString();
    });
    if (swordLv < 2) {
      final recipe = await Recipe.get("RecipeTestAppFightDragonUnarmed");
      if (recipe == null) throw Exception("todo: handle this");
      await recipe.executeWith([character!]).onError((error, stackTrace) {
        throw Exception("combat tx should not fail");
      });
      buffer.writeln("Defeat...");
      setState(() {
        flavorText = buffer.toString();
      });
      var lastHp = curHp;
      await _checkCharacter();
      if (lastHp != curHp) {
        buffer.writeln("Took ${lastHp - curHp} damage!");
        if (curHp == 0) buffer.writeln(("You are dead."));
      }
      setState(() {
        flavorText = buffer.toString();
      });
    } else {
      final recipe = await Recipe.get("RecipeTestAppFightDragonArmed");
      if (recipe == null) throw Exception("todo: handle this");
      await recipe.executeWith([character!]).onError((error, stackTrace) {
        throw Exception("combat tx should not fail");
      });
      buffer.writeln("Victory!");
      setState(() {
        flavorText = buffer.toString();
      });
      final lastHp = curHp;
      await _checkCharacter();
      if (lastHp != curHp) {
        buffer.writeln("Took ${lastHp - curHp} damage!");
      }
      setState(() {
        showTopLevelMenu = true;
        flavorText = buffer.toString();
      });
    }
  }

  Future<void> _buySword() async {
    setState(() {
      showTopLevelMenu = false;
    });
    if (swordLv > 0) {
      setState(() {
        flavorText = "You already have a sword";
      });
    } else if (coins < 50 ) {
      setState(() {
        flavorText = "You need 50 coins to buy a sword";
      });
    } else {
      final recipe = await Recipe.get("RecipeTestAppBuySword");
      if (recipe == null) throw Exception("todo: handle this");
      await recipe.executeWith([character!]).onError((error, stackTrace) {
        throw Exception("purchase tx should not fail");
      });
      var buffer = StringBuffer("Bought a sword!");
      setState(() {
        flavorText = buffer.toString();
      });
      final lastCoins = coins;
      await _checkCharacter();
      if (lastCoins != coins) {
        buffer.writeln("Spent ${lastCoins - coins} coins!");
      }
      setState(() {
        flavorText = buffer.toString();
      });
    }
    setState(() {
      showTopLevelMenu = true;
    });
  }

  Future<void> _upgradeSword() async {
    setState(() {
      showTopLevelMenu = false;
    });
    if (swordLv > 1) {
      setState(() {
        flavorText = "You already have an upgraded sword";
      });
    } else if (shards < 5) {
      setState(() {
        flavorText = "You need 5 shards to upgrade your sword";
      });
    } else {
      final recipe = await Recipe.get("RecipeTestAppPurchaseUpgradeSword");
      if (recipe == null) throw Exception("todo: handle this");
      await recipe.executeWith([character!]).onError((error, stackTrace) {
        throw Exception("purchase tx should not fail");
      });
      var buffer = StringBuffer("Upgraded your sword!");
      setState(() {
        flavorText = buffer.toString();
      });
      final lastShards = shards;
      await _checkCharacter();
      if (lastShards != shards) {
        buffer.writeln("Spent ${lastShards - shards} shards!");
      }
      setState(() {
        flavorText = buffer.toString();
      });
    }
    setState(() {
      showTopLevelMenu = true;
    });
  }
}
