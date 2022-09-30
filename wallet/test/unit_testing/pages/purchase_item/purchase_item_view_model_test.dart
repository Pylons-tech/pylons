import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobx/mobx.dart' show Observable;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pylons_wallet/model/amount.dart';
import 'package:pylons_wallet/model/balance.dart';
import 'package:pylons_wallet/model/nft.dart';
import 'package:pylons_wallet/pages/home/currency_screen/model/ibc_coins.dart';
import 'package:pylons_wallet/pages/purchase_item/purchase_item_view_model.dart';
import 'package:pylons_wallet/services/repository/repository.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:transaction_signing_gateway/transaction_signing_gateway.dart';

import '../../../mocks/mock_audio_player.dart';
import '../../../mocks/mock_share_helper.dart';
import '../../../mocks/mock_video_player.dart';
import 'purchase_item_view_model_test.mocks.dart';

@GenerateMocks([WalletsStore, AccountPublicInfo, Repository, NFT])
void main() {
  late PurchaseItemViewModel purchaseItemViewModel;
  late Repository repository;

  setUp(() {
    final audioPlayerMock = MockAudioPlayerImpl();
    final videoPlayerMock = MockVideoPlayerimpl();
    repository = MockRepository();
    final mockWalletStore = MockWalletsStore();
    final shareHelper = MockShareHelperImpl();
    final mockAccountPublicInfo = MockAccountPublicInfo();
    purchaseItemViewModel = PurchaseItemViewModel(
      mockWalletStore,
      audioPlayerHelper: audioPlayerMock,
      videoPlayerHelper: videoPlayerMock,
      repository: repository,
      shareHelper: shareHelper,
    );

    when(mockWalletStore.getWallets()).thenAnswer((realInvocation) => Observable([mockAccountPublicInfo]));
    when(mockAccountPublicInfo.publicAddress).thenAnswer((realInvocation) => kAddress);
  });

  group('when the user has empty balance', () {
    late Either<String, bool> result;
    setUp(() async {
      when(repository.getBalance(kAddress)).thenAnswer((realInvocation) async => const Right([]));

      result = await purchaseItemViewModel.shouldShowSwipeToBuy(
        selectedDenom: IBCCoins.ustripeusd.name,
        requiredAmount: 0,
      );
    });

    test('then return false ', () {
      result.fold((l) => null, (r) => expect(r, false));
    });
  });

  group('when the user has empty stripe balance', () {
    late Either<String, bool> result;

    setUp(() async {
      when(repository.getBalance(kAddress)).thenAnswer(
        (realInvocation) async => Right([
          Balance(
            denom: IBCCoins.ustripeusd.name,
            amount: Amount.fromInt(20),
          )
        ]),
      );
      result = await purchaseItemViewModel.shouldShowSwipeToBuy(
        selectedDenom: IBCCoins.ustripeusd.name,
        requiredAmount: 0,
      );
    });

    test('then return true ', () {
      expect(result.isRight(), true);
      result.fold((l) => null, (r) => expect(r, true));
    });
  });

  group('when the user needs to pay in pylons ', () {
    group('and user pylons balance is zero', () {
      setUp(() {
        when(repository.getBalance(kAddress)).thenAnswer(
          (realInvocation) async => Right([
            Balance(
              denom: IBCCoins.upylon.name,
              amount: Amount.fromInt(0),
            )
          ]),
        );
      });

      test('then shouldShowSwipeToBuy should return false ', () async {
        final Either<String, bool> result = await purchaseItemViewModel.shouldShowSwipeToBuy(
          selectedDenom: IBCCoins.upylon.name,
          requiredAmount: 10,
        );
        expect(result.isRight(), true);
        result.fold((l) => null, (r) => expect(r, false));
      });

      test('then shouldShowSwipeToBuy should return true if free nft ', () async {
        final Either<String, bool> result = await purchaseItemViewModel.shouldShowSwipeToBuy(
          selectedDenom: IBCCoins.upylon.name,
          requiredAmount: 0,
        );
        expect(result.isRight(), true);
        result.fold((l) => null, (r) => expect(r, true));
      });
    });

    group('and user pylons balance is greater than needed', () {
      late Either<String, bool> result;

      setUp(() async {
        when(repository.getBalance(kAddress)).thenAnswer(
          (realInvocation) async => Right([
            Balance(
              denom: IBCCoins.upylon.name,
              amount: Amount.fromInt(20 * kBigIntBase),
            )
          ]),
        );
        result = await purchaseItemViewModel.shouldShowSwipeToBuy(
          selectedDenom: IBCCoins.upylon.name,
          requiredAmount: 10,
        );
      });

      test('then return true', () {
        expect(result.isRight(), true);
        result.fold((l) => null, (r) => expect(r, true));
      });
    });

    group('showBuyNowButton', () {
      late NFT nft;

      setUp(() {
        nft = MockNFT();
        when(nft.recipeID).thenAnswer((realInvocation) => kRecipeID);
        when(nft.name).thenAnswer((realInvocation) => kNftName);
        when(nft.creator).thenAnswer((realInvocation) => "");
      });

      group('when item is already sold out ', () {
        setUp(() {
          when(nft.amountMinted).thenAnswer((realInvocation) => 5);
          when(nft.quantity).thenAnswer((realInvocation) => 5);
          when(nft.price).thenAnswer((realInvocation) => "0");
          when(
            repository.logPurchaseItem(recipeId: kRecipeID, recipeName: kNftName, author: "", purchasePrice: 0),
          ).thenAnswer((realInvocation) async => const Right(true));
          purchaseItemViewModel.setNFT(nft);
        });

        test('then the user will not be able to buy it ', () {
          expect(purchaseItemViewModel.showBuyNowButton(isPlatformAndroid: true), false);
        });
      });

      group('when item is a free drop ', () {
        setUp(() {
          when(nft.amountMinted).thenAnswer((realInvocation) => 4);
          when(nft.quantity).thenAnswer((realInvocation) => 5);
          when(nft.price).thenAnswer((realInvocation) => "0");
          when(
            repository.logPurchaseItem(recipeId: kRecipeID, recipeName: kNftName, author: "", purchasePrice: 0),
          ).thenAnswer((realInvocation) async => const Right(true));
          purchaseItemViewModel.setNFT(nft);
        });

        test('then the user will be able to buy it ', () {
          expect(purchaseItemViewModel.showBuyNowButton(isPlatformAndroid: true), true);
        });
      });

      group('when item is a available in currency other than stripe usd ', () {
        setUp(() {
          when(nft.amountMinted).thenAnswer((realInvocation) => 4);
          when(nft.quantity).thenAnswer((realInvocation) => 5);
          when(nft.price).thenAnswer((realInvocation) => "5");
          when(nft.ibcCoins).thenAnswer((realInvocation) => IBCCoins.upylon);
          when(
            repository.logPurchaseItem(recipeId: kRecipeID, recipeName: kNftName, author: "", purchasePrice: 5 / kBigIntBase),
          ).thenAnswer((realInvocation) async => const Right(true));
          purchaseItemViewModel.setNFT(nft);
        });

        test('then the user will be able to buy it ', () {
          expect(purchaseItemViewModel.showBuyNowButton(isPlatformAndroid: true), true);
        });
      });

      group('when item is a available in stripe usd ', () {
        setUp(() {
          when(nft.amountMinted).thenAnswer((realInvocation) => 4);
          when(nft.quantity).thenAnswer((realInvocation) => 5);
          when(nft.price).thenAnswer((realInvocation) => "5");
          when(nft.ibcCoins).thenAnswer((realInvocation) => IBCCoins.ustripeusd);
          when(nft.iosStripePaymentAllowed).thenAnswer((realInvocation) => false);
          when(
            repository.logPurchaseItem(recipeId: kRecipeID, recipeName: kNftName, author: "", purchasePrice: 5 / kBigIntBase),
          ).thenAnswer((realInvocation) async => const Right(true));
          purchaseItemViewModel.setNFT(nft);
        });

        test('then the user will be able to buy it if its android', () {
          expect(purchaseItemViewModel.showBuyNowButton(isPlatformAndroid: true), true);
        });

        test('then the user will not be able to buy it if its ios', () {
          expect(purchaseItemViewModel.showBuyNowButton(isPlatformAndroid: false), false);
        });
      });
    });
  });

  group('isIOSStripePaymentAllowed', () {
    setUp(() {});

    group('when user is on android ', () {
      test('then it returns true', () {
        expect(purchaseItemViewModel.isIOSStripePaymentAllowed(isPlatformAndroid: true), true);
      });
    });

    group('when user is on ios ', () {
      late NFT nft;
      setUp(() {
        nft = MockNFT();
        when(nft.amountMinted).thenAnswer((realInvocation) => 4);
        when(nft.quantity).thenAnswer((realInvocation) => 5);
        when(nft.price).thenAnswer((realInvocation) => "5");
        when(nft.ibcCoins).thenAnswer((realInvocation) => IBCCoins.ustripeusd);
        when(nft.name).thenAnswer((realInvocation) => kNftName);
        when(nft.creator).thenAnswer((realInvocation) => "");
        when(nft.recipeID).thenAnswer((realInvocation) => kRecipeID);
        when(
          repository.logPurchaseItem(recipeId: kRecipeID, recipeName: kNftName, author: "", purchasePrice: 5 / kBigIntBase),
        ).thenAnswer((realInvocation) async => const Right(true));
        purchaseItemViewModel.setNFT(nft);
      });

      test('then it returns true if iosStripePaymentAllowed is allowed', () {
        when(nft.iosStripePaymentAllowed).thenAnswer((realInvocation) => true);

        expect(purchaseItemViewModel.isIOSStripePaymentAllowed(isPlatformAndroid: false), true);
      });

      test('then it returns false if iosStripePaymentAllowed is not allowed', () {
        when(nft.iosStripePaymentAllowed).thenAnswer((realInvocation) => false);

        expect(purchaseItemViewModel.isIOSStripePaymentAllowed(isPlatformAndroid: false), false);
      });
    });
  });
}
