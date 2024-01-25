import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pylons_wallet/ipc/ipc_engine.dart';
import 'package:pylons_wallet/model/nft.dart';
import 'package:pylons_wallet/pages/home/currency_screen/model/ibc_coins.dart';
import 'package:pylons_wallet/utils/types.dart';
import 'package:transaction_signing_gateway/transaction_signing_gateway.dart';

import '../../mocks/main_mock.mocks.dart';

void main() {
  group("$IPCEngine", () {
    late IPCEngine ipcEngine;
    late MockRepository mockRepository;
    late MockAccountProvider mockAccountProvider;

    setUp(() {
      mockAccountProvider = MockAccountProvider();
      mockRepository = MockRepository();
      final walletStore = MockWalletsStore();

      ipcEngine = IPCEngine(
        accountProvider: mockAccountProvider,
        repository: mockRepository,
        walletsStore: walletStore,
        onLogError:(exception, {bool? fatal, stack}){

        },
        onLogEvent: (AnalyticsEventEnum event) {},
      );

      when(mockAccountProvider.accountPublicInfo).thenAnswer((realInvocation) => const AccountPublicInfo(
            name: "",
            publicAddress: "",
            accountId: "",
            chainId: "",
          ));
    });

    group("when the owner is the same as the owner in the nft", () {
      test("should show owner view", () {
        ipcEngine.handleEaselLink(
          link: "",
          showCreateAccountView: (value) => throw Exception("boom"),
          showOwnerView: (value) => expect(true, true),
          showPurchaseView: (value) => throw Exception("boom"),
          getNFtFromRecipe: ({required String cookbookId, required String recipeId}) async =>
              NFT(ibcCoins: IBCCoins.none),
        );
      });
    });

    group("when the owner is different than the owner of the NFT", () {
      group("and user login through import account", () {
        setUp(() {
          when(mockRepository.getUserAcceptPolicies()).thenAnswer((realInvocation) => const Right(false));
        });

        test("should show purchase view", () {
          ipcEngine.handleEaselLink(
            link: "some link",
            showCreateAccountView: (value) => throw Exception("boom"),
            showOwnerView: (value) => throw Exception("boom"),
            showPurchaseView: (value) => expect(true, true),
            getNFtFromRecipe: ({required String cookbookId, required String recipeId}) async =>
                NFT(ibcCoins: IBCCoins.none, ownerAddress: "someRandomAddress"),
          );
        });
      });

      group("and user login through normal onboarding account", () {
        test("should show purchase view", () {
          ipcEngine.handleEaselLink(
            link: "some link",
            showCreateAccountView: (value) => throw Exception("boom"),
            showOwnerView: (value) => throw Exception("boom"),
            showPurchaseView: (value) => expect(true, true),
            getNFtFromRecipe: ({required String cookbookId, required String recipeId}) async =>
                NFT(ibcCoins: IBCCoins.none, ownerAddress: "someRandomAddress"),
          );
        });
      });

      group("and there is no account", () {
        setUp(() {
          when(mockRepository.saveInviteeAddressFromDynamicLink(dynamicLink: anyNamed("dynamicLink")))
              .thenAnswer((realInvocation) async => const Right(true));

          when(mockAccountProvider.accountPublicInfo).thenAnswer((realInvocation) => null);
        });

        test("should show owner view", () {
          ipcEngine.handleEaselLink(
            link: "http://somelink?address=address",
            showCreateAccountView: (value) => expect(true, true),
            showOwnerView: (value) => throw Exception("boom"),
            showPurchaseView: (value) => throw Exception("boom"),
            getNFtFromRecipe: ({required String cookbookId, required String recipeId}) async =>
                NFT(ibcCoins: IBCCoins.none),
          );
        });
      });
    });

    group("checkAndUnWrapFirebaseLink", () {
      test("parse fallback chrome link", () async {
        final link = await ipcEngine.checkAndUnWrapFirebaseLink(
            "xyz.pylons.wallet://google/link?deep_link_id=https%3A%2F%2Fwallet.pylons.tech%2F%3Frecipe_id%3DEasel_Recipe_auto_recipe_2023_01_08_112058_779%26cookbook_id%3DEasel_CookBook_auto_cookbook_2022_05_02_204103_876%26address%3Dpylo10sgeshtw6ewaq8s0daqev80gm69jh7rt264t7r&lt=DDL_SHORT&lid=https%3A%2F%2Fpylons.page.link%2FcaJSy3tdVAq3LNGJ8&utm_medium=dynamic_link&utm_source=firebase");

        expect(link,
            "https://wallet.pylons.tech/?recipe_id=Easel_Recipe_auto_recipe_2023_01_08_112058_779&cookbook_id=Easel_CookBook_auto_cookbook_2022_05_02_204103_876&address=pylo10sgeshtw6ewaq8s0daqev80gm69jh7rt264t7r");
      });

      test("parse normal firebase link", () async {
        final link = await ipcEngine.checkAndUnWrapFirebaseLink(
            "https://wallet.pylons.tech/?recipe_id=Easel_Recipe_auto_recipe_2023_01_08_112058_779&cookbook_id=Easel_CookBook_auto_cookbook_2022_05_02_204103_876&address=pylo10sgeshtw6ewaq8s0daqev80gm69jh7rt264t7r");

        expect(link,
            "https://wallet.pylons.tech/?recipe_id=Easel_Recipe_auto_recipe_2023_01_08_112058_779&cookbook_id=Easel_CookBook_auto_cookbook_2022_05_02_204103_876&address=pylo10sgeshtw6ewaq8s0daqev80gm69jh7rt264t7r");
      });
    });
  });
}
