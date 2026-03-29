import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:tkd_saas/features/tournament/domain/entities/tournament_entity.dart';
import 'package:tkd_saas/features/tournament/domain/repositories/tournament_repository.dart';
import 'package:tkd_saas/features/tournament/data/models/tournament_model.dart';
import 'package:tkd_saas/core/network/base_supabase_repository.dart';
import 'package:tkd_saas/core/error/failures.dart';

@LazySingleton(as: TournamentRepository)
class SupabaseTournamentRepository extends BaseSupabaseRepository
    implements TournamentRepository {
  SupabaseTournamentRepository(this._supabaseClient);

  final SupabaseClient _supabaseClient;
  static const String _tableName = 'tournaments';

  @override
  Future<Either<Failure, List<TournamentEntity>>> getTournaments({
    int limit = 20,
    int offset = 0,
  }) {
    return executeDbOperation(() async {
      final int to = offset + limit - 1;
      final response = await _supabaseClient
          .from(_tableName)
          .select()
          .order('created_at', ascending: false)
          .range(offset, to);

      return response
          .map((json) => TournamentModel.fromJson(json).toEntity())
          .toList();
    }, contextMsg: 'Failed to get tournaments from Supabase');
  }

  @override
  Future<Either<Failure, TournamentEntity>> getTournament(String id) {
    return executeDbOperation(() async {
      final response = await _supabaseClient
          .from(_tableName)
          .select()
          .eq('id', id)
          .single();

      return TournamentModel.fromJson(response).toEntity();
    }, contextMsg: 'Failed to get tournament $id from Supabase');
  }

  @override
  Future<Either<Failure, TournamentEntity>> createTournament(
    TournamentEntity tournament,
  ) {
    return executeDbOperation(() async {
      final currentUser = _supabaseClient.auth.currentUser;
      if (currentUser == null) {
        throw const ServerFailure('User is not authenticated');
      }

      final nowUtc = DateTime.now().toUtc();

      // Update timestamps and assign user id using entity copyWith before mapping to DTO
      final entityToInsert = tournament.copyWith(
        userId: currentUser.id,
        createdAt: nowUtc,
        updatedAt: nowUtc,
      );

      final model = TournamentModel.fromEntity(entityToInsert);
      final jsonToInsert = model.toJson();

      final response = await _supabaseClient
          .from(_tableName)
          .insert(jsonToInsert)
          .select()
          .single();

      return TournamentModel.fromJson(response).toEntity();
    }, contextMsg: 'Failed to create tournament in Supabase');
  }

  @override
  Future<Either<Failure, TournamentEntity>> updateTournament(
    TournamentEntity tournament,
  ) {
    return executeDbOperation(() async {
      final entityToUpdate = tournament.copyWith(
        updatedAt: DateTime.now().toUtc(),
      );

      final jsonToUpdate = TournamentModel.fromEntity(entityToUpdate).toJson();
      jsonToUpdate.remove('id');
      jsonToUpdate.remove('user_id');
      jsonToUpdate.remove('created_at');

      final response = await _supabaseClient
          .from(_tableName)
          .update(jsonToUpdate)
          .eq('id', tournament.id)
          .select()
          .single();

      return TournamentModel.fromJson(response).toEntity();
    }, contextMsg: 'Failed to update tournament ${tournament.id} in Supabase');
  }

  @override
  Future<Either<Failure, void>> deleteTournament(String id) {
    return executeDbOperation(() async {
      await _supabaseClient.from(_tableName).delete().eq('id', id);
    }, contextMsg: 'Failed to delete tournament $id from Supabase');
  }
}
