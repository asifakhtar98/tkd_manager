import 'dart:async';
import 'package:fpdart/fpdart.dart';
import 'package:tkd_saas/core/error/failures.dart';
import 'package:tkd_saas/core/utils/supabase_error_handler.dart';

/// Base class for all remote repositories interacting with Supabase.
///
/// Centralizes the execution of arbitrary database queries, wrapping them
/// in a robust `try/catch` and returning [Either<Failure, T>] mapped
/// strictly from `fpdart` to adhere to clean architecture.
abstract class BaseSupabaseRepository {
  const BaseSupabaseRepository();

  /// Executes a [query], safely catches potential exceptions (Network, Postgrest),
  /// maps them via [handleSupabaseError], and returns an [Either].
  ///
  /// [contextMsg] is used for logging purposes to trace which repository method
  /// initiated the failed call.
  Future<Either<Failure, T>> executeDbOperation<T>(
    Future<T> Function() query, {
    required String contextMsg,
  }) async {
    try {
      final result = await query();
      return Right(result);
    } catch (e, st) {
      if (e is Failure) {
        return Left(e);
      }
      final Failure mappedFailure = handleSupabaseError(e, st, contextMsg);
      return Left(mappedFailure);
    }
  }
}
