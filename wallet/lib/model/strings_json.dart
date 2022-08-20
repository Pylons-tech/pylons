/// key : "Name"
/// rate : "0.000000000000000001"
/// value : "title title"
/// program : ""

class Strings {
  late String key;
  late String value;
  late String program;

  Strings({
    required this.key,
    required this.value,
    required this.program,
  });

  Strings.fromJson(Map<String, dynamic> json) {
    key = json['key'] as String;
    value = json['value'] as String;
    program = json['program'] as String;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['key'] = key;
    map['value'] = value;
    map['program'] = program;
    return map;
  }
}
