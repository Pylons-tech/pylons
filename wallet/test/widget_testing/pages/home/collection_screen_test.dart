import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:pylons_wallet/generated/locale_keys.g.dart';
import 'package:pylons_wallet/pages/home/collection_screen/collection_screen.dart';
import 'package:pylons_wallet/pages/home/collection_screen/collection_view_model.dart';
import 'package:pylons_wallet/pages/home/easel_section/no_easel_art_work.dart';
import 'package:pylons_wallet/services/third_party_services/thumbnail_helper.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/enums.dart';
import 'package:pylons_wallet/utils/svg_util.dart';

import '../../../mocks/mock_constants.dart';
import '../../../mocks/mock_wallet_store.dart';
import '../../extension/size_extension.dart';
import '../gesture_for_detail_screen_test.mocks.dart';
import 'collection_screen_test.mocks.dart';

@GenerateMocks([CollectionViewModel, ThumbnailHelper])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late WalletsStore walletStore;
  walletStore = MockWalletStore();
  GetIt.I.registerLazySingleton<WalletsStore>(() => walletStore);
  late ThumbnailHelper thumbnailHelper;
  thumbnailHelper = MockThumbnailHelper();
  GetIt.I.registerLazySingleton<ThumbnailHelper>(() => thumbnailHelper);
  final MockFavoritesChangeNotifier mockFavoritesChangeNotifier = MockFavoritesChangeNotifier();
  GetIt.I.registerLazySingleton<MockFavoritesChangeNotifier>(() => mockFavoritesChangeNotifier);
  final CollectionViewModel collectionViewModel = MockCollectionViewModel();
  GetIt.I.registerLazySingleton<CollectionViewModel>(() => collectionViewModel);
  registerStubs(collectionViewModel);

  group("Collection Screen Tab Test", () {
    testWidgets("Switching from Creation tab to Purchases tab", (widgetTester) async {
      when(collectionViewModel.collectionsType).thenAnswer((newValue) => CollectionsType.creations);
      await widgetTester.testAppForWidgetTesting(
        Material(
          child: Scaffold(
            body: ChangeNotifierProvider.value(
              value: collectionViewModel,
              builder: (context, widget) {
                return const CollectionScreen();
              },
            ),
          ),
        ),
      );

      final collectionTab = find.byKey(const Key(kCreationTabButtonKey));
      expect(collectionTab, findsOneWidget);
      expect(collectionViewModel.collectionsType, CollectionsType.creations);
      final collectionTabGridView = find.byKey(const Key(kCreationTabButtonKey));
      expect(collectionTabGridView, findsOneWidget);
      when(collectionViewModel.collectionsType).thenAnswer((newValue) {
        return CollectionsType.purchases;
      });
      final purchasesTab = find.byKey(const Key(kPurchasesTabButtonKey));
      widgetTester.ensureVisible(purchasesTab);
      await widgetTester.tap(purchasesTab);
      await widgetTester.pump();
      expect(collectionViewModel.collectionsType, CollectionsType.purchases);
    });

    testWidgets("Purchases tab is visible and not active", (widgetTester) async {
      when(collectionViewModel.collectionsType).thenAnswer((newValue) => CollectionsType.purchases);
      await widgetTester.testAppForWidgetTesting(
        Material(
          child: ChangeNotifierProvider.value(
            value: GetIt.I.get<CollectionViewModel>(),
            builder: (context, widget) {
              return const PurchasesCollection();
            },
          ),
        ),
      );
      final purchasesTab = find.byKey(const Key(kPurchasesTabButtonKey));
      expect(purchasesTab, findsOneWidget);
      final nftGridview = find.byKey(const Key(kCollectionGridViewKey));
      expect(nftGridview, findsOneWidget);
    });

  });

  testWidgets("Download Easel Button", (widgetTester) async {
    when(collectionViewModel.isInstalled).thenAnswer((realInvocation) => false);
    await widgetTester.testAppForWidgetTesting(
      Material(
        child: ChangeNotifierProvider.value(
          value: collectionViewModel,
          builder: (context, widget) {
            return const NoEaselArtWork();
          },
        ),
      ),
    );
    final button = find.text(LocaleKeys.download_easel);
    expect(button, findsOneWidget);
  });

  testWidgets("Open Easel Button", (widgetTester) async {
    when(collectionViewModel.isInstalled).thenAnswer((realInvocation) => true);
    await widgetTester.testAppForWidgetTesting(
      Material(
        child: ChangeNotifierProvider.value(
          value: collectionViewModel,
          builder: (context, widget) {
            return const NoEaselArtWork();
          },
        ),
      ),
    );
    final button = find.text(LocaleKeys.open_easel);
    expect(button, findsOneWidget);
  });
}

void registerStubs(CollectionViewModel viewModel) {
  when(viewModel.getNFTIcon(AssetType.Image)).thenAnswer((newValue) => SVGUtil.kSvgNftFormatImage);

  when(viewModel.creations).thenAnswer((newValue) => [MOCK_NFT_FREE_IMAGE]);
  when(viewModel.purchases).thenAnswer((newValue) => [MOCK_NFT_FREE_IMAGE]);
  when(viewModel.favoritesChangeNotifier).thenAnswer((newValue) => MockFavoritesChangeNotifier());
}
