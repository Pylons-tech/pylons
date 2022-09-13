enum AccountDerivationFailType {
  invalidMnemonic,
  derivatorNotFound,
  unknown,
}

abstract class AccountDerivationFailure {
  AccountDerivationFailType get type;
}

class InvalidMnemonicFailure implements AccountDerivationFailure {
  const InvalidMnemonicFailure(this.cause, {this.stack});

  final dynamic cause;
  final dynamic stack;

  @override
  AccountDerivationFailType get type => AccountDerivationFailType.invalidMnemonic;

  @override
  String toString() {
    return 'InvalidMnemonicFailure{cause: $cause\n${stack == null ? '' : 'stack:\n$stack'}';
  }
}

class DerivatorNotFoundFailure implements AccountDerivationFailure {
  const DerivatorNotFoundFailure();

  @override
  AccountDerivationFailType get type => AccountDerivationFailType.derivatorNotFound;

  @override
  String toString() => 'DerivatorNotFoundFailure';
}

class UnknownNotFoundFailure implements AccountDerivationFailure {
  const UnknownNotFoundFailure(this.failure);

  final Object failure;

  @override
  AccountDerivationFailType get type => AccountDerivationFailType.unknown;

  @override
  String toString() => 'UnknownNotFoundFailure{fail: $failure}';
}
