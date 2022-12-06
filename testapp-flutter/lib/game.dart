import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pylons_sdk/pylons_sdk.dart';
import 'package:fixnum/fixnum.dart';

class Game extends StatefulWidget {
  const Game({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
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
                showTopLevelMenu ? _TopLevelMenu(this) : Container(),
              ])),
    );
  }

  Future<void> _bootstrap() async {
    await Cookbook.load("appTestCookbook");
    await _checkCharacter();
    if (character == null || curHp < 1) {
      await _generateCharacter();
    }
  }

  Future<void> _updateProfile() async {
    final prf = await Profile.get();
    if (prf == null) throw Exception("Profile should not be null");
    profile = prf;
    pylons = profile!.coins["upylon"] ?? Int64.ZERO;
  }

  Future<void> _checkCharacter() async {
    final tlmDefault = showTopLevelMenu;
    _nonCombatActionInit('Checking character...');
    await _updateProfile();
    var lastUpdate = Int64.MIN_VALUE;
    var trophies = 0;
    for (var item in profile!.items) {
      switch (item.getString("entityType")) {
        case "character": {
          if (character == null || curHp < 1) {
            if (!(item.getInt("currentHp")?.isZero ?? true) ||
                !(item.getInt("currentHp")?.isNegative ?? true)) {
              if (item.getLastUpdate() > lastUpdate) {
                setState(() { character = item; });
                lastUpdate = item.getLastUpdate();
              }
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
    setState(() {
      _populateFieldsFromCharacter();
      trophiesWon = trophies;
      flavorText = "Got character!";
      showTopLevelMenu = tlmDefault;
    });
  }

  Future<void> _generateCharacter() async {
    _nonCombatActionInit('Generating character...');
    final recipe = Recipe.let("RecipeTestAppGetCharacter");
    final exec = await recipe.executeWith(profile!, []).onError((error, stackTrace) {
      throw Exception("character generation tx should not fail");
    });
    final itemId = exec.getItemOutputIds().first;
    final chr = await Item.get(itemId);
    setState(() { character = chr; });
    await _checkCharacter();
    setState(() { showTopLevelMenu = true; });
  }

  Future<void> _fightGoblin() async => await _combatRecipeHandlerWinnable(await _combatActionInit('goblin'), 'RecipeTestAppFightGoblin');

  Future<void> _fightTroll() async {
    final buffer = await _combatActionInit('troll');
    if (!_canSurviveTroll()) {
      await _combatRecipeHandlerUnwinnable(buffer, 'RecipeTestAppFightTrollUnarmed');
    } else {
      await _combatRecipeHandlerWinnable(buffer, 'RecipeTestAppFightTrollArmed');
    }
  }

  Future<void> _fightDragon() async {
    final buffer = await _combatActionInit('dragon');
    if (!_canSurviveTroll()) {
      await _combatRecipeHandlerUnwinnable(buffer, 'RecipeTestAppFightDragonUnarmed');
    } else {
      await _combatRecipeHandlerWinnable(buffer, 'RecipeTestAppFightDragonArmed');
    }
  }

  Future<void> _buySword() async => await _characterMutationRecipeHandler('RecipeTestAppBuySword', 'Bought a sword!');

  Future<void> _upgradeSword() async => await _characterMutationRecipeHandler('RecipeTestAppUpgradeSword', 'Upgraded your sword!');

  Future<void> _rest() async {
    setState(() { showTopLevelMenu = false; });
    if (pylons < 9) {
      final buffer = StringBuffer("Pretend you were sent to go spend some money pls");
      setState(() {
        flavorText = buffer.toString();
        showTopLevelMenu = true;
      });
      return;
    }
    final buffer = StringBuffer("Resting...!");
    setState(() { flavorText = buffer.toString(); });
    final recipe = Recipe.let("RecipeTestAppRest100Premium");
    await recipe.executeWith(profile!, [character!]).onError((error, stackTrace) {
      throw Exception("rest tx should not fail");
    });
    buffer.writeln("Done!");
    setState(() { flavorText = buffer.toString(); });
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

  void _populateFieldsFromCharacter() {
    swordLv = character?.getInt("swordLevel")?.toInt() ?? 0;
    coins = character?.getInt("coins")?.toInt() ?? 0;
    shards = character?.getInt("shards")?.toInt() ?? 0;
    curHp = character?.getInt("currentHp")?.toInt() ?? 0;
  }

  void _nonCombatActionInit(String text) {
    setState(() {
      showTopLevelMenu = false;
      flavorText = text;
    });
  }

  Future<StringBuffer> _combatActionInit(String monsterName) async {
    final buffer = StringBuffer("Fighting a $monsterName...");
    setState(() {
      showTopLevelMenu = false;
      flavorText = buffer.toString();
    });
    return buffer;
  }

  Future<void> _characterMutationRecipeHandler(String rcp, String successText) async {
    setState(() { showTopLevelMenu = false; });
    final recipe = Recipe.let(rcp);
    await recipe.executeWith(profile!, [character!]).onError((error, stackTrace) {
      throw Exception("purchase tx should not fail");
    });
    final buffer = StringBuffer(successText);
    setState(() { flavorText = buffer.toString(); });
    final lastCoins = coins;
    final lastShards = shards;
    await _checkCharacter();
    if (lastCoins != coins) {
      buffer.writeln("Spent ${lastCoins - coins} coins!");
    }
    if (lastShards != shards) {
      buffer.writeln("Spent ${lastShards - shards} shards!");
    }
    setState(() { flavorText = buffer.toString(); });
    setState(() { showTopLevelMenu = true; });
  }

  Future<void> _combatRecipeHandlerWinnable(StringBuffer buffer, String rcp) async {
    final recipe = Recipe.let(rcp);
    await recipe.executeWith(profile!, [character!]).onError((error, stackTrace) {
      throw Exception("combat tx should not fail");
    });
    buffer.writeln("Victory!");
    setState(() {
      flavorText = buffer.toString();
    });
    final lastHp = curHp;
    final lastCoins = coins;
    final lastShards = shards;
    await _checkCharacter();
    if (lastHp != curHp) {
      buffer.writeln("Took ${lastHp - curHp} damage!");
    }
    if (lastCoins != coins) {
      buffer.writeln("Found ${coins - lastCoins} coins!");
    }
    if (lastShards != shards) {
      buffer.writeln("Found ${shards - lastShards} shards!");
    }
    setState(() {
      showTopLevelMenu = true;
      flavorText = buffer.toString();
    });
  }

  Future<void> _combatRecipeHandlerUnwinnable(StringBuffer buffer, String rcp) async {
    final recipe = Recipe.let(rcp);
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
  }

  bool _canSurviveTroll() => swordLv >= 1;
  bool _canSurviveDragon() => swordLv >= 2;
  bool _canBuySword () => coins >= 50;
  bool _hasBoughtSword () => swordLv > 0;
  bool _canUpgradeSword () => coins >= 50;
  bool _hasUpgradedSword () => swordLv > 1;
}

class _TopLevelMenu extends StatelessWidget {
  final _GameState _homePageState;
  const _TopLevelMenu(this._homePageState);

  @override
  Widget build(BuildContext context) {
    if (_homePageState.curHp < 1) {
      return _QuitButton();
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          onPressed: () {
            _homePageState._fightGoblin();
          },
          child: const Text('Fight a goblin!'),
        ),
        ElevatedButton(
            onPressed: () {
              _homePageState._fightTroll();
            },
            child: _homePageState._canSurviveTroll() ? const Text('Fight a troll!') : const Text('💀 Fight a troll! 💀')
        ),
        ElevatedButton(
            onPressed: () {
              _homePageState._fightDragon();
            },
            child: _homePageState._canSurviveDragon() ? const Text('Fight a dragon!') : const Text('💀 Fight a dragon! 💀')
        ),
        !_homePageState._hasBoughtSword() ? ElevatedButton(
          onPressed: () {
            _homePageState._canBuySword() ? _homePageState._buySword() : () {};
          },
          style: _homePageState._canBuySword() ? const ButtonStyle() : ButtonStyle(enableFeedback: false, backgroundColor: MaterialStateProperty.all(Colors.grey), overlayColor: MaterialStateProperty.all(Colors.grey)),
          child: const Text('Buy a sword!'),
        ) : Container(),
        _homePageState._hasBoughtSword() && !_homePageState._hasUpgradedSword() ? ElevatedButton(
          onPressed: () {
            _homePageState._canUpgradeSword() ? _homePageState._upgradeSword() : {};
          },
          style: _homePageState._canUpgradeSword() ? const ButtonStyle() : ButtonStyle(enableFeedback: false, backgroundColor: MaterialStateProperty.all(Colors.grey), overlayColor: MaterialStateProperty.all(Colors.grey)),
          child: const Text('Upgrade your sword!'),
        ): Container(),
        ElevatedButton(
          onPressed: () {
            _homePageState.
            _rest();
          },
          child: const Text('Rest and recover! (Cost: \$0.0000009)'),
        ),
        _QuitButton()
      ],
    );
  }
}

class _QuitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      },
      child: const Text('Quit'),
    );
  }
}