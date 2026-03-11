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
import 'package:tkd_saas/core/di/injection_module.dart' as _i256;
import 'package:tkd_saas/features/bracket/data/services/double_elimination_bracket_generator_service_implementation.dart'
    as _i82;
import 'package:tkd_saas/features/bracket/data/services/match_progression_service_implementation.dart'
    as _i1018;
import 'package:tkd_saas/features/bracket/data/services/single_elimination_bracket_generator_service_implementation.dart'
    as _i34;
import 'package:tkd_saas/features/bracket/domain/services/double_elimination_bracket_generator_service.dart'
    as _i1044;
import 'package:tkd_saas/features/bracket/domain/services/match_progression_service.dart'
    as _i707;
import 'package:tkd_saas/features/bracket/domain/services/single_elimination_bracket_generator_service.dart'
    as _i937;
import 'package:tkd_saas/features/bracket/presentation/bloc/bracket_bloc.dart'
    as _i416;
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
    gh.lazySingleton<_i706.Uuid>(() => appModule.uuid);
    gh.lazySingleton<_i143.TournamentBloc>(() => _i143.TournamentBloc());
    gh.lazySingleton<_i707.MatchProgressionService>(
      () => _i1018.MatchProgressionServiceImplementation(),
    );
    gh.lazySingleton<_i937.SingleEliminationBracketGeneratorService>(
      () => _i34.SingleEliminationBracketGeneratorServiceImplementation(
        gh<_i706.Uuid>(),
      ),
    );
    gh.lazySingleton<_i1044.DoubleEliminationBracketGeneratorService>(
      () => _i82.DoubleEliminationBracketGeneratorServiceImplementation(
        gh<_i706.Uuid>(),
      ),
    );
    gh.factory<_i416.BracketBloc>(
      () => _i416.BracketBloc(
        singleElimService: gh<_i937.SingleEliminationBracketGeneratorService>(),
        doubleElimService:
            gh<_i1044.DoubleEliminationBracketGeneratorService>(),
        matchProgressionService: gh<_i707.MatchProgressionService>(),
        uuid: gh<_i706.Uuid>(),
      ),
    );
    return this;
  }
}

class _$AppModule extends _i256.AppModule {}
