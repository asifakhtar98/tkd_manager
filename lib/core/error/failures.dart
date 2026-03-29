/// Base failure class used as the Left side of `Either<Failure, T>` returns.
///
/// All domain-specific failures extend this class and optionally override
/// the default [message] to provide contextual error information.
sealed class Failure {
  const Failure(this.message);

  /// Human-readable error message suitable for logging or display.
  final String message;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Failure &&
        other.runtimeType == runtimeType &&
        other.message == message;
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() => '$runtimeType(message: $message)';
}

/// Failure originating from Supabase or any remote API call.
class ServerFailure extends Failure {
  const ServerFailure([super.message = 'An unexpected server error occurred.']);
}

/// Failure originating from the local or remote database layer.
class DatabaseFailure extends Failure {
  const DatabaseFailure([super.message = 'A database error occurred.']);
}

/// Failure when a requested resource is not found.
class NotFoundFailure extends Failure {
  const NotFoundFailure([
    super.message = 'The requested resource was not found.',
  ]);
}

/// Failure resulting from network connectivity issues (sockets/timeouts).
class NetworkFailure extends Failure {
  const NetworkFailure([
    super.message = 'Network error. Please check your connection.',
  ]);
}

/// Failure from the bracket or seeding generation engine.
///
/// Typically thrown when participant counts are invalid or bracket
/// configuration rules are violated.
class GenerationFailure extends Failure {
  const GenerationFailure([super.message = 'Bracket generation failed.']);
}

/// Failure originating from Supabase authentication operations.
///
/// Wraps [AuthException] messages into the domain failure hierarchy so that
/// the presentation layer can display user-friendly error text without
/// depending on Supabase types directly.
class AuthenticationFailure extends Failure {
  const AuthenticationFailure([
    super.message = 'An authentication error occurred.',
  ]);
}
