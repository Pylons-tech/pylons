import 'package:pylons_wallet/model/weightranges_json.dart';

/// key : "Residual"
/// weightRanges : [{"lower":"2000000000000000000.000000000000000000","upper":"2000000000000000000.000000000000000000","weight":"1"}]
/// program : "1"

class Doubles {
  late String key;
  late List<WeightRanges> weightRanges;
  late String program;

  Doubles({
    required this.key,
    required this.weightRanges,
    required this.program,
  });

  Doubles.fromJson(dynamic json) {
    key = json['key'] as String;
    if (json['weightRanges'] != null) {
      weightRanges = [];
      json['weightRanges'].forEach((v) {
        weightRanges.add(WeightRanges.fromJson(v));
      });
    }
    program = json['program'] as String;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['key'] = key;
    map['weightRanges'] = weightRanges.map((v) => v.toJson()).toList();
    map['program'] = program;
    return map;
  }
}
