import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);
}

class PickingFileFailure extends Failure {
  const PickingFileFailure({required String message}) : super(message);

  @override
  List<Object?> get props => [message];
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);

  @override
  List<Object?> get props => [message];
}

class NoInternetFailure extends Failure {
  const NoInternetFailure(super.message);

  @override
  List<Object?> get props => [message];
}

class CookBookNotFoundFailure extends Failure {
  const CookBookNotFoundFailure(super.message);

  @override
  List<Object?> get props => [message];
}
