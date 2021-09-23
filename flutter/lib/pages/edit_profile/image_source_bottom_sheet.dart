import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pylons_wallet/components/space_widgets.dart';
import 'package:pylons_wallet/constants/constants.dart';
import 'package:pylons_wallet/utils/screen_size_utils.dart';
import 'package:image_cropper/image_cropper.dart';

class ImageSourceBottomSheet extends StatelessWidget {
  ImageSourceBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Wrap(
      children: [
        Column(
          children: [
            const VerticalSpace(40),
            _MenuButtonWidget(
              title: "Take Photo",
              onTap: ()async{
                var file = await _pickImageFromCamera();
              },
            ),
            const Divider(),
            _MenuButtonWidget(
              title: "Choose from ${Platform.isAndroid ? "Gallery" : "Photos"}",
              onTap: ()async{
                var file = await _pickImageFromGallery();
              },
            ),
            const Divider(),
            _MenuButtonWidget(
              title: "Choose from NFT Collection",
              onTap: (){},
            ),
            const Divider(),
            _MenuButtonWidget(
              title: "Remove Profile Photo",
              onTap: (){},
              textColor: const Color(0xffE53C3C),
            ),
            const VerticalSpace(30),
          ],
        ),
      ],
    );
  }


  Future<File?> _pickImageFromCamera() async {
    try {
      final _picker = ImagePicker();
      var _image = await _picker.pickImage(source: ImageSource.camera,
          imageQuality: 85,
          maxHeight: 500,
          maxWidth: 500);

      if (_image != null) {
        return _cropImage(_image.path);

      }

    }catch(e){
      debugPrint("$e");
    }
    return null;
  }

  Future<File?> _pickImageFromGallery() async {
    try{
      final _picker = ImagePicker();
      var _image = await  _picker.pickImage(source: ImageSource.gallery,
        imageQuality: 85, maxHeight: 500, maxWidth: 500,
      );
      if(_image != null){
        return  _cropImage(_image.path);
      }
    }catch(e){
      // showMessage(e.toString());
      debugPrint("$e");
    }

    return null;
  }


  Future<File?> _cropImage(String path)async{
     return  ImageCropper.cropImage(
        sourcePath: path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: const AndroidUiSettings(
            toolbarTitle: 'Pylons',
            toolbarColor: kBlue,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        )
    );
  }

}

class _MenuButtonWidget extends StatelessWidget {
  const _MenuButtonWidget({
    Key? key,
    required this.title,
    required this.onTap,
    this.textColor = Colors.black
  }) : super(key: key);

  final String title;
  final VoidCallback onTap;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
   final ScreenSizeUtil screenSize = ScreenSizeUtil(context);
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: screenSize.width(),
        height: 40,
        child: Align(
          child: Text(title,
            textAlign: TextAlign.center,
            style:  TextStyle(
            color: textColor,
              fontSize: 15,
              fontWeight: FontWeight.w500),),
        ),
      ),
    );
  }

}
