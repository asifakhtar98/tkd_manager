import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tkd_saas/core/shared/data/models/activation_request_model.dart';
import 'package:tkd_saas/features/activation/data/models/user_activation_model.dart';

abstract class AdminActivationRemoteDataSource {
  Future<List<ActivationRequestModel>> fetchAllPendingActivationRequests();
  Future<UserActivationModel?> fetchUserActivationByUserId(String userId);
  Future<void> insertUserActivation({
    required String userId,
    required DateTime expiresAt,
  });
  Future<void> updateUserActivationExpiresAt({
    required String userId,
    required DateTime newExpiresAt,
  });
  Future<void> updateActivationRequestStatus({
    required String requestId,
    required String newStatus,
  });
}

@LazySingleton(as: AdminActivationRemoteDataSource)
class AdminActivationRemoteDataSourceImpl
    implements AdminActivationRemoteDataSource {
  final SupabaseClient _supabaseClient;

  AdminActivationRemoteDataSourceImpl(this._supabaseClient);

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
