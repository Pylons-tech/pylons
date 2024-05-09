import 'package:injectable/injectable.dart';

abstract class Repository {}

@LazySingleton(as: Repository)
class RepositoryImp implements Repository {}
