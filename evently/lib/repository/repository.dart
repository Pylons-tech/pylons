import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:evently/generated/locale_keys.g.dart';
import 'package:evently/models/picked_file_model.dart';
import 'package:evently/utils/failure/failure.dart';
import 'package:evently/utils/file_utils_helper.dart';
import 'package:injectable/injectable.dart';

abstract class Repository {
  Future<Either<Failure, PickedFileModel>> pickFile();
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
}
