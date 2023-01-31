import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:pylons_sdk/pylons_sdk.dart';
import 'package:flame/components.dart';

class PylonsComponent extends Component {
  final List<_DispatchedAction> _actions = [];
  static PylonsComponent? _instance;
  static PylonsComponent get instance => _instance!;
  Profile? _last;
  bool _ready = false;
  bool get ready => _ready;

  @override
  void onLoad() {
    super.onLoad();
    if (_instance != null) {
      throw Exception("There should be only one instance of PylonsComponent");
    }
    _instance = this;
    PylonsWallet.verifyOrInstall().then(
            (_) async {
          await Cookbook.load("appTestCookbook");
          _ready = true;
        }
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    for (int i = _actions.length - 1; i > -1; i--) {
      if (_actions[i].done) {
        // HACK: doing this dynamically doesn't work. there is probably a better, more durable way to handle this.
        if (_actions[i].runtimeType == _DispatchedAction<Profile?>) {
          final a = _actions[i] as _DispatchedAction<Profile?>;
          for (var callback in a.callbacks) {
            callback(a.value);
          }
        } else if (_actions[i].runtimeType == _DispatchedAction<Execution?>) {
          final a = _actions[i] as _DispatchedAction<Execution?>;
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

  void executeRecipe(Recipe rcp, List<Item> inputs, List<Function1<Execution?, void>> callbacks) {
    _requireReady();
    _requireProfile();
    final future = rcp.executeWith(_last!, inputs);
    _actions.add(_DispatchedAction<Execution?>(future, callbacks));
  }

  void getProfile(List<Function1<Profile?, void>> callbacks) {
    _requireReady();
    final future = Profile.get();
    _actions.add(_DispatchedAction<Profile?>(future, callbacks..add((prf) {
      _last = prf;
    })));
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