import 'package:easel_flutter/repository/repository.dart';
import 'package:easel_flutter/screens/creator_hub/creator_hub_view_model.dart';
import 'package:easel_flutter/screens/creator_hub/widgets/draft_list_tile.dart';
import 'package:easel_flutter/screens/creator_hub/widgets/viewmodel/draft_list_tile_viewmodel.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../extensions/size_extension.dart';
import '../mock/mock_repository.dart';
import '../mocks/list_tile.mocks.dart';
import '../mocks/mock_constants.dart';

void main() {
  final DraftListViewModel draftListViewModel = MockDraftListViewModel();
  GetIt.I.registerLazySingleton<Repository>(() => MockRepositoryImp());
  GetIt.I.registerLazySingleton(() => CreatorHubViewModel(GetIt.I.get<Repository>()));
  GetIt.I.registerLazySingleton<DraftListViewModel>(() => draftListViewModel);

  group(
    "Draft List Tile Test",
    () {
      testWidgets(
        "Testing Price Banner for NFT having price",
        (tester) async {
          await tester.setScreenSize();
          await tester.testAppForWidgetTesting(
            Scaffold(
              body: ChangeNotifierProvider(
                create: (ctx) => GetIt.I.get<CreatorHubViewModel>(),
                builder: (context, _) {
                  return DraftListTile(
                    nft: MOCK_PRICED_NFT,
                    viewModel: GetIt.I.get<CreatorHubViewModel>(),
                  );
                },
              ),
            ),
          );

          await tester.pump();
          final banner = find.byKey(const Key(kPriceBannerKey));
          expect(banner, findsOneWidget);
        },
      );

      testWidgets(
        "Testing Price Banner for free NFT",
        (tester) async {
          await tester.setScreenSize();
          await tester.testAppForWidgetTesting(
            Scaffold(
              body: ChangeNotifierProvider(
                create: (ctx) => GetIt.I.get<CreatorHubViewModel>(),
                builder: (context, _) {
                  return DraftListTile(
                    nft: MOCK_NFT,
                    viewModel: GetIt.I.get<CreatorHubViewModel>(),
                  );
                },
              ),
            ),
          );

          await tester.pump();
          final banner = find.byKey(const Key(kPriceBannerKey));
          expect(banner, findsNothing);
        },
      );

      testWidgets(
        "Testing bottom sheet showing",
        (tester) async {
          await tester.setScreenSize();
          await tester.testAppForWidgetTesting(
            Scaffold(
              body: ChangeNotifierProvider(
                create: (ctx) => GetIt.I.get<CreatorHubViewModel>(),
                builder: (context, _) {
                  return DraftListTile(
                    nft: MOCK_NFT,
                    viewModel: GetIt.I.get<CreatorHubViewModel>(),
                  );
                },
              ),
            ),
          );

          await tester.pump();
          final moreOptionButton = find.byKey(const Key(kNFTMoreOptionButtonKey));
          expect(moreOptionButton, findsOneWidget);
          await tester.tap(moreOptionButton);
          await tester.pump();
          final bottomSheet = find.byKey(const Key(kNFTMoreOptionBottomSheetKey));
          tester.ensureVisible(bottomSheet);
        },
      );
      testWidgets(
        "can user tap on whole draft tile",
        (tester) async {
          bool clicked = false;
          when(draftListViewModel.startPublishingFlowAgain(startPublishingFlowAgainPressed: () {
            clicked = true;
          })).thenAnswer((realInvocation) {});
          await tester.setScreenSize();
          await tester.testAppForWidgetTesting(
            Scaffold(
              body: ChangeNotifierProvider(
                create: (ctx) => GetIt.I.get<CreatorHubViewModel>(),
                builder: (context, _) {
                  return DraftListTile(
                    nft: MOCK_PRICED_NFT,
                    viewModel: GetIt.I.get<CreatorHubViewModel>(),
                  );
                },
              ),
            ),
          );

          await tester.pump();
          expect(clicked, false);
          final draftTile = find.byKey(const Key(kDraftTileKey));
          await tester.tap(draftTile);
          await tester.pump();
        },
      );
    },
  );
}
