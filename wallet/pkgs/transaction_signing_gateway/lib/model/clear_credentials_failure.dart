enum ClearCredentialsFailureType {
  Unknown,
}

class ClearCredentialsFailure {
  // ignore: avoid_field_initializers_in_const_classes
  const ClearCredentialsFailure.unknown([this.cause]) : type = ClearCredentialsFailureType.Unknown;

  final ClearCredentialsFailureType type;
  final dynamic cause;

  @override
  String toString() {
    return 'ClearCredentialsFailure{type: $type, cause: $cause}';
  }
}
