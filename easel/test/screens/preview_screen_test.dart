import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/repository/repository.dart';
import 'package:easel_flutter/screens/preview_screen.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../extensions/size_extension.dart';
import '../mock/media_info.mocks.dart';
import '../mock/mock_audio_imp.dart';
import '../mock/mock_file_utils.dart';
import '../mock/mock_repository.dart';
import '../mock/mock_video_player.dart';

void main() {
  final repository = MockRepositoryImp();
  GetIt.I.registerLazySingleton<Repository>(() => repository);
  final easelProvider = EaselProvider(
    repository: repository,
    fileUtilsHelper: MockFileUtilsHelperImp(),
    audioPlayerHelperForFile: MockAudioPlayerHelperImp(),
    audioPlayerHelperForUrl: MockAudioPlayerHelperImp(),
    mediaInfo: MockMediaInfo(),
    videoPlayerHelper: MockVideoPlayerHelperImp(),
  );

  testWidgets("when showing image nft in full screen gridview should show", (widgetTester) async {
    await widgetTester.testAppForWidgetTesting(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: easelProvider,
          )
        ],
        builder: (context, widget) {
          return PreviewScreen(onMoveToNextScreen: () {});
        },
      ),
    );
    final imageFullScreenGridView = find.byKey(const Key(kImageFullScreenGridviewKey));
    expect(imageFullScreenGridView, findsOneWidget);
  });
}
