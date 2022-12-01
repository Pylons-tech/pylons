import 'package:pylons_sdk/pylons_sdk.dart';

class Config {
  final String cookbook;
  late final Cookbook _cookbook;
  final Map<String, double> doubleFilters;
  final Map<String, int> longFilters;
  final Map<String, String> stringFilters;

  Config(this.cookbook, this.doubleFilters, this.longFilters, this.stringFilters);

  Future<void> load () async {
    _cookbook = await Cookbook.load(cookbook);
  }


}