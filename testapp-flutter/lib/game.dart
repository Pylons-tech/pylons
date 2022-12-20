import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pylons_sdk/pylons_sdk.dart';
import 'package:fixnum/fixnum.dart';
import 'package:testapp_flutter/character.dart';
import 'package:testapp_flutter/spinner.dart';

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
  Character? character;
  Profile? profile;

  int trophiesWon = 0;
  Int64 pylons = Int64.ZERO;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bootstrap();
    });
  }

  Future<void> _bootstrap() async {
    await Cookbook.load("appTestCookbook");
    await _checkRemoteState();
    if (_noValidCharacter()) {
      await _generateCharacter();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
          child: character != null ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text("HP: ${ character!.curHp }/20 | Sword level ${ character!.swordLv } | ${ character!.coins } coins | "
                    "${ character!.shards } shards\n$trophiesWon trophies won",
                    style: const TextStyle(fontSize: 18)),
                const Divider(),
                Text(flavorText, style: const TextStyle(fontSize: 18)),
                const Divider(),
                showTopLevelMenu ? _TopLevelMenu(this) : Container(),
              ]) : Container()),
    );
  }

  Future<void> _updateProfile() async {
    final prf = await Profile.get();
    if (prf == null) throw Exception("Profile should not be null");
    profile = prf;
    pylons = profile!.coins["upylon"] ?? Int64.ZERO;
  }

  Future<void> _checkRemoteState() async {
    final tlmDefault = showTopLevelMenu;
    _nonCombatActionInit('Checking character...');
    await _updateProfile();
    if (_noValidCharacter()) {
      setState(() {
        character = Character.fromProfile(profile!);
      });
    } else {
      character = Character(await character!.item.refresh());
    }
    _checkTrophies();
    setState(() {
      flavorText = "Got character!";
      showTopLevelMenu = tlmDefault;
    });
  }

  void _checkTrophies() {
    var trophies = 0;
    for (var item in profile!.items) {
      switch (item.getString("entityType")) {
        case "trophy": {
          trophies++;
          break;
        }
      }
    }
    setState(() {
      trophiesWon = trophies;
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
    setState(() { character = Character(chr); });
    await _checkRemoteState();
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

  Future<void> _buySword() async => await _characterUpgradeRecipeHandler('RecipeTestAppBuySword', 'Bought a sword!');

  Future<void> _upgradeSword() async => await _characterUpgradeRecipeHandler('RecipeTestAppUpgradeSword', 'Upgraded your sword!');

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
    await _restRecipeHandler('RecipeTestAppRest100Premium');
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

  Future<void> _restRecipeHandler(String rcp) async {
    final buffer = StringBuffer("Resting...!");
    setState(() {
      Spinner.enable(context);
      flavorText = buffer.toString();
    });
    final recipe = Recipe.let(rcp);
    await recipe.executeWith(profile!, [character!.item]).onError((error, stackTrace) {
      throw Exception("rest tx should not fail");
    });
    buffer.writeln("Done!");
    setState(() { flavorText = buffer.toString(); });
    final lastHp = character!.curHp;
    await _checkRemoteState();
    if (lastHp != character!.curHp) {
      buffer.writeln("Recovered ${character!.curHp - lastHp} HP!");
    }
    setState(() {
      Spinner.disable(context);
      flavorText = buffer.toString();
      showTopLevelMenu = true;
    });
  }

  Future<void> _characterUpgradeRecipeHandler(String rcp, String successText) async {
    setState(() {
      Spinner.enable(context);
      showTopLevelMenu = false;
    });
    final recipe = Recipe.let(rcp);
    await recipe.executeWith(profile!, [character!.item]).onError((error, stackTrace) {
      throw Exception("purchase tx should not fail");
    });
    final buffer = StringBuffer(successText);
    setState(() { flavorText = buffer.toString(); });
    final lastCoins = character!.coins;
    final lastShards = character!.shards;
    await _checkRemoteState();
    if (lastCoins != character!.coins) {
      buffer.writeln("Spent ${lastCoins - character!.coins} coins!");
    }
    if (lastShards != character!.shards) {
      buffer.writeln("Spent ${lastShards - character!.shards} shards!");
    }
    setState(() { flavorText = buffer.toString(); });
    setState(() {
      Spinner.disable(context);
      showTopLevelMenu = true;
    });
  }

  Future<void> _combatRecipeHandlerWinnable(StringBuffer buffer, String rcp) async {
    final recipe = Recipe.let(rcp);
    setState(() {
      Spinner.enable(context);
    });
    await recipe.executeWith(profile!, [character!.item]).onError((error, stackTrace) {
      throw Exception("combat tx should not fail");
    });
    buffer.writeln("Victory!");
    setState(() {
      flavorText = buffer.toString();
    });
    final lastHp = character!.curHp;
    final lastCoins = character!.coins;
    final lastShards = character!.shards;
    await _checkRemoteState();
    if (lastHp != character!.curHp) {
      buffer.writeln("Took ${lastHp - character!.curHp} damage!");
    }
    if (lastCoins != character!.coins) {
      buffer.writeln("Found ${character!.coins - lastCoins} coins!");
    }
    if (lastShards != character!.shards) {
      buffer.writeln("Found ${character!.shards - lastShards} shards!");
    }
    setState(() {
      Spinner.disable(context);
      showTopLevelMenu = true;
      flavorText = buffer.toString();
    });
  }

  Future<void> _combatRecipeHandlerUnwinnable(StringBuffer buffer, String rcp) async {
    final recipe = Recipe.let(rcp);
    setState(() {
      Spinner.enable(context);
    });
    await recipe.executeWith(profile!, [character!.item]).onError((error, stackTrace) {
      throw Exception("combat tx should not fail");
    });
    buffer.writeln("Defeat...");
    setState(() {
      flavorText = buffer.toString();
    });
    var lastHp = character!.curHp;
    await _checkRemoteState();
    if (lastHp != character!.curHp) {
      buffer.writeln("Took ${lastHp - character!.curHp} damage!");
      if (character!.isDead()) buffer.writeln(("You are dead."));
    }
    setState(() {
      Spinner.disable(context);
      flavorText = buffer.toString();
    });
  }

  bool _canSurviveTroll() => character!.swordLv >= 1;
  bool _canSurviveDragon() => character!.swordLv >= 2;
  bool _canBuySword () => character!.coins >= 50;
  bool _hasBoughtSword () => character!.swordLv > 0;
  bool _canUpgradeSword () => character!.coins >= 50;
  bool _hasUpgradedSword () => character!.swordLv > 1;
  bool _noValidCharacter () => character == null || character!.isDead();
}

class _TopLevelMenu extends StatelessWidget {
  final _GameState _homePageState;
  const _TopLevelMenu(this._homePageState);

  @override
  Widget build(BuildContext context) {
    if (_homePageState._noValidCharacter()) {
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