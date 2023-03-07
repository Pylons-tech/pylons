
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pylons_wallet/ipc/ipc_engine.dart';
import 'package:pylons_wallet/model/nft.dart';
import 'package:pylons_wallet/pages/home/currency_screen/model/ibc_coins.dart';
import 'package:pylons_wallet/providers/account_provider.dart';
import 'package:pylons_wallet/services/repository/repository.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:transaction_signing_gateway/transaction_signing_gateway.dart';

import 'ipc_test.mocks.dart';

@GenerateMocks([AccountProvider, Repository, WalletsStore])
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
  });
}