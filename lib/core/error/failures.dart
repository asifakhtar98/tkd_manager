/// Base failure class used as the Left side of `Either<Failure, T>` returns.
///
/// All domain-specific failures extend this class and optionally override
/// the default [message] to provide contextual error information.
sealed class Failure {
  const Failure(this.message);

  /// Human-readable error message suitable for logging or display.
  final String message;

  @override
  String toString() => '$runtimeType(message: $message)';
}

/// Failure originating from Supabase or any remote API call.
class ServerFailure extends Failure {
  const ServerFailure([super.message = 'An unexpected server error occurred.']);
}

/// Failure originating from the local Drift database layer.
class DatabaseFailure extends Failure {
  const DatabaseFailure([super.message = 'A local database error occurred.']);
}

/// Failure from the bracket or seeding generation engine.
///
/// Typically thrown when participant counts are invalid or bracket
/// configuration rules are violated.
class GenerationFailure extends Failure {
  const GenerationFailure(
      [super.message = 'Bracket generation failed.']);
}
