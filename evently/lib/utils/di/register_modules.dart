// coverage: false
// coverage:ignore-file
// Injectable is a convenient code generator for get_it.
// All you have to do now is annotate your injectable classes with @injectable and let the generator do the work.
// This class is use to generate code to register objects on app start
import 'package:file_picker/file_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:injectable/injectable.dart';

@module
abstract class RegisterModule {
  @LazySingleton()
  ImageCropper get imageCropper => ImageCropper();

  @LazySingleton()
  FilePicker get filePicker => FilePicker.platform;
}
