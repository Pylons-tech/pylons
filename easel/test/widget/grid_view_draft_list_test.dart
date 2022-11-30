import 'package:easel_flutter/repository/repository.dart';
import 'package:easel_flutter/screens/creator_hub/creator_hub_view_model.dart';
import 'package:easel_flutter/screens/creator_hub/widgets/nfts_grid_view.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../extensions/size_extension.dart';
import '../mock/creator_hub_viewmodel.mocks.dart';
import '../mock/mock_constants.dart';
import '../mock/mock_repository.dart';

void main() {
  final viewModel = MockCreatorHubViewModel();
  GetIt.I.registerLazySingleton<Repository>(() => MockRepositoryImp());
  GetIt.I.registerLazySingleton<CreatorHubViewModel>(() => viewModel);
  testWidgets(
    "testing bottom bar on NFT click",
    (tester) async {
      bool clicked = false;
      when(viewModel.selectedCollectionType).thenAnswer((realInvocation) => CollectionType.draft);
      when(viewModel.startPublishingFlowAgain(startPublishingFlowAgainPressed: anyNamed("startPublishingFlowAgainPressed"))).thenAnswer((realInvocation) {
        clicked = true;
      });
      await tester.setScreenSize();
      await tester.testAppForWidgetTesting(
        Scaffold(
          body: ChangeNotifierProvider(
            create: (ctx) => GetIt.I.get<CreatorHubViewModel>(),
            builder: (context, _) {
              return NftGridViewItem(
                nft: MOCK_NFT,
              );
            },
          ),
        ),
      );

      await tester.pump();
      final gridViewTile = find.byKey(const Key(kGridViewTileNFTKey));
      await tester.ensureVisible(gridViewTile);
      await tester.tap(gridViewTile);
      await tester.pump();
      expect(clicked, true);
    },
  );
}
