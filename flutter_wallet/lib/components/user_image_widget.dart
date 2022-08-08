import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as svg;
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:pylons_wallet/components/user_image_widget_viewmodel.dart';
import 'package:pylons_wallet/main_prod.dart';
import 'package:pylons_wallet/pages/image_picker.dart';
import 'package:pylons_wallet/pages/settings/utils/user_info_provider.dart';
import 'package:pylons_wallet/services/repository/repository.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/image_util.dart';
import 'package:pylons_wallet/utils/svg_util.dart';

abstract class UserImageWidget extends StatelessWidget {
  const UserImageWidget({Key? key}) : super(key: key);

  @visibleForTesting
  ImageProvider getImage(ImageProvider defaultVal, String uriKey) {
    File? file;

    final imageEither = GetIt.I.get<Repository>().getImagePath(uriKey);

    if (imageEither.isLeft()) {
      return defaultVal;
    }

    final path = imageEither.getOrElse(() => '');

    if (path.isEmpty) {
      return defaultVal;
    }

    file = File.fromUri(Uri.parse(imageEither.getOrElse(() =>
        ''))); // todo? - does this work when the URI points to a network file?

    return FileImage(file);
  }

  @visibleForTesting
  static void setToFile(
      int filesizeLimit, String uriKey, File? file, BuildContext context) {
    final userBanner = GetIt.I.get<UserBannerViewModel>();
    userBanner.setToFile(filesizeLimit, uriKey, file, context);
  }
}

class UserAvatarWidget extends UserImageWidget {
  final double radius;
  @visibleForTesting
  static const filesizeLimit =
      1024 * 1024 * 4; // 4MB (this should always divide cleanly)
  @visibleForTesting
  static const resolutionLimitX = 2048;
  @visibleForTesting
  static const resolutionLimitY = 2048;
  @visibleForTesting
  static const uriKey = "pylons_avatar_file_uri";
  @visibleForTesting
  static svg.Svg defaultImage =
      svg.Svg(SVGUtil.USER_AVATAR); // todo: sensible default avatar

  const UserAvatarWidget({this.radius = 20});

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: Consumer<UserInfoProvider>(builder: (context, value, child) {
              return SizedBox(
                  height: radius * 2,
                  width: radius * 2,
                  child: Image(
                    image: getImage(defaultImage, uriKey),
                    fit: BoxFit.cover,
                  ));
            }),
          ),
        );
      },
    );
  }
}

class UserAvatarPickerWidget extends UserAvatarWidget {
  const UserAvatarPickerWidget();

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder:
        (BuildContext context, void Function(void Function()) setState) {
      return GestureDetector(
        onTap: () async {
          final userInfoProvider = context.read<UserInfoProvider>();
          final file = await pickImageFromGallery(
              UserAvatarWidget.resolutionLimitX.toDouble(),
              UserAvatarWidget.resolutionLimitY.toDouble(),
              kImageQuality,
              context);

          if (file == null) {
            return;
          }

          final newImagePathEither = await GetIt.I
              .get<Repository>()
              .saveImageInLocalDirectory(file.path);

          if (newImagePathEither.isLeft()) {
            return;
          }

          // ignore: use_build_context_synchronously
          UserImageWidget.setToFile(
              UserAvatarWidget.filesizeLimit,
              UserAvatarWidget.uriKey,
              File(newImagePathEither.getOrElse(() => '')),
              context);

          userInfoProvider.onImageChange();

          setState(() {});
        },
        child: SvgPicture.asset(
          SVGUtil.IMAGE_PICKER,
          height: 12.h,
          width: 12.w,
          fit: BoxFit.scaleDown,
        ),
      );
    });
  }
}

class UserBannerWidget extends UserImageWidget {
  final double height;
  @visibleForTesting
  static const filesizeLimit =
      1024 * 1024 * 4; // 4MB (this should always divide cleanly)
  @visibleForTesting
  static const resolutionLimitX = 2048;
  @visibleForTesting
  static const resolutionLimitY = 2048;
  @visibleForTesting
  static const uriKey = "pylons_banner_file_uri";
  @visibleForTesting
  static AssetImage defaultImage = AssetImage(ImageUtil.DEFAULT_BANNER);

  UserBannerWidget({this.height = 230});

  final userBannerViewModel = GetIt.I.get<UserBannerViewModel>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: userBannerViewModel,
        builder: (context, child) {
          return Consumer<UserBannerViewModel>(
              builder: (context, viewModel, child) {
            return Container(
              height: height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  alignment: FractionalOffset.center,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.2),
                    BlendMode.dstOver,
                  ),
                  image: getImage(
                    defaultImage,
                    uriKey,
                  ),
                ),
              ),
            );
          });
        });
  }
}

class UserBannerPickerWidget extends UserBannerWidget {
  UserBannerPickerWidget();

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder:
        (BuildContext context, void Function(void Function()) setState) {
      return GestureDetector(
        onTap: () async {
          final file = await pickImageFromGallery(
              UserBannerWidget.resolutionLimitX.toDouble(),
              UserBannerWidget.resolutionLimitY.toDouble(),
              kImageQuality,
              context);

          if (file == null) {
            return;
          }

          final newImagePathEither = await GetIt.I
              .get<Repository>()
              .saveImageInLocalDirectory(file.path);

          if (newImagePathEither.isLeft()) {
            return;
          }

          // ignore: use_build_context_synchronously
          UserImageWidget.setToFile(
              UserBannerWidget.filesizeLimit,
              UserBannerWidget.uriKey,
              File(newImagePathEither.getOrElse(() => '')),
              context);

          setState(() {});
        },
        behavior: HitTestBehavior.translucent,
        child: SvgPicture.asset(
          SVGUtil.BANNER_IMAGE_EDIT,
          height: isTablet ? 20.h : 15.h,
          width: isTablet ? 20.w : 15.w,
          fit: BoxFit.fill,
        ),
      );
    });
  }
}
