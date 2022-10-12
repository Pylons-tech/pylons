import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);
}

class RecipeNotFoundFailure extends Failure {
  const RecipeNotFoundFailure(String message) : super(message);

  @override
  List<Object?> get props => [message];
}

class CookBookNotFoundFailure extends Failure {
  const CookBookNotFoundFailure(String message) : super(message);

  @override
  List<Object?> get props => [message];
}

class NoInternetFailure extends Failure {
  const NoInternetFailure(String message) : super(message);

  @override
  List<Object?> get props => [message];
}

class InvalidInputFailure extends Failure {
  const InvalidInputFailure(String message) : super(message);

  @override
  List<Object?> get props => [message];
}

class CacheFailure extends Failure {
  const CacheFailure(String message) : super(message);

  @override
  List<Object?> get props => [message];
}

class PlatformFailure extends Failure {
  const PlatformFailure(String message) : super(message);

  @override
  List<Object?> get props => [message];
}

class UploadFailedFailure extends Failure {
  const UploadFailedFailure({required String message}) : super(message);

  @override
  List<Object?> get props => [message];
}

class PickingFileFailure extends Failure {
  const PickingFileFailure({required String message}) : super(message);

  @override
  List<Object?> get props => [message];
}

class CompressingFileFailure extends Failure {
  const CompressingFileFailure({required String message}) : super(message);

  @override
  List<Object?> get props => [message];
}

class UrlLaunchingFileFailure extends Failure {
  const UrlLaunchingFileFailure({required String message}) : super(message);

  @override
  List<Object?> get props => [message];
}


class AnalyticsFailure extends Failure {
  const AnalyticsFailure({required String message}) : super(message);

  @override
  List<Object?> get props => [message];
}
