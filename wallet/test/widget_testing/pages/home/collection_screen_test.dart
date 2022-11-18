import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:pylons_wallet/pages/home/collection_screen/collection_screen.dart';
import 'package:pylons_wallet/pages/home/collection_screen/collection_view_model.dart';
import 'package:pylons_wallet/services/third_party_services/thumbnail_helper.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/enums.dart';
import 'package:pylons_wallet/utils/svg_util.dart';


import '../../../mocks/mock_constants.dart';
import '../../../mocks/mock_wallet_store.dart';
import '../../extension/size_extension.dart';
import 'collection_screen_test.mocks.dart';

@GenerateMocks([CollectionViewModel,ThumbnailHelper])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late WalletsStore walletStore;
  walletStore = MockWalletStore();
  GetIt.I.registerLazySingleton<WalletsStore>(() => walletStore);
  late ThumbnailHelper thumbnailHelper;
  thumbnailHelper = MockThumbnailHelper();
  GetIt.I.registerLazySingleton<ThumbnailHelper>(() => thumbnailHelper);
  final CollectionViewModel collectionViewModel = MockCollectionViewModel();
  GetIt.I.registerLazySingleton<CollectionViewModel>(() => collectionViewModel);
  registerStubs(collectionViewModel);

  group("Collection Screen Tab Test", () {
    testWidgets("Creation tab is visible and active", (widgetTester) async {
      await widgetTester.testAppForWidgetTesting(
        Material(child: ChangeNotifierProvider.value(
          value: GetIt.I.get<CollectionViewModel>(),
          builder: (context,widget) {
            return const CreationsCollection();
          }
        )),
      );
      final collectionTab = find.byKey(const Key(kCreationTabButtonKey));
      expect(collectionTab, findsOneWidget);
      final collectionTabGridView = find.byKey(const Key(kCreationTabGridViewKey));
      expect(collectionTabGridView, findsOneWidget);
    });

    testWidgets("Purchases tab is visible and not active", (widgetTester) async {
      await widgetTester.testAppForWidgetTesting(
        Material(child: ChangeNotifierProvider.value(
            value: GetIt.I.get<CollectionViewModel>(),
            builder: (context,widget) {
              return const PurchasesCollection();
            }
        )),
      );
      final purchasesTab = find.byKey(const Key(kPurchasesTabButtonKey));
      expect(purchasesTab, findsOneWidget);
      final purchasesTabGridView = find.byKey(const Key(kPurchasesTabGridViewKey));
      expect(purchasesTabGridView, findsNothing);
    });

    testWidgets("Favorites tab is visible and not active", (widgetTester) async {
      await widgetTester.testAppForWidgetTesting(
        Material(child: ChangeNotifierProvider.value(
            value: GetIt.I.get<CollectionViewModel>(),
            builder: (context,widget) {
              return const FavoritesCollection();
            }
        )),
      );
      final favoritesTab = find.byKey(const Key(kFavoritesTabButtonKey));
      expect(favoritesTab, findsOneWidget);
      final favoritesTabGridView = find.byKey(const Key(kFavoritesTabGridViewKey));
      expect(favoritesTabGridView,findsNothing);
    });
  });

}
void registerStubs(CollectionViewModel viewModel) {

  when(viewModel.collectionsType).thenAnswer((newValue)=>CollectionsType.creations);
  when(viewModel.getNFTIcon(AssetType.Image)).thenAnswer((newValue)=>SVGUtil.kSvgNftFormatImage);

  when(viewModel.creations).thenAnswer((newValue)=>[MOCK_NFT_FREE_IMAGE]);
  when(viewModel.purchases).thenAnswer((newValue)=>[MOCK_NFT_FREE_IMAGE]);
  when(viewModel.favorites).thenAnswer((newValue)=>[MOCK_NFT_FREE_IMAGE]);

}
