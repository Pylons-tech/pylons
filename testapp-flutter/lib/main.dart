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
  Profile? profile;
  int swordLv = 0;
  int coins = 0;
  int shards = 0;
  int curHp = 0;
  int trophiesWon = 0;
  Int64 pylons = Int64.ZERO;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bootstrap();
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
            Text("HP: $curHp/20 | Sword level $swordLv | $coins coins | $shards shards\n$trophiesWon trophies won",
                style: const TextStyle(fontSize: 18)),
            const Divider(),
            Text(flavorText, style: const TextStyle(fontSize: 18)),
            const Divider(),
            showTopLevelMenu ? topLevelMenu() : Container(),
          ])),
    );
  }

  Widget topLevelMenu() {
    // if (curHp < 1) {
    //   return quitButton();
    // }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          onPressed: () {
            _fightGoblin();
          },
          child: const Text('Fight a goblin!'),
        ),
        ElevatedButton(
          onPressed: () {
            _fightTroll();
          },
            child: _canSurviveDragon() ? const Text('Fight a troll!') : const Text('💀 Fight a troll! 💀')
        ),
        ElevatedButton(
          onPressed: () {
            _fightDragon();
          },
          child: _canSurviveDragon() ? const Text('Fight a dragon!') : const Text('💀 Fight a dragon! 💀')
        ),
        swordLv < 1 ? ElevatedButton(
          onPressed: () {
            _canBuySword() ? _buySword() : () {};
          },
          style: _canBuySword() ? const ButtonStyle() : ButtonStyle(enableFeedback: false, overlayColor: MaterialStateProperty.all(Colors.grey)),
          child: const Text('Buy a sword!'),
        ) : Container(),
        swordLv == 1 ? ElevatedButton(
          onPressed: () {
            _canUpgradeSword() ? _upgradeSword() : {};
          },
          style: _canUpgradeSword() ? const ButtonStyle() : ButtonStyle(enableFeedback: false, overlayColor: MaterialStateProperty.all(Colors.grey)),
          child: const Text('Upgrade your sword!'),
        ): Container(),
        ElevatedButton(
          onPressed: () {
            _rest1();
          },
          child: const Text('Rest and recover! (Cost: \$0.0000009)'),
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

  Future<void> _bootstrap() async {
    await Cookbook.load("appTestCookbook");
    await _checkCharacter();
    if (kDebugMode) {
      print("character exists: ${character != null}");
    }
    if (character == null || curHp < 1) {
      await _generateCharacter();
      if (kDebugMode) {
        print("after generate - character exists: ${character != null}");
      }
    }
  }

  Future<void> _checkCharacter() async {
    print(StackTrace.current);
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
      print("got profile");
    }
    if (prf == null) throw Exception("HANDLE THIS");
    profile = prf;
    pylons = profile!.coins["upylon"] ?? Int64.ZERO;
    if (kDebugMode) {
      print("(ok!)");
    }
    var lastUpdate = Int64.MIN_VALUE;
    var trophies = 0;
    if (character == null || curHp < 1) {
      for (var item in prf.items) {
        switch (item.getString("entityType")) {
          case "character": {
            if (!(item.getInt("currentHp")?.isZero ?? true) ||
                !(item.getInt("currentHp")?.isNegative ?? true)) {
              if (item.getLastUpdate() > lastUpdate) {
                setState(() {
                  character = item;
                });
                lastUpdate = item.getLastUpdate();
              }
            }
            break;
          }
          case "trophy": {
            trophies++;
            break;
          }
        }
      }
    } else {
      character = await Item.get(character!.getId());
    }
    setState(() {
      swordLv = character?.getInt("swordLevel")?.toInt() ?? 0;
      coins = character?.getInt("coins")?.toInt() ?? 0;
      shards = character?.getInt("shards")?.toInt() ?? 0;
      curHp = character?.getInt("currentHp")?.toInt() ?? 0;
      trophiesWon = trophies;
      flavorText = "Got character!";
      showTopLevelMenu = tlmDefault;
    });
  }

  Future<void> _generateCharacter() async {
    setState(() {
      showTopLevelMenu = false;
      flavorText = "Generating character...";
    });
    final recipe = Recipe.let("RecipeTestAppGetCharacter");
    await recipe.executeWith(profile!, []).onError((error, stackTrace) {
      throw Exception("character generation tx should not fail");
    });
    //final itemId = exec.getItemOutputIds().first;
    //final chr = await Item.get(itemId);
    //setState(() {
    //character = chr;
    //});
    await _checkCharacter();
    setState(() {
      showTopLevelMenu = true;
    });
  }

  bool _canSurviveTroll() {
    return swordLv >= 1;
  }

  bool _canSurviveDragon() {
    return swordLv >= 2;
  }

  Future<void> _fightGoblin() async {
    var buffer = StringBuffer("Fighting a goblin...");
    setState(() {
      showTopLevelMenu = false;
      flavorText = buffer.toString();
    });
    final recipe = Recipe.let("RecipeTestAppFightGoblin");
    await recipe.executeWith(profile!, [character!]).onError((error, stackTrace) {
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
    if (!_canSurviveTroll()) {
      final recipe = Recipe.let("RecipeTestAppFightTrollUnarmed");
      await recipe.executeWith(profile!, [character!]).onError((error, stackTrace) {
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
        if (curHp < 1) buffer.writeln(("You are dead."));
      }
      setState(() {
        flavorText = buffer.toString();
      });
    } else {
      final recipe = Recipe.let("RecipeTestAppFightTrollArmed");
      await recipe.executeWith(profile!, [character!]).onError((error, stackTrace) {
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
    if (!_canSurviveDragon()) {
      final recipe = Recipe.let("RecipeTestAppFightDragonUnarmed");
      await recipe.executeWith(profile!, [character!]).onError((error, stackTrace) {
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
        if (curHp < 1) buffer.writeln(("You are dead."));
      }
      setState(() {
        flavorText = buffer.toString();
      });
    } else {
      final recipe = Recipe.let("RecipeTestAppFightDragonArmed");
      await recipe.executeWith(profile!, [character!]).onError((error, stackTrace) {
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

  bool _canBuySword () {
    return coins >= 50;
  }

  bool _hasBoughtSword () {
    return swordLv > 0;
  }

  bool _canUpgradeSword () {
    return coins >= 50;
  }

  bool _hasUpgradedSword () {
    return swordLv > 1;
  }

  Future<void> _buySword() async {
    setState(() {
      showTopLevelMenu = false;
    });
    final recipe = Recipe.let("RecipeTestAppBuySword");
    await recipe.executeWith(profile!, [character!]).onError((error, stackTrace) {
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
    setState(() {
      showTopLevelMenu = true;
    });
  }

  Future<void> _upgradeSword() async {
    setState(() {
      showTopLevelMenu = false;
    });
    final recipe = Recipe.let("RecipeTestAppUpgradeSword");
    await recipe.executeWith(profile!, [character!]).onError((error, stackTrace) {
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
    setState(() {
      showTopLevelMenu = true;
    });
  }

  Future<void> _rest1() async {
    setState(() {
      showTopLevelMenu = false;
    });
    if (pylons < 9) {
      var buffer = StringBuffer("Pretend you were sent to go spend some money pls");
      setState(() {
        flavorText = buffer.toString();
        showTopLevelMenu = true;
      });
      return;
    }
    var buffer = StringBuffer("Resting...!");
    setState(() {
      flavorText = buffer.toString();
    });
    final recipe = Recipe.let("RecipeTestAppRest100Premium");
    await recipe.executeWith(profile!, [character!]).onError((error, stackTrace) {
      throw Exception("rest tx should not fail");
    });
    buffer.writeln("Done!");
    setState(() {
      flavorText = buffer.toString();
    });
    final lastHp = curHp;
    await _checkCharacter();
    if (lastHp != curHp) {
      buffer.writeln("Recovered ${curHp - lastHp} HP!");
    }
    setState(() {
      flavorText = buffer.toString();
      showTopLevelMenu = true;
    });
  }

  // todo: delayed execs don't actually work at all, so
  Future<void> _rest2() async {
    setState(() {
      showTopLevelMenu = false;
    });
    if (pylons < 9) {
      var buffer = StringBuffer("Pretend you were sent to go spend some money pls");
      setState(() {
        flavorText = buffer.toString();
        showTopLevelMenu = true;
      });
      return;
    }
    var buffer = StringBuffer("Resting...!");
    setState(() {
      flavorText = buffer.toString();
    });
    final recipe = Recipe.let("RecipeTestAppRest100");
    final exec = await recipe.executeWith(profile!, [character!]).onError((error, stackTrace) {
      throw Exception("rest tx should not fail");
    });
    while (true) {
      setState(() {
        buffer.writeln("...");
        flavorText = buffer.toString();
      });
      // lol. lmao.
      // final r = await exec.refresh();
      // if (r != null) {
      //   break;
      // }
    }

    buffer.writeln("Done!");
    setState(() {
      flavorText = buffer.toString();
    });
    final lastHp = curHp;
    await _checkCharacter();
    if (lastHp != curHp) {
      buffer.writeln("Recovered ${curHp - lastHp} HP!");
    }
    setState(() {
      flavorText = buffer.toString();
      showTopLevelMenu = true;
    });
  }
}
