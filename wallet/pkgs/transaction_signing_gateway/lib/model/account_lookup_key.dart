import 'package:equatable/equatable.dart';

class AccountLookupKey extends Equatable {
  const AccountLookupKey({
    required this.chainId,
    required this.accountId,
    required this.password,
  });

  final String chainId;
  final String accountId;
  final String password;

  @override
  List<Object?> get props => [
        chainId,
        accountId,
        password,
      ];
}
