import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:pylons_wallet/model/nft.dart';
import 'package:pylons_wallet/pages/purchase_item/purchase_item_screen.dart';
import 'package:pylons_wallet/pages/purchase_item/purchase_item_view_model.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:pylons_wallet/utils/constants.dart';

import '../../../mocks/mock_audio_player.dart';
import '../../../mocks/mock_constants.dart';
import '../../../mocks/mock_share_helper.dart';
import '../../../mocks/mock_video_player.dart';
import '../../../mocks/mock_wallet_store.dart';
import '../../../unit_testing/pages/purchase_item/purchase_item_view_model_test.mocks.dart';
import '../../extension/size_extension.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final WalletsStore walletStore = MockWalletStore();
  final audioPlayerMock = MockAudioPlayerImpl();
  final videoPlayerMock = MockVideoPlayerImpl();
  final repository = MockRepository();
  final shareHelper = MockShareHelperImpl();
  final mockAccountPublicInfo = MockAccountPublicInfo();
  final PurchaseItemViewModel viewModel = PurchaseItemViewModel(
    walletStore,
    audioPlayerHelper: audioPlayerMock,
    videoPlayerHelper: videoPlayerMock,
    repository: repository,
    shareHelper: shareHelper,
    accountPublicInfo: mockAccountPublicInfo,
  );
  GetIt.I.registerLazySingleton<WalletsStore>(() => walletStore);
  GetIt.I.registerLazySingleton<PurchaseItemViewModel>(() => viewModel);

  testWidgets("Purchase Item Screen Bottom Sheet Visibility Test", (tester) async {
    registerStub(
      repository: repository,
      mockAccountPublicInfo: mockAccountPublicInfo,
      nft: viewModel.nft,
    );
    viewModel.collapsed = false;
    await tester.testAppForWidgetTesting(
      ChangeNotifierProvider<PurchaseItemViewModel>.value(
        value: viewModel,
        child: PurchaseItemScreen(
          nft: viewModel.nft,
        ),
      ),
    );
    await tester.pump();
    final bottomSheet = find.byKey(const Key(kPurchaseItemBottomSheetKey));
    expect(bottomSheet, findsOneWidget);
    final closeBottomSheetButton = find.byKey(const Key(kCloseBottomSheetKey));
    expect(closeBottomSheetButton, findsOneWidget);
    await tester.tap(closeBottomSheetButton);
    await tester.pump();
    final bottomSheet1 = find.byKey(const Key(kPurchaseItemBottomSheetKey));
    expect(bottomSheet1, findsNothing);
  });

  testWidgets("In Purchase item screen history tab should be visible even if there is no history", (tester) async {
    registerStub(
      repository: repository,
      mockAccountPublicInfo: mockAccountPublicInfo,
      nft: MOCK_NFT_TYPE_RECIPE,
    );
    viewModel.collapsed = false;
    viewModel.setNFT(MOCK_NFT_TYPE_RECIPE);
    await tester.testAppForWidgetTesting(
      ChangeNotifierProvider<PurchaseItemViewModel>.value(
        value: viewModel,
        child: PurchaseItemScreen(
          nft: viewModel.nft,
        ),
      ),
    );
    await tester.pump();
    expect(viewModel.nftOwnershipHistoryList.length, 0);
    final historyTab = find.byKey(const Key(kHistoryTabPurchaseItemScreenKey));
    expect(historyTab, findsOneWidget);
  });
}

void registerStub(
    {required MockRepository repository, required MockAccountPublicInfo mockAccountPublicInfo, required NFT nft}) {
  when(repository.logPurchaseItem(
    recipeId: nft.recipeID,
    recipeName: nft.name,
    author: nft.creator,
    purchasePrice: double.parse(nft.price) / kBigIntBase,
  )).thenAnswer((realInvocation) => Future.value(const Right(false)));
  when(repository.logUserJourney(screenName: 'PurchaseViewScreen'))
      .thenAnswer((realInvocation) => Future.value(const Right(null)));
  when(mockAccountPublicInfo.publicAddress).thenAnswer((realInvocation) => "");
  when(repository.getLikesCount(recipeId: nft.recipeID, cookBookID: nft.cookbookID))
      .thenAnswer((realInvocation) => Future.value(const Right(0)));
  when(repository.ifLikedByMe(recipeId: nft.recipeID, cookBookID: nft.cookbookID, walletAddress: ''))
      .thenAnswer((realInvocation) => Future.value(const Right(false)));
  when(repository.countAView(recipeId: nft.recipeID, cookBookID: nft.cookbookID, walletAddress: ''))
      .thenAnswer((realInvocation) => Future.value(const Right(null)));
  when(repository.getViewsCount(
    recipeId: nft.recipeID,
    cookBookID: nft.cookbookID,
  )).thenAnswer((realInvocation) => Future.value(const Right(0)));
  when(repository.getNftOwnershipHistoryByCookbookIdAndRecipeId(
    recipeId: nft.recipeID,
    cookBookId: nft.cookbookID,
  )).thenAnswer((realInvocation) => Future.value(const Right([])));
}
