import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:pylons_wallet/components/user_image_widget_viewmodel.dart';
import 'package:pylons_wallet/ipc/ipc_engine.dart';
import 'package:pylons_wallet/pages/home/home.dart';
import 'package:pylons_wallet/pages/home/home_provider.dart';
import 'package:pylons_wallet/pages/settings/utils/user_info_provider.dart';
import 'package:pylons_wallet/services/repository/repository.dart';
import 'package:pylons_wallet/services/third_party_services/remote_config_service/remote_config_service.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:transaction_signing_gateway/model/account_public_info.dart';
import '../../../mocks/home_provider.mocks.dart';
import '../../../mocks/ipc_engine.mocks.dart';
import '../../../mocks/maintenance_mode_widgets_test.mocks.dart';
import '../../../mocks/wallet_store.mocks.dart';
import '../../../mocks/user_banner_view_model.mocks.dart';
import '../../../mocks/user_info_provider.mocks.dart';
import '../../extension/size_extension.dart';
import 'package:mockito/mockito.dart';
import '../../../mocks/mock_constants.dart';
import '../../../mocks/repository.mocks.dart';

void main() {
  final homeProvider = MockHomeProvider();
  final userBannerViewModel = MockUserBannerViewModel();
  final remoteConfigService = MockRemoteConfigService();
  final repository = MockRepository();
  final userInfoProvider = MockUserInfoProvider();
  final walletStore = MockWalletsStore();
  final ipcEngine = MockIPCEngine();
  setUpAll(() {
    GetIt.I.registerLazySingleton<HomeProvider>(() => homeProvider);
    GetIt.I.registerLazySingleton<RemoteConfigService>(() => remoteConfigService);
    GetIt.I.registerLazySingleton<UserBannerViewModel>(() => userBannerViewModel);
    GetIt.I.registerLazySingleton<Repository>(() => repository);
    GetIt.I.registerLazySingleton<WalletsStore>(() => walletStore);
    GetIt.I.registerLazySingleton<IPCEngine>(() => ipcEngine);
  });
  testWidgets('tapping on drawer icon should open drawer', (tester) async {
    when(homeProvider.isBannerDark()).thenAnswer((realInvocation) => false);
    when(homeProvider.selectedIndex).thenAnswer((realInvocation) => 1);
    when(homeProvider.items).thenAnswer((realInvocation) => []);
    when(remoteConfigService.getMaintenanceMode()).thenAnswer((realInvocation) => false);
    when(homeProvider.showBadge).thenAnswer((realInvocation) => false);
    when(repository.getImagePath(MOCK_PYLONS_BANNER)).thenAnswer((realInvocation) => const Right(MOCK_PYLONS_BANNER));
    when(repository.getImagePath(MOCK_PYLONS_AVATAR)).thenAnswer((realInvocation) => const Right(MOCK_PYLONS_AVATAR));
    when(homeProvider.tabs).thenAnswer((realInvocation) => MOCK_TABS);
    when(walletStore.getInitialLink()).thenAnswer((realInvocation) => Right(MOCK_URL));
    when(ipcEngine.handleLinksBasedOnUri(MOCK_URL)).thenAnswer((realInvocation) async {});
    when(homeProvider.accountPublicInfo).thenAnswer(
      (realInvocation) => const AccountPublicInfo(
        name: MOCK_NAME,
        publicAddress: MOCK_PUBLIC_ADDRESS,
        accountId: MOCK_ACCOUNT_ID,
        chainId: MOCK_CHAIN_ID,
      ),
    );
    await tester.runAsync(() async {
      await tester.testAppForWidgetTesting(
        ChangeNotifierProvider<UserInfoProvider>.value(
          value: userInfoProvider,
          builder: (context, child) {
            return const HomeScreen();
          },
        ),
      );
      await tester.pumpAndSettle(const Duration(seconds: 3));
      final drawerIcon = find.byKey(const Key(drawerIconKey));
      final drawer = find.byKey(const Key(drawerKey));
      expect(drawer, findsNothing);
      await tester.tap(drawerIcon);
      await tester.pumpAndSettle(const Duration(seconds: 1));
      expect(drawer, findsOneWidget);
    });
  });
}
