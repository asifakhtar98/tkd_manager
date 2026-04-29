// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:supabase_flutter/supabase_flutter.dart' as _i454;
import 'package:tkd_saas/core/di/injection_module.dart' as _i256;
import 'package:tkd_saas/features/activation/data/datasources/activation_remote_datasource.dart'
    as _i423;
import 'package:tkd_saas/features/activation/data/repositories/activation_repository_impl.dart'
    as _i1013;
import 'package:tkd_saas/features/activation/domain/repositories/i_activation_repository.dart'
    as _i936;
import 'package:tkd_saas/features/activation/presentation/bloc/activation_bloc.dart'
    as _i84;
import 'package:tkd_saas/features/activation/presentation/bloc/activation_status_bloc.dart'
    as _i558;
import 'package:tkd_saas/features/admin/activation_review/data/datasources/admin_activation_remote_datasource.dart'
    as _i782;
import 'package:tkd_saas/features/admin/activation_review/data/repositories/admin_activation_repository_impl.dart'
    as _i453;
import 'package:tkd_saas/features/admin/activation_review/domain/repositories/admin_activation_repository.dart'
    as _i34;
import 'package:tkd_saas/features/admin/activation_review/presentation/bloc/admin_activation_bloc.dart'
    as _i1054;
import 'package:tkd_saas/features/auth/data/repositories/authentication_repository_implementation.dart'
    as _i330;
import 'package:tkd_saas/features/auth/domain/repositories/authentication_repository.dart'
    as _i791;
import 'package:tkd_saas/features/auth/presentation/bloc/authentication_bloc.dart'
    as _i923;
import 'package:tkd_saas/features/bracket/data/repositories/supabase_bracket_theme_preset_repository.dart'
    as _i854;
import 'package:tkd_saas/features/bracket/data/services/double_elimination_bracket_generator_service_implementation.dart'
    as _i82;
import 'package:tkd_saas/features/bracket/data/services/match_progression_service_implementation.dart'
    as _i1018;
import 'package:tkd_saas/features/bracket/data/services/participant_shuffle_service_implementation.dart'
    as _i92;
import 'package:tkd_saas/features/bracket/data/services/single_elimination_bracket_generator_service_implementation.dart'
    as _i34;
import 'package:tkd_saas/features/bracket/domain/repositories/bracket_theme_preset_repository.dart'
    as _i1033;
import 'package:tkd_saas/features/bracket/domain/services/double_elimination_bracket_generator_service.dart'
    as _i1044;
import 'package:tkd_saas/features/bracket/domain/services/match_progression_service.dart'
    as _i707;
import 'package:tkd_saas/features/bracket/domain/services/participant_shuffle_service.dart'
    as _i648;
import 'package:tkd_saas/features/bracket/domain/services/single_elimination_bracket_generator_service.dart'
    as _i937;
import 'package:tkd_saas/features/bracket/presentation/bloc/bracket_bloc.dart'
    as _i416;
import 'package:tkd_saas/features/bracket/presentation/bloc/bracket_theme_preset_bloc.dart'
    as _i973;
import 'package:tkd_saas/features/bracket/presentation/bloc/bracket_theme_selection_bloc.dart'
    as _i225;
import 'package:tkd_saas/features/profile/presentation/bloc/profile_bloc.dart'
    as _i882;
import 'package:tkd_saas/features/setup_bracket/presentation/bloc/setup_bracket_bloc.dart'
    as _i366;
import 'package:tkd_saas/features/tournament/data/repositories/supabase_bracket_snapshot_repository.dart'
    as _i900;
import 'package:tkd_saas/features/tournament/data/repositories/supabase_tournament_repository.dart'
    as _i987;
import 'package:tkd_saas/features/tournament/domain/repositories/bracket_snapshot_repository.dart'
    as _i529;
import 'package:tkd_saas/features/tournament/domain/repositories/tournament_repository.dart'
    as _i547;
import 'package:tkd_saas/features/tournament/presentation/bloc/tournament_bloc.dart'
    as _i143;
import 'package:uuid/uuid.dart' as _i706;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appModule = _$AppModule();
    gh.factory<_i225.BracketThemeSelectionBloc>(
      () => _i225.BracketThemeSelectionBloc(),
    );
    gh.lazySingleton<_i706.Uuid>(() => appModule.uuid);
    gh.lazySingleton<_i454.SupabaseClient>(() => appModule.supabaseClient);
    gh.lazySingleton<_i707.MatchProgressionService>(
      () => _i1018.MatchProgressionServiceImplementation(),
    );
    gh.lazySingleton<_i937.SingleEliminationBracketGeneratorService>(
      () => _i34.SingleEliminationBracketGeneratorServiceImplementation(
        gh<_i706.Uuid>(),
      ),
    );
    gh.lazySingleton<_i648.ParticipantShuffleService>(
      () => _i92.ParticipantShuffleServiceImplementation(),
    );
    gh.lazySingleton<_i1044.DoubleEliminationBracketGeneratorService>(
      () => _i82.DoubleEliminationBracketGeneratorServiceImplementation(
        gh<_i706.Uuid>(),
      ),
    );
    gh.lazySingleton<_i782.AdminActivationRemoteDataSource>(
      () =>
          _i782.AdminActivationRemoteDataSourceImpl(gh<_i454.SupabaseClient>()),
    );
    gh.lazySingleton<_i529.BracketSnapshotRepository>(
      () => _i900.SupabaseBracketSnapshotRepository(gh<_i454.SupabaseClient>()),
    );
    gh.lazySingleton<_i1033.BracketThemePresetRepository>(
      () => _i854.SupabaseBracketThemePresetRepository(
        gh<_i454.SupabaseClient>(),
      ),
    );
    gh.lazySingleton<_i547.TournamentRepository>(
      () => _i987.SupabaseTournamentRepository(gh<_i454.SupabaseClient>()),
    );
    gh.lazySingleton<_i423.ActivationRemoteDataSource>(
      () => _i423.ActivationRemoteDataSourceImpl(gh<_i454.SupabaseClient>()),
    );
    gh.factoryParam<_i366.SetupBracketBloc, String, dynamic>(
      (tournamentId, _) =>
          _i366.SetupBracketBloc(tournamentId, gh<_i706.Uuid>()),
    );
    gh.lazySingleton<_i791.AuthenticationRepository>(
      () => _i330.AuthenticationRepositoryImplementation(
        gh<_i454.SupabaseClient>(),
      ),
    );
    gh.factory<_i973.BracketThemePresetBloc>(
      () => _i973.BracketThemePresetBloc(
        gh<_i1033.BracketThemePresetRepository>(),
      ),
    );
    gh.factory<_i882.ProfileBloc>(
      () => _i882.ProfileBloc(
        authenticationRepository: gh<_i791.AuthenticationRepository>(),
      ),
    );
    gh.factoryParam<
      _i923.AuthenticationBloc,
      _i923.IsEmailConfirmationRedirectPredicate?,
      dynamic
    >(
      (isEmailConfirmationRedirect, _) => _i923.AuthenticationBloc(
        authenticationRepository: gh<_i791.AuthenticationRepository>(),
        isEmailConfirmationRedirect: isEmailConfirmationRedirect,
      ),
    );
    gh.lazySingleton<_i34.IAdminActivationRepository>(
      () => _i453.AdminActivationRepositoryImpl(
        gh<_i782.AdminActivationRemoteDataSource>(),
        gh<_i423.ActivationRemoteDataSource>(),
      ),
    );
    gh.factory<_i416.BracketBloc>(
      () => _i416.BracketBloc(
        gh<_i937.SingleEliminationBracketGeneratorService>(),
        gh<_i1044.DoubleEliminationBracketGeneratorService>(),
        gh<_i707.MatchProgressionService>(),
        gh<_i648.ParticipantShuffleService>(),
        gh<_i706.Uuid>(),
        gh<_i529.BracketSnapshotRepository>(),
      ),
    );
    gh.lazySingleton<_i143.TournamentBloc>(
      () => _i143.TournamentBloc(
        gh<_i547.TournamentRepository>(),
        gh<_i529.BracketSnapshotRepository>(),
      ),
    );
    gh.factory<_i1054.AdminActivationBloc>(
      () => _i1054.AdminActivationBloc(gh<_i34.IAdminActivationRepository>()),
    );
    gh.lazySingleton<_i936.IActivationRepository>(
      () => _i1013.ActivationRepositoryImpl(
        gh<_i423.ActivationRemoteDataSource>(),
      ),
    );
    gh.factory<_i84.ActivationBloc>(
      () => _i84.ActivationBloc(gh<_i936.IActivationRepository>()),
    );
    gh.lazySingleton<_i558.ActivationStatusBloc>(
      () => _i558.ActivationStatusBloc(gh<_i936.IActivationRepository>()),
    );
    return this;
  }
}

class _$AppModule extends _i256.AppModule {}
