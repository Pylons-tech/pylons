import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobx/mobx.dart' show Observable;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pylons_wallet/model/amount.dart';
import 'package:pylons_wallet/model/balance.dart';
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

@GenerateMocks([WalletsStore, AccountPublicInfo, Repository])
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
  });
}
