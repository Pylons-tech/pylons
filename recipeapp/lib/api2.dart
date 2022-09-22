import 'package:pylons_sdk/pylons_sdk.dart' as sdk;

class Cookbook {
  final sdk.Cookbook native;

  Execution execute_with(List<Item> inputs) {

  }
}

class Execution {
  final sdk.Execution native;

  Function(Execution) onSuccess;
  Function(Execution) onFailure;
  Function(Execution) onError;
}