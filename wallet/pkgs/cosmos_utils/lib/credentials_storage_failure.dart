class CredentialsStorageFailure {
  const CredentialsStorageFailure(this.message, {this.cause, this.stack});

  final String message;
  final dynamic cause;

  final dynamic stack;

  @override
  String toString() {
    return 'CredentialsStorageFailure{message: $message'
        '${cause != null ? '\ncause: $cause' : ''}'
        '${stack != null ? '\nstack: $stack' : ''}'
        '}';
  }
}
