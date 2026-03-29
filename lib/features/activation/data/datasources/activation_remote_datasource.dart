import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/activation_request_model.dart';
import '../models/user_activation_model.dart';

/// Contract for all Supabase activation-related remote calls.
abstract class ActivationRemoteDataSource {
  /// Inserts a new activation request for the currently authenticated user.
  Future<ActivationRequestModel> submitActivationRequest({
    required String contactName,
    required int requestedDays,
    required int totalAmount,
  });

  /// Fetches the `user_activations` row for the current user, or `null`.
  Future<UserActivationModel?> fetchCurrentUserActivation();

  /// Checks if the current user has any activation_requests with `status = 'pending'`.
  Future<bool> hasCurrentUserPendingActivationRequest();

  /// Returns `true` if the current user exists in the `admin_users` table.
  Future<bool> isCurrentUserAdmin();

  /// Fetches all activation requests with `status = 'pending'` (admin only, enforced by RLS).
  Future<List<ActivationRequestModel>> fetchAllPendingActivationRequests();

  /// Fetches the `user_activations` row for a specific [userId], or `null`.
  ///
  /// Admin only — used during the approval flow.
  Future<UserActivationModel?> fetchUserActivationByUserId(String userId);

  /// Inserts a new `user_activations` row (admin only).
  Future<void> insertUserActivation({
    required String userId,
    required DateTime expiresAt,
  });

  /// Updates an existing `user_activations` row (admin only).
  Future<void> updateUserActivationExpiresAt({
    required String userId,
    required DateTime newExpiresAt,
  });

  /// Updates an activation request's status and sets `reviewed_at` to now.
  Future<void> updateActivationRequestStatus({
    required String requestId,
    required String newStatus,
  });
}

@LazySingleton(as: ActivationRemoteDataSource)
class ActivationRemoteDataSourceImpl implements ActivationRemoteDataSource {
  final SupabaseClient _supabaseClient;

  ActivationRemoteDataSourceImpl(this._supabaseClient);

  String get _currentUserId => _supabaseClient.auth.currentUser!.id;

  @override
  Future<ActivationRequestModel> submitActivationRequest({
    required String contactName,
    required int requestedDays,
    required int totalAmount,
  }) async {
    final response = await _supabaseClient
        .from('activation_requests')
        .insert({
          'user_id': _currentUserId,
          'contact_name': contactName,
          'requested_days': requestedDays,
          'total_amount': totalAmount,
          'status': 'pending',
        })
        .select()
        .single();

    return ActivationRequestModel.fromJson(response);
  }

  @override
  Future<UserActivationModel?> fetchCurrentUserActivation() async {
    final response = await _supabaseClient
        .from('user_activations')
        .select()
        .eq('user_id', _currentUserId)
        .maybeSingle();

    if (response == null) return null;
    return UserActivationModel.fromJson(response);
  }

  @override
  Future<bool> hasCurrentUserPendingActivationRequest() async {
    final response = await _supabaseClient
        .from('activation_requests')
        .select('id')
        .eq('user_id', _currentUserId)
        .eq('status', 'pending')
        .limit(1);

    return (response as List).isNotEmpty;
  }

  @override
  Future<bool> isCurrentUserAdmin() async {
    final response = await _supabaseClient
        .from('admin_users')
        .select('user_id')
        .eq('user_id', _currentUserId)
        .maybeSingle();

    return response != null;
  }

  @override
  Future<List<ActivationRequestModel>>
  fetchAllPendingActivationRequests() async {
    final response = await _supabaseClient
        .from('activation_requests')
        .select()
        .eq('status', 'pending')
        .order('created_at', ascending: true);

    return (response as List)
        .map(
          (json) =>
              ActivationRequestModel.fromJson(json as Map<String, dynamic>),
        )
        .toList();
  }

  @override
  Future<UserActivationModel?> fetchUserActivationByUserId(
    String userId,
  ) async {
    final response = await _supabaseClient
        .from('user_activations')
        .select()
        .eq('user_id', userId)
        .maybeSingle();

    if (response == null) return null;
    return UserActivationModel.fromJson(response);
  }

  @override
  Future<void> insertUserActivation({
    required String userId,
    required DateTime expiresAt,
  }) async {
    await _supabaseClient.from('user_activations').insert({
      'user_id': userId,
      'expires_at': expiresAt.toUtc().toIso8601String(),
    });
  }

  @override
  Future<void> updateUserActivationExpiresAt({
    required String userId,
    required DateTime newExpiresAt,
  }) async {
    await _supabaseClient
        .from('user_activations')
        .update({
          'expires_at': newExpiresAt.toUtc().toIso8601String(),
          'updated_at': DateTime.now().toUtc().toIso8601String(),
        })
        .eq('user_id', userId);
  }

  @override
  Future<void> updateActivationRequestStatus({
    required String requestId,
    required String newStatus,
  }) async {
    await _supabaseClient
        .from('activation_requests')
        .update({
          'status': newStatus,
          'reviewed_at': DateTime.now().toUtc().toIso8601String(),
        })
        .eq('id', requestId);
  }
}
