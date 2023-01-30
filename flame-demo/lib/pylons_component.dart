import 'package:dartz/dartz.dart';
import 'package:pylons_sdk/pylons_sdk.dart';
import 'package:flame/components.dart';

class PylonsComponent extends Component {
  final List<_DispatchedAction> _actions = [];
  Profile? _last;

  @override
  void onLoad() {

  }

  @override
  void update(double dt) {
    super.update(dt);
    for (final action in _actions) {
      if (action.done) {
        for (final callback in action.callbacks) {
          callback(action.value);
        }
        _actions.remove(action);
      }
    }
  }

  void _requireProfile() {
    if (_last == null) {
      throw Exception("Must have retrieved a profile before executing transactions");
    }
  }

  void executeRecipe(Recipe rcp, List<Item> inputs, List<Function1<Execution?, void>> callbacks) {
    _requireProfile();
    final future = rcp.executeWith(_last!, inputs);
    _actions.add(_DispatchedAction<Execution?>(future, callbacks));
  }

  void getProfile(List<Function1<Profile?, void>> callbacks) {
    final future = Profile.get();
    _actions.add(_DispatchedAction<Profile?>(future, callbacks..add((prf) => _last = prf)));
  }
}

class _DispatchedAction<T> {
  List<Function1<T, void>> callbacks;
  Future<T> future;
  bool done = false;
  late T value;

  _DispatchedAction(this.future, this.callbacks) {
    future.whenComplete(() async => { value = await future, done = true });
  }
}