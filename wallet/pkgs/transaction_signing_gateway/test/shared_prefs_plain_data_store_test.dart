import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:transaction_signing_gateway/storage/shared_prefs_plain_data_store.dart';

import 'mocks/stub_shared_preferences.dart';

void main() {
  late SharedPrefsPlainDataStore store;
  late StubSharedPreferences sharedPrefs;

  setUp(() {
    sharedPrefs = StubSharedPreferences();
    store = SharedPrefsPlainDataStore(sharedPreferencesProvider: () async => sharedPrefs);
  });
  //
  test('storing value should allow to retrieve it', () async {
    //GIVEN
    const key = 'key_of_complex_data';
    const value = '{"some":"complex","value": true}';

    //WHEN
    await store.savePlainText(key: key, value: value);

    //THEN
    expect(await store.readPlainText(key: key), right(value));
  });
  //
  test('store should not show data stored directly in the sharedPrefs', () async {
    //GIVEN
    const key = 'key_of_complex_data';
    const value = '{"some":"complex","value": true}';
    await sharedPrefs.setString('one', 'value');
    await sharedPrefs.setString('two', 'value');
    await sharedPrefs.setString('three', 'value');

    //WHEN
    await store.savePlainText(key: key, value: value);
    final allTexts = await store.readAllPlainText();

    //THEN
    expect(await store.readPlainText(key: key), right(value));
    expect(allTexts.isRight(), true);
    expect(allTexts.getOrElse(() => {}), {key: value});

    expect(await store.readPlainText(key: 'one'), right(null));
    expect(await store.readPlainText(key: 'two'), right(null));
    expect(await store.readPlainText(key: 'three'), right(null));
  });
  //
}
