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

class StripeFailure extends Failure {
  const StripeFailure(String message) : super(message);
  @override
  List<Object?> get props => [message];
}

class WalletCreationFailure extends Failure {
  const WalletCreationFailure(String message) : super(message);

  @override
  List<Object?> get props => [message];
}

class ExecutionNotFoundFailure extends Failure {
  const ExecutionNotFoundFailure(String message) : super(message);

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure(String message) : super(message);

  @override
  List<Object?> get props => [message];
}

class ItemNotFoundFailure extends Failure {
  const ItemNotFoundFailure(String message) : super(message);

  @override
  List<Object?> get props => [message];
}

class TradeNotFoundFailure extends Failure {
  const TradeNotFoundFailure(String message) : super(message);

  @override
  List<Object?> get props => [message];
}

class UsernameAddressFoundFailure extends Failure {
  const UsernameAddressFoundFailure(String message) : super(message);

  @override
  List<Object?> get props => [message];
}

class InvalidInputFailure extends Failure {
  const InvalidInputFailure(String message) : super(message);

  @override
  List<Object?> get props => [message];
}

class AccountAlreadyExistsFailure extends Failure {
  const AccountAlreadyExistsFailure(String message) : super(message);

  @override
  List<Object?> get props => [message];
}

class AccountCreationFailure extends Failure {
  const AccountCreationFailure(String message) : super(message);

  @override
  List<Object?> get props => [message];
}

class CacheFailure extends Failure {
  const CacheFailure(String message) : super(message);

  @override
  List<Object?> get props => [message];
}

class FirebaseDynamicLinkFailure extends Failure {
  const FirebaseDynamicLinkFailure(String message) : super(message);

  @override
  List<Object?> get props => [message];
}

class PlatformFailure extends Failure {
  const PlatformFailure(String message) : super(message);

  @override
  List<Object?> get props => [message];
}

class TransactionSigningFailure extends Failure {
  final String type;

  const TransactionSigningFailure({required String message, required this.type})
      : super(message);

  @override
  List<Object?> get props => [message, type];
}

class SignInFailedFailure extends Failure {
  const SignInFailedFailure({required String message}) : super(message);

  @override
  List<Object?> get props => [message];
}

class UploadFailedFailure extends Failure {
  const UploadFailedFailure({required String message}) : super(message);

  @override
  List<Object?> get props => [message];
}

class ICloudInitializationFailedFailure extends Failure {
  const ICloudInitializationFailedFailure({required String message})
      : super(message);

  @override
  List<Object?> get props => [message];
}

class InAppPurchaseFailure extends Failure {
  const InAppPurchaseFailure({required String message}) : super(message);

  @override
  List<Object?> get props => [message];
}

class FetchAllNotificationFailure extends Failure {
  const FetchAllNotificationFailure({required String message}) : super(message);

  @override
  List<Object?> get props => [message];
}

class FcmTokenRetrievalError extends Failure {
  const FcmTokenRetrievalError(String message) : super(message);

  @override
  List<Object?> get props => [message];
}

class AppCheckTokenFailure extends Failure {
  const AppCheckTokenFailure(String message) : super(message);

  @override
  List<Object?> get props => [message];
}

class UpdateFcmTokenFailure extends Failure {
  const UpdateFcmTokenFailure({required String message}) : super(message);

  @override
  List<Object?> get props => [message];
}

class FetchNftOwnershipHistoryFailure extends Failure {
  const FetchNftOwnershipHistoryFailure({required String message})
      : super(message);

  @override
  List<Object?> get props => [message];
}

class AppCheckTokenCreationFailure extends Failure {
  const AppCheckTokenCreationFailure({required String message})
      : super(message);

  @override
  List<Object?> get props => [message];
}

class MarkReadNotificationFailure extends Failure {
  const MarkReadNotificationFailure({required String message}) : super(message);

  @override
  List<Object?> get props => [message];
}
