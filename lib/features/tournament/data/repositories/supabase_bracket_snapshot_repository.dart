

import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tkd_saas/features/tournament/domain/entities/bracket_snapshot.dart';
import 'package:tkd_saas/features/tournament/domain/repositories/bracket_snapshot_repository.dart';
import 'package:tkd_saas/features/tournament/data/models/bracket_snapshot_model.dart';
import 'package:tkd_saas/core/network/base_supabase_repository.dart';
import 'package:tkd_saas/core/error/failures.dart';

@LazySingleton(as: BracketSnapshotRepository)
class SupabaseBracketSnapshotRepository extends BaseSupabaseRepository implements BracketSnapshotRepository {
  SupabaseBracketSnapshotRepository(this._supabaseClient);

  final SupabaseClient _supabaseClient;
  static const String _tableName = 'bracket_snapshots';

  @override
  Future<Either<Failure, List<BracketSnapshot>>> getBracketSnapshots(String tournamentId) {
    return executeDbOperation(() async {
      final response = await _supabaseClient
          .from(_tableName)
          .select()
          .eq('tournament_id', tournamentId)
          .order('generated_at', ascending: false);
      
      return response.map((json) => BracketSnapshotModel.fromJson(json).toEntity()).toList();
    }, contextMsg: 'Failed to get bracket snapshots for tournament $tournamentId');
  }

  @override
  Future<Either<Failure, BracketSnapshot>> getBracketSnapshot(String id) {
    return executeDbOperation(() async {
      final response = await _supabaseClient
          .from(_tableName)
          .select()
          .eq('id', id)
          .single();
          
      return BracketSnapshotModel.fromJson(response).toEntity();
    }, contextMsg: 'Failed to get bracket snapshot $id');
  }

  @override
  Future<Either<Failure, BracketSnapshot>> createBracketSnapshot(BracketSnapshot snapshot, String tournamentId) {
    return executeDbOperation(() async {
      final currentUser = _supabaseClient.auth.currentUser;
      if (currentUser == null) {
        throw const ServerFailure('User is not authenticated'); // Caught by executeDbOperation
      }
      
      final nowUtc = DateTime.now().toUtc();
      
      final entityToInsert = snapshot.copyWith(
        tournamentId: tournamentId,
        userId: currentUser.id,
        generatedAt: nowUtc,
        updatedAt: nowUtc,
      );
      
      final jsonToInsert = BracketSnapshotModel.fromEntity(entityToInsert).toJson();
      
      final response = await _supabaseClient
          .from(_tableName)
          .insert(jsonToInsert)
          .select()
          .single();
          
      return BracketSnapshotModel.fromJson(response).toEntity();
    }, contextMsg: 'Failed to create bracket snapshot');
  }

  @override
  Future<Either<Failure, BracketSnapshot>> updateBracketSnapshot(BracketSnapshot snapshot) {
    return executeDbOperation(() async {
      final entityToUpdate = snapshot.copyWith(
        updatedAt: DateTime.now().toUtc(),
      );
      
      final jsonToUpdate = BracketSnapshotModel.fromEntity(entityToUpdate).toJson();
      jsonToUpdate.remove('id');
      jsonToUpdate.remove('user_id');
      jsonToUpdate.remove('tournament_id');
      jsonToUpdate.remove('generated_at');

      final response = await _supabaseClient
          .from(_tableName)
          .update(jsonToUpdate)
          .eq('id', snapshot.id)
          .select()
          .single();
          
      return BracketSnapshotModel.fromJson(response).toEntity();
    }, contextMsg: 'Failed to update bracket snapshot ${snapshot.id}');
  }

  @override
  Future<Either<Failure, void>> deleteBracketSnapshot(String id) {
    return executeDbOperation(() async {
      await _supabaseClient
          .from(_tableName)
          .delete()
          .eq('id', id);
    }, contextMsg: 'Failed to delete bracket snapshot $id');
  }
}
