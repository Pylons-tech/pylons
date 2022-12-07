import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/repository/repository.dart';
import 'package:easel_flutter/screens/creator_hub/creator_hub_view_model.dart';
import 'package:easel_flutter/screens/publish_screen.dart';
import 'package:easel_flutter/screens/welcome_screen/widgets/viewModel/show_install_wallet_bottom_sheet_viewmodel.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/viewmodels/home_viewmodel.dart';
import 'package:easel_flutter/widgets/publish_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import '../extensions/size_extensions.dart';
import '../mock/easel_view_model.mocks.dart';
import '../mock/home_view_model.mocks.dart';
import '../mock/mock_constants.dart';
import '../mock/mock_repository.dart';
import '../mock/show_install_wallet_view_model.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final repository = MockRepositoryImp();
  final creatorHubViewModel = CreatorHubViewModel(repository);
  final viewModel = MockEaselProvider();
  final homeViewModel = MockHomeViewModel();
  final showInstallBottomViewModel = MockShowInstallBottomSheetViewModel();

  setUpAll(() {
    GetIt.I.registerLazySingleton(() => creatorHubViewModel);
    GetIt.I.registerLazySingleton<Repository>(() => repository);
    GetIt.I.registerLazySingleton<EaselProvider>(() => viewModel);
    GetIt.I.registerLazySingleton<HomeViewModel>(() => homeViewModel);
    GetIt.I.registerLazySingleton<ShowInstallBottomSheetViewModel>(() => showInstallBottomViewModel);
  });

  group(
    "publish button test case",
    () {
      testWidgets("publish button on tap", (tester) async {
        await tester.setScreenSize();

        await tester.testAppForWidgetTesting(
          Builder(
            builder: (context) {
              ScreenUtil.init(context);
              return Material(
                child: PublishButton(
                  onPress: () {
                    GetIt.I.get<CreatorHubViewModel>().changeSelectedCollection(CollectionType.published);
                  },
                ),
              );
            },
          ),
        );

        final publishButtonKey = find.byKey(const Key(kPublishButtonKey));
        expect(creatorHubViewModel.selectedCollectionType, CollectionType.draft);
        await tester.ensureVisible(publishButtonKey);
        await tester.tap(publishButtonKey);
        await tester.pump();
        expect(creatorHubViewModel.selectedCollectionType, CollectionType.published);
      });

      testWidgets(
        "show bottom sheet when wallet not installed",
        (tester) async {
          when(viewModel.nft).thenAnswer((realInvocation) => MOCK_NFT);
          when(viewModel.collapsed).thenAnswer((realInvocation) => false);
          when(viewModel.supportedDenomList).thenAnswer((realInvocation) => []);
          when(viewModel.selectedDenom).thenAnswer((realInvocation) => MOCK_DENOM);
          when(viewModel.isWalletInstalled()).thenAnswer((realInvocation) async {
            return false;
          });
          await tester.testAppForWidgetTesting(
            ChangeNotifierProvider<EaselProvider>.value(
              value: viewModel,
              builder: (context, child) {
                return const Material(
                  child: PublishScreen(),
                );
              },
            ),
          );
          await tester.pump();
          final button = find.byType(PublishButton);
          await tester.tap(button);
          final bottomSheet = find.byKey(const Key(kShowInstallWalletBottomSheetKey));
          await tester.pump();
          expect(bottomSheet, findsOneWidget);
        },
      );

      testWidgets(
        "not show bottom sheet when wallet installed",
        (tester) async {
          when(viewModel.nft).thenAnswer((realInvocation) => MOCK_NFT);
          when(viewModel.collapsed).thenAnswer((realInvocation) => false);
          when(viewModel.supportedDenomList).thenAnswer((realInvocation) => []);
          when(viewModel.selectedDenom).thenAnswer((realInvocation) => MOCK_DENOM);
          when(viewModel.isWalletInstalled()).thenAnswer((realInvocation) async {
            return true;
          });
          when(viewModel.verifyPylonsAndMint(nft: MOCK_NFT)).thenAnswer((realInvocation) async {
            return true;
          });
          await tester.testAppForWidgetTesting(
            ChangeNotifierProvider<EaselProvider>.value(
              value: viewModel,
              builder: (context, child) {
                return const Material(
                  child: PublishScreen(),
                );
              },
            ),
          );
          await tester.pump();
          final button = find.byType(PublishButton);
          await tester.tap(button);
          final bottomSheet = find.byKey(const Key(kShowInstallWalletBottomSheetKey));
          await tester.pump();
          expect(bottomSheet, findsNothing);
        },
      );
    },
  );
}
