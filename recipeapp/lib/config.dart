class Config {
  final String cookbook;
  final Map<String, double> doubleFilters;
  final Map<String, int> longFilters;
  final Map<String, String> stringFilters;

  Config(this.cookbook, this.doubleFilters, this.longFilters, this.stringFilters);
}