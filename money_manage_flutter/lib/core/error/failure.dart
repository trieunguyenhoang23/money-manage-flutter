abstract class Failure {
  final String message;

  const Failure(this.message);
}

// Use this for API/Server errors
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

// Use this for Isar/Local DB errors
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

enum ValidationCode {
  nameTooShort,
  descriptionEmpty,
  invalidAmount,
  notPickCategory,
  notChangeFormEdit,
}

class ValidationFailure extends Failure {
  final ValidationCode code;

  // We pass a generic message for logging, but the 'code' for the UI
  const ValidationFailure(this.code) : super("Validation Error: $code");
}
