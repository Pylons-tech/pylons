import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:pylons_flame_demo/recipe.dart';
import 'package:pylons_sdk/low_level.dart' as ll;
import 'package:pylons_sdk/pylons_sdk.dart' as sdk;
import 'package:flame/components.dart';

import 'debug.dart';

class PylonsComponent extends Component {
  final List<_DispatchedAction> _actions = [];
  static PylonsComponent? _instance;
  static PylonsComponent get instance => _instance!;
  sdk.Profile? _last;
  sdk.Profile? get lastProfile => _last;
  bool _ready = false;
  bool get ready => _ready;
  final String _cookbook;

  PylonsComponent(this._cookbook);

  @override
  void onLoad() {
    super.onLoad();
    if (_instance != null) {
      throw Exception("There should be only one instance of PylonsComponent");
    }
    _instance = this;
    if (Debug.isOfflineBuild) {
      // probably need to do some setup stuff for mocks here?
      recipeGetWhatsit = Recipe(sdk.Recipe(ll.Recipe.create(), "RecipeGetWhatsit"), (notifier) => !notifier.hasThingamabob);
      recipeGet10Whatsits = Recipe(sdk.Recipe(ll.Recipe.create(), "RecipeGetWhatsitsWithThingamabob"), (notifier) => notifier.hasThingamabob);
      recipeGet100Whatsits = Recipe(sdk.Recipe(ll.Recipe.create(), "RecipeGetWhatsitsWithDoohickey"), (notifier) => notifier.hasDoohickey);
      recipeGetThingamabob = Recipe(sdk.Recipe(ll.Recipe.create(), "RecipeBuyThingamabob"), (notifier) => !notifier.hasThingamabob && notifier.whatsits >= 10);
      recipeGetDoo = Recipe(sdk.Recipe(ll.Recipe.create(), "RecipeBuyDoo"), (notifier) => !notifier.hasDoo && notifier.whatsits >= 70);
      recipeGetHickey = Recipe(sdk.Recipe(ll.Recipe.create(), "RecipeBuyHickey"), (notifier) => !notifier.hasHickey && notifier.whatsits >= 60);
      recipeGetDoohickey = Recipe(sdk.Recipe(ll.Recipe.create(), "RecipeMakeDoohickey"), (notifier) => notifier.hasDoo && notifier.hasHickey);
      _ready = true;
    } else {
      sdk.PylonsWallet.verifyOrInstall().then(
              (_) async {
            await sdk.Cookbook.load(_cookbook);
            recipeGetWhatsit = Recipe(sdk.Recipe.let("RecipeGetWhatsit"), (notifier) => !notifier.hasThingamabob);
            recipeGet10Whatsits = Recipe(sdk.Recipe.let("RecipeGetWhatsitsWithThingamabob"), (notifier) => notifier.hasThingamabob);
            recipeGet100Whatsits = Recipe(sdk.Recipe.let("RecipeGetWhatsitsWithDoohickey"), (notifier) => notifier.hasDoohickey);
            recipeGetThingamabob = Recipe(sdk.Recipe.let("RecipeBuyThingamabob"), (notifier) => !notifier.hasThingamabob && notifier.whatsits >= 10);
            recipeGetDoo = Recipe(sdk.Recipe.let("RecipeBuyDoo"), (notifier) => !notifier.hasDoo && notifier.whatsits >= 70);
            recipeGetHickey = Recipe(sdk.Recipe.let("RecipeBuyHickey"), (notifier) => !notifier.hasHickey && notifier.whatsits >= 60);
            recipeGetDoohickey = Recipe(sdk.Recipe.let("RecipeMakeDoohickey"), (notifier) => notifier.hasDoo && notifier.hasHickey);
            _ready = true;
          }
      );
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    for (int i = _actions.length - 1; i > -1; i--) {
      if (_actions[i].done) {
        // HACK: doing this dynamically doesn't work. there is probably a better, more durable way to handle this.
        if (_actions[i].runtimeType == _DispatchedAction<sdk.Profile?>) {
          final a = _actions[i] as _DispatchedAction<sdk.Profile?>;
          for (var callback in a.callbacks) {
            callback(a.value);
          }
        } else if (_actions[i].runtimeType == _DispatchedAction<sdk.Execution?>) {
          final a = _actions[i] as _DispatchedAction<sdk.Execution?>;
          for (var callback in a.callbacks) {
            callback(a.value);
          }
        }
        _actions.removeAt(i);
      }
    }
  }

  void _requireReady() {
    if (!_ready) {
      throw Exception("Can't run this command before wallet initialization is done"
          " - check PylonsComponent.ready before doing anything, if it's possible"
          "that the wallet might not be initialized yet");
    }
  }

  void _requireProfile() {
    if (_last == null) {
      throw Exception("Must have retrieved a profile before executing transactions");
    }
  }

  void executeRecipe(sdk.Recipe rcp, List<sdk.Item> inputs, List<Function1<sdk.Execution?, void>> callbacks) {
    _requireReady();
    _requireProfile();
    if (Debug.isOfflineBuild) {
      final exec = sdk.Execution(ll.Execution.create());
      final completer = Completer<sdk.Execution?>.sync();
      _actions.add(_DispatchedAction<sdk.Execution?>(completer.future, callbacks));
      completer.complete((exec));
    } else {
      final future = rcp.executeWith(_last!, inputs);
      _actions.add(_DispatchedAction<sdk.Execution?>(future, callbacks));
    }
  }

  void getProfile(List<Function1<sdk.Profile?, void>> callbacks) {
    _requireReady();
    if (Debug.isOfflineBuild) {
      final prf = sdk.Profile("nulladdress", "Username", {}, [], false);
      final completer = Completer<sdk.Profile?>.sync();
      _actions.add(_DispatchedAction<sdk.Profile?>(completer.future, callbacks..add((_) {
        _last = prf;
      })));
      completer.complete(prf);
    } else {
      final future = sdk.Profile.get();
      _actions.add(_DispatchedAction<sdk.Profile?>(future, callbacks..add((prf) {
        _last = prf;
      })));
    }
  }
}

class _DispatchedAction<T> {
  List<Function1<T, void>> callbacks;
  Future<T> future;
  bool done = false;
  late T value;

  _DispatchedAction(this.future, this.callbacks) {
    future.whenComplete(() async {
      value = await future;
      done = true;
    });
  }
}