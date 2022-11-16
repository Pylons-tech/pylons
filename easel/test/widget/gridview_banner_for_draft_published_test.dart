import 'package:easel_flutter/main.dart';
import 'package:easel_flutter/repository/repository.dart';
import 'package:easel_flutter/screens/creator_hub/creator_hub_screen.dart';
import 'package:easel_flutter/screens/creator_hub/creator_hub_view_model.dart';
import 'package:easel_flutter/screens/creator_hub/widgets/nfts_grid_view.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../extensions/size_extension.dart';
import '../mock/mock_repository.dart';
import '../mocks/mock_constants.dart';

void main() {
  GetIt.I.registerLazySingleton<Repository>(() => MockRepositoryImp());
  GetIt.I.registerLazySingleton(() => CreatorHubViewModel(GetIt.I.get<Repository>()));

  group(
    "NFTs GridView Price Banner Test",
    () {
      testWidgets(
        "Testing Price Banner for NFT having price",
        (tester) async {
          await tester.setScreenSize();
          await tester.testAppForWidgetTesting(
            Scaffold(
              body: ChangeNotifierProvider.value(
                value: GetIt.I.get<CreatorHubViewModel>(),
                builder: (context, _) {
                  return BuildGridView(
                    nftsList: [MOCK_PRICED_NFT],
                    onEmptyList: (BuildContext context) {
                      return Text(
                        "no_nft_created".tr(),
                        style: TextStyle(fontWeight: FontWeight.w700, color: EaselAppTheme.kLightGrey, fontSize: isTablet ? 12.sp : 15.sp),
                      );
                    },
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
        "Testing Bottom Sheet Options For Published NFT",
            (tester) async {
          await tester.setScreenSize();
          await tester.testAppForWidgetTesting(
            Scaffold(
              body: ChangeNotifierProvider.value(
                value: GetIt.I.get<CreatorHubViewModel>(),
                builder: (context, _) {
                  return NftGridViewItem(
                    nft: MOCK_NFT,
                  );
                },
              ),
            ),
          );

          await tester.pump();
          final gridViewTile = find.byKey(const Key(kGridViewTileMoreOptionKey));
          final publishBottomSheetText = find.text(kPublishTextKey);
          await tester.ensureVisible(gridViewTile);
          expect(publishBottomSheetText,findsNothing);
          await tester.tap(gridViewTile);
          await tester.pump();
          expect(publishBottomSheetText, findsOneWidget);
        },
      );
    },
  );
}
