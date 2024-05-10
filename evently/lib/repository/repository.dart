import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:evently/generated/locale_keys.g.dart';
import 'package:evently/models/picked_file_model.dart';
import 'package:evently/utils/failure/failure.dart';
import 'package:evently/utils/file_utils_helper.dart';
import 'package:injectable/injectable.dart';

abstract class Repository {
  /// This function picks a file from device storage
  /// Input: [format] it is the file format which needs to be picked from local storage
  /// returns [PickedFileModel] the selected file or [Failure] if aborted
  Future<Either<Failure, PickedFileModel>> pickFile();

  /// This method will generate evently Id for the event
  /// Output: [String] the id of the Event that is going to be added in the recipe
  String autoGenerateEventlyId();
}

@LazySingleton(as: Repository)
class RepositoryImp implements Repository {
  RepositoryImp({required this.fileUtilsHelper});

  final FileUtilsHelper fileUtilsHelper;

  @override
  Future<Either<Failure, PickedFileModel>> pickFile() async {
    try {
      final PickedFileModel pickedFileModel = await fileUtilsHelper.pickFile();

      return Right(pickedFileModel);
    } on Exception catch (_) {
      return Left(PickingFileFailure(message: LocaleKeys.picking_file_error.tr()));
    }
  }

  @override
  String autoGenerateEventlyId() {
    // TODO: implement autoGenerateEaselId
    throw UnimplementedError();
  }
}
