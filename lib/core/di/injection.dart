import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';
import 'package:tkd_saas/features/bracket/data/services/single_elimination_bracket_generator_service_implementation.dart';
import 'package:tkd_saas/features/bracket/data/services/double_elimination_bracket_generator_service_implementation.dart';
import 'package:tkd_saas/features/bracket/domain/services/single_elimination_bracket_generator_service.dart';
import 'package:tkd_saas/features/bracket/domain/services/double_elimination_bracket_generator_service.dart';
import 'package:tkd_saas/features/bracket/presentation/bloc/bracket_bloc.dart';

/// The global service locator instance.
final GetIt getIt = GetIt.instance;

/// Call once in [main] before [runApp].
/// Registers all singletons and factories used across the app.
void configureDependencies() {
  // External / third-party
  getIt.registerLazySingleton<Uuid>(() => const Uuid());

  // Domain services — registered against their interface for testability.
  getIt.registerLazySingleton<SingleEliminationBracketGeneratorService>(
    () => SingleEliminationBracketGeneratorServiceImplementation(
      getIt<Uuid>(),
    ),
  );

  getIt.registerLazySingleton<DoubleEliminationBracketGeneratorService>(
    () => DoubleEliminationBracketGeneratorServiceImplementation(
      getIt<Uuid>(),
    ),
  );

  // BloC — factory so each bracket screen gets a fresh instance.
  getIt.registerFactory<BracketBloc>(
    () => BracketBloc(
      singleElimService: getIt<SingleEliminationBracketGeneratorService>(),
      doubleElimService: getIt<DoubleEliminationBracketGeneratorService>(),
    ),
  );
}
