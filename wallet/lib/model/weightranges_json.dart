/// lower : "23"
/// upper : "23"
/// weight : "1"

class WeightRanges {
  late String lower;
  late String upper;
  late String weight;

  WeightRanges({
    required this.lower,
    required this.upper,
    required this.weight,
  });

  WeightRanges.fromJson(dynamic json) {
    lower = json['lower'] as String;
    upper = json['upper'] as String;
    weight = json['weight'] as String;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['lower'] = lower;
    map['upper'] = upper;
    map['weight'] = weight;
    return map;
  }
}
