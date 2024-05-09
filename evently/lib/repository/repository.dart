import 'package:evently/utils/file_utils_helper.dart';
import 'package:injectable/injectable.dart';

abstract class Repository {}

@LazySingleton(as: Repository)
class RepositoryImp implements Repository {

  RepositoryImp({required this.fileUtilsHelper});

  final FileUtilsHelper fileUtilsHelper;

}
