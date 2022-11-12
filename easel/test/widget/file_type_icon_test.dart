import 'package:easel_flutter/screens/creator_hub/creator_hub_view_model.dart';
import 'package:easel_flutter/screens/creator_hub/widgets/nfts_grid_view.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../extensions/size_extension.dart';
import '../mock/mock_constants.dart';
import '../mock/mock_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final repository = MockRepositoryImp();
  GetIt.I.registerLazySingleton(() => CreatorHubViewModel(repository));

  group("Test NFT File Type Icons", () {
    testWidgets(
      "Image Type NFT Icon Test",
          (widgetTester) async {
        await widgetTester.testAppForWidgetTesting(
          Scaffold(
            body: ChangeNotifierProvider.value(
              value: GetIt.I.get<CreatorHubViewModel>(),
              builder: (context, widget) {
                return NftGridViewItem(
                  nft: MOCK_NFT,
                );
              },
            ),
          ),
        );

        final fileTypeIcon = find.byKey(const Key(kNFTTypeImageIconKey));
        expect(fileTypeIcon, findsOneWidget);
      },
    );

    testWidgets(
      "Video Type NFT Icon Test",
          (widgetTester) async {
        await widgetTester.testAppForWidgetTesting(
          Scaffold(
            body: ChangeNotifierProvider.value(
              value: GetIt.I.get<CreatorHubViewModel>(),
              builder: (context, widget) {
                return NftGridViewItem(
                  nft: MOCK_PRICED_Video_NFT,
                );
              },
            ),
          ),
        );

        final fileTypeIcon = find.byKey(const Key(kNFTTypeVideoIconKey));
        expect(fileTypeIcon, findsOneWidget);
      },
    );

    testWidgets(
      "Audio Type NFT Icon Test",
          (widgetTester) async {
        await widgetTester.testAppForWidgetTesting(
          Scaffold(
            body: ChangeNotifierProvider.value(
              value: GetIt.I.get<CreatorHubViewModel>(),
              builder: (context, widget) {
                return NftGridViewItem(
                  nft: MOCK_PRICED_AUDIO_NFT,
                );
              },
            ),
          ),
        );

        final fileTypeIcon = find.byKey(const Key(kNFTTypeAudioIconKey));
        expect(fileTypeIcon, findsOneWidget);
      },
    );

    testWidgets(
      "PDF Type NFT Icon Test",
          (widgetTester) async {
        await widgetTester.testAppForWidgetTesting(
          Scaffold(
            body: ChangeNotifierProvider.value(
              value: GetIt.I.get<CreatorHubViewModel>(),
              builder: (context, widget) {
                return NftGridViewItem(
                  nft: MOCK_PRICED_PDF_NFT,
                );
              },
            ),
          ),
        );

        final fileTypeIcon = find.byKey(const Key(kNFTTypePdfIconKey));
        expect(fileTypeIcon, findsOneWidget);
      },
    );

    testWidgets(
      "3D Model Type NFT Icon Test",
          (widgetTester) async {
        await widgetTester.testAppForWidgetTesting(
          Scaffold(
            body: ChangeNotifierProvider.value(
              value: GetIt.I.get<CreatorHubViewModel>(),
              builder: (context, widget) {
                return NftGridViewItem(
                  nft: MOCK_PRICED_3D_NFT,
                );
              },
            ),
          ),
        );

        final fileTypeIcon = find.byKey(const Key(kNFTType3dModelIconKey));
        expect(fileTypeIcon, findsOneWidget);
      },
    );
  });
}