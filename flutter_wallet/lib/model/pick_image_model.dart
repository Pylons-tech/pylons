import 'package:image_picker/image_picker.dart';

class PickImageModel {
  double? maxHeight;
  double? maxWidth;
  int? imageQuality;
  ImageSource imageSource;

  PickImageModel({this.maxHeight,  this.maxWidth,  this.imageQuality, required this.imageSource});
}
