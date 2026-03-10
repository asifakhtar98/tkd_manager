/// Base failure class used as the Left side of [Either<Failure, T>] returns.
abstract class Failure {
  const Failure(this.message);
  final String message;

  @override
  String toString() => '$runtimeType(message: $message)';
}

/// Failure from Supabase or any remote API call.
class ServerFailure extends Failure {
  const ServerFailure([super.message = 'An unexpected server error occurred.']);
}

/// Failure from the local Drift database.
class DatabaseFailure extends Failure {
  const DatabaseFailure([super.message = 'A local database error occurred.']);
}

/// Failure from the bracket / seeding generation engine.
class GenerationFailure extends Failure {
  const GenerationFailure([super.message = 'Bracket generation failed.']);
}
