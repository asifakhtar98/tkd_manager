import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tkd_saas/core/error/failures.dart';
import 'package:tkd_saas/core/network/base_supabase_repository.dart';
import 'package:tkd_saas/features/bracket/data/models/bracket_theme_preset_model.dart';
import 'package:tkd_saas/features/bracket/domain/entities/bracket_theme_preset_entity.dart';
import 'package:tkd_saas/features/bracket/domain/repositories/bracket_theme_preset_repository.dart';
import 'package:tkd_saas/features/bracket/domain/value_objects/tie_sheet_theme_config.dart';

/// Supabase-backed implementation of [BracketThemePresetRepository].
///
/// Uses [BaseSupabaseRepository.executeDbOperation] for centralised error
/// handling that is consistent with every other repository in the codebase.
/// RLS policies on the `bracket_theme_presets` table ensure users can only
/// access their own rows.
@LazySingleton(as: BracketThemePresetRepository)
class SupabaseBracketThemePresetRepository extends BaseSupabaseRepository
    implements BracketThemePresetRepository {
  final SupabaseClient _supabaseClient;

  static const String _tableName = 'bracket_theme_presets';

  SupabaseBracketThemePresetRepository(this._supabaseClient);

  /// Returns the authenticated user's ID or throws [AuthenticationFailure]
  /// which is caught by [executeDbOperation] and mapped to a Left.
  String get _authenticatedUserId {
    final user = _supabaseClient.auth.currentUser;
    if (user == null) {
      throw const AuthenticationFailure(
        'You must be logged in to manage theme presets.',
      );
    }
    return user.id;
  }

  @override
  Future<Either<Failure, List<BracketThemePresetEntity>>>
  getThemePresetsForUser() {
    return executeDbOperation(() async {
      final userId = _authenticatedUserId;
      final response = await _supabaseClient
          .from(_tableName)
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return response
          .map((json) => BracketThemePresetModel.fromJson(json).toEntity())
          .toList();
    }, contextMsg: 'Failed to fetch bracket theme presets');
  }

  @override
  Future<Either<Failure, BracketThemePresetEntity>> createThemePreset(
    TieSheetThemeConfig themeConfiguration,
  ) {
    return executeDbOperation(() async {
      final userId = _authenticatedUserId;

      final insertData = {
        'user_id': userId,
        'theme_config': themeConfiguration.toJson(),
      };

      final response = await _supabaseClient
          .from(_tableName)
          .insert(insertData)
          .select()
          .single();

      return BracketThemePresetModel.fromJson(response).toEntity();
    }, contextMsg: 'Failed to save bracket theme preset');
  }

  @override
  Future<Either<Failure, void>> deleteThemePreset(String presetId) {
    return executeDbOperation(() async {
      final userId = _authenticatedUserId;
      await _supabaseClient
          .from(_tableName)
          .delete()
          .eq('id', presetId)
          .eq('user_id', userId);
    }, contextMsg: 'Failed to delete bracket theme preset $presetId');
  }
}
