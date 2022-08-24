import 'package:flutter_test/flutter_test.dart';

void main() {
  group('JSON deserialization tests', () {});
  // group('JSON serialization tests', () {
  //   test('Recipe JSON from remote deserializes correctly', () {
  //     throw UnimplementedError();
  //   });
  //   test('CoinInput deserializes correctly', () {
  //     throw UnimplementedError();
  //   });
  //   test('ItemInput deserializes correctly', () {
  //     throw UnimplementedError();
  //   });
  //   test('CoinOutput deserializes correctly', () {
  //     throw UnimplementedError();
  //   });
  //   test('ItemModifyOutput deserializes correctly', () {
  //     throw UnimplementedError();
  //   });
  //   test('ItemOutput deserializes correctly', () {
  //     throw UnimplementedError();
  //   });
  //   test('WeightedOutput deserializes correctly', () {
  //     throw UnimplementedError();
  //   });
  //   test('EntriesList deserializes correctly', () {
  //     throw UnimplementedError();
  //   });
  //   test('FeeInputParam deserializes correctly', () {
  //     throw UnimplementedError();
  //   });
  // });
  group('Weblink tests', () {
    test('When generateWebLink called, web link is generated', () async {
      //expect(testRecipe.generateWebLink(), equals('TO DO - DeepLink'),
      //    skip: true);
    });
    test('When generateWebLink fails: , ____ exception returned', () async {
      //expect(() => testRecipe.generateWebLink(), throwsA(Exception()),
      //    skip: true);
    });
  });

  test('Test Coin Input from Json', () async {
    // var jsonRaw = '{"coin": "pylons", "count": 2}';
    //Map<String, dynamic> jsonMap = jsonDecode(jsonRaw);
    //var testCoinInputFromJson = CoinInput.fromJson(jsonMap);
    //expect(testCoinInputFromJson.coin, equals('pylons'));
    //expect(testCoinInputFromJson.count, equals(2));
  });

  test('Test Item Input', () async {
    // var jsonRaw =
    //     '{"id": "testItem", "conditions": {"doubles": {}, "longs":{}, "strings": {}}, "doubles": {}, "longs":{}, "strings": {}, "transferFee":{}}';
    // var jsonMap = Map<String, dynamic>.from(json.decode(jsonRaw));
    //var testItemInputFromJson = await ItemInput.fromJson(jsonMap);
    //expect(testItemInputFromJson.id, equals('testItem'));
    //expect(testItemInputFromJson.conditions.runtimeType, equals(ConditionList));
    //expect(testItemInputFromJson.transferFee.runtimeType, equals(FeeInputParam));
    //expect(testItemInputFromJson.doubles.length, equals(0));
    //expect(testItemInputFromJson.longs.length, equals(0));
    //expect(testItemInputFromJson.strings.length, equals(0));
  });
}
