import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mocks/mock_constants.dart';
import '../../mocks/mock_wallet_store.dart';

void main() {
  late MockWalletStore walletsStoreImp;

  setUp(() {
    dotenv.testLoad(fileInput: '''ENV=true''');

    walletsStoreImp = MockWalletStore();
  });

  group('getProfile', () {
    test('should return the create account error', () async {
      final response = await walletsStoreImp.getProfile();
      expect(response.success, true);
    });
  });

  test("this is test case for buy nft", () async {
    final response = await walletsStoreImp.executeRecipe(EXECUTE_RECIPE_JSON);
    expect(true, response.success);
    expect(DUMMY_RESPONSE_AFTER_EXECUTION, response.data);
  });
}
