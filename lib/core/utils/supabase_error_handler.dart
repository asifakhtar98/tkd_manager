import 'dart:async';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tkd_saas/core/error/failures.dart';
import 'dart:developer';

/// Maps diverse Supabase/Postgrest exceptions to our clean architecture [Failure]s.
Failure handleSupabaseError(Object error, StackTrace st, String contextMsg) {
  log(contextMsg, error: error, stackTrace: st);

  if (error is PostgrestException) {
    if (error.code == 'PGRST116') {
      return NotFoundFailure('Resource not found: ${error.message}');
    } else if (error.code == '42501') {
      return DatabaseFailure('Unauthorized access or RLS violation: ${error.message}');
    } else if (error.code != null && error.code!.startsWith('23')) {
      return DatabaseFailure('Database constraint violation: ${error.message}');
    } else {
      return DatabaseFailure('Unexpected database error: ${error.message}');
    }
  } else if (error is SocketException || error is TimeoutException) {
    return const NetworkFailure('Network error. Please check your connection.');
  }

  return ServerFailure('An unexpected error occurred: $contextMsg');
}
