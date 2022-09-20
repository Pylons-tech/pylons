import 'package:easel_flutter/repository/repository.dart';
import 'package:easel_flutter/screens/creator_hub/creator_hub_view_model.dart';
import 'package:easel_flutter/screens/creator_hub/widgets/nfts_grid_view.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../extensions/size_extension.dart';
import '../mocks/mock_constants.dart';

void main() {
  GetIt.I.registerLazySingleton<Repository>(() => MockRepositoryImp());
  GetIt.I.registerLazySingleton(() => CreatorHubViewModel(GetIt.I.get<Repository>()));
  testWidgets(
    "testing bottom bar on NFT click",
    (tester) async {
      await tester.setScreenSize();
      await tester.testAppForWidgetTesting(
        Scaffold(
          body: ChangeNotifierProvider(
              create: (ctx) => GetIt.I.get<CreatorHubViewModel>(),
              builder: (context, _) {
                return NftGridViewItem(
                  nft: MOCK_NFT,
                );
              }),
        ),
      );

      await tester.pump();
      final gridViewTile = find.byKey(const Key(kGridViewTileNFTKey));
      final draftBottomSheetText = find.text(kPublishTextKey);
      await tester.ensureVisible(gridViewTile);
      expect(draftBottomSheetText, findsNothing);
      await tester.tap(gridViewTile);
      await tester.pump();
      expect(draftBottomSheetText, findsOneWidget);
    },
  );
}
