import 'package:easel_flutter/screens/creator_hub/creator_hub_view_model.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/widgets/publish_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import '../extensions/size_extensions.dart';
import '../mock/mock_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final repository = MockRepositoryImp();
  final creatorHubViewModel = CreatorHubViewModel(repository);
  GetIt.I.registerLazySingleton(() => creatorHubViewModel);

  group("publish button test case", () {
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

  });
}
